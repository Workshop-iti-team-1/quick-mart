//
//  AddressFormViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  AddressFormViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//
// Presentation/Address/AddressFormViewModel.swift
import Combine
import Foundation

@MainActor
final class AddressFormViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phone = ""
    @Published var country = ""
    @Published var province = ""
    @Published var city = ""
    @Published var address1 = ""
    @Published var zip = ""
    @Published var isSaving = false
    @Published var errorMessage: String?

    let countryProvider: CountryDataProvider

    private let useCases: AddressUseCases
    private let editingAddress: Address?
    private var cancellables = Set<AnyCancellable>()
    var onSaved: ((Address) -> Void)?

    var isEditing: Bool { editingAddress != nil }
    var title: String { isEditing ? "Edit Address" : "Shipping Address" }
    var isValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !phone.isEmpty && !address1.isEmpty
            && !city.isEmpty && !province.isEmpty && !zip.isEmpty && !country.isEmpty
    }

    var availableCities: [String] {
        country.isEmpty ? [] : countryProvider.cities(for: country)
    }

    init(useCases: AddressUseCases, countryProvider: CountryDataProvider, editingAddress: Address? = nil) {
        self.useCases = useCases
        self.countryProvider = countryProvider
        self.editingAddress = editingAddress

        if let address = editingAddress {
            firstName = address.firstName ?? ""
            lastName = address.lastName ?? ""
            phone = address.phone ?? ""
            province = address.province ?? ""
            city = address.city ?? ""
            address1 = address.address1 ?? ""
            zip = address.zip ?? ""
            country = address.country ?? ""
        }

        countryProvider.loadIfNeeded()

        // Reset city whenever country changes and the old city no longer belongs to it
        $country
            .dropFirst()
            .sink { [weak self] newCountry in
                guard let self else { return }
                let validCities = self.countryProvider.cities(for: newCountry)
                if !validCities.contains(self.city) {
                    self.city = ""
                }
            }
            .store(in: &cancellables)
    }

    func selectCountry(_ name: String) {
        country = name
    }

    func selectCity(_ name: String) {
        city = name
    }

    func save() {
        guard isValid else {
            errorMessage = "Please fill in all required fields."
            return
        }
        isSaving = true
        errorMessage = nil
        let input = AddressInput(firstName: firstName, lastName: lastName, address1: address1,
                                  address2: "", city: city, province: province,
                                  country: country, zip: zip, phone: phone)
        let publisher: AnyPublisher<Address, Error> = editingAddress != nil
            ? useCases.updateAddress(id: editingAddress!.id, input: input)
            : useCases.addAddress(input)

        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isSaving = false
                if case .failure(let error) = completion { self?.errorMessage = error.localizedDescription }
            } receiveValue: { [weak self] savedAddress in
                AddressEventsBus.shared.addressSaved.send(savedAddress)
                self?.onSaved?(savedAddress)
            }
            .store(in: &cancellables)
    }
}
