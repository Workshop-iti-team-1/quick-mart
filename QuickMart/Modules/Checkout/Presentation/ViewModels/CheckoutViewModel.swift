//
//  CheckoutViewModel.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//
import Foundation
import Combine

@MainActor
final class CheckoutViewModel: ObservableObject {

    // MARK: - Address State

    @Published private(set) var addresses: [Address] = []
    @Published var selectedAddress: Address? = nil
    @Published private(set) var isLoadingAddresses: Bool = false

    // MARK: - Payment State

    @Published var selectedPaymentMethod: PaymentMethod = .applePay
    @Published var isApplePaySheetPresented: Bool = false

    // MARK: - Order Placement State

    @Published private(set) var isPlacingOrder: Bool = false
    @Published private(set) var placedOrder: PlacedOrder? = nil
    @Published private(set) var errorMessage: String? = nil
    @Published var showErrorAlert: Bool = false

    // MARK: - Cart

    private(set) var cart: Cart

    // MARK: - Dependencies

    private let placeOrderUseCase: PlaceOrderUseCaseProtocol
    private let addressUseCases: AddressUseCases
    private let cartUseCases: CartUseCases
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(
        cart: Cart,
        placeOrderUseCase: PlaceOrderUseCaseProtocol,
        addressUseCases: AddressUseCases,
        cartUseCases: CartUseCases
    ) {
        self.cart = cart
        self.placeOrderUseCase = placeOrderUseCase
        self.addressUseCases = addressUseCases
        self.cartUseCases = cartUseCases

        observeAddressEvents()
    }

    // MARK: - Address Loading

    func loadAddresses() {
        isLoadingAddresses = true
        addressUseCases.fetchAddresses()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingAddresses = false
                if case .failure(let error) = completion {
                    self?.showError(error.localizedDescription)
                }
            } receiveValue: { [weak self] addresses in
                guard let self else { return }
                self.addresses = addresses
                // Auto-select default address if none selected yet
                if self.selectedAddress == nil {
                    self.selectedAddress = addresses.first { $0.isDefault }
                        ?? addresses.first
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Address Event Observation
    // Mirrors AddressListViewModel — stays in sync when user adds/edits
    // an address from the shipping addresses screen during checkout

    private func observeAddressEvents() {
        AddressEventsBus.shared.addressSaved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] saved in
                guard let self else { return }
                if let index = self.addresses.firstIndex(where: { $0.id == saved.id }) {
                    self.addresses[index] = saved
                } else {
                    self.addresses.append(saved)
                    // Auto-select newly added address if none selected
                    if self.selectedAddress == nil {
                        self.selectedAddress = saved
                    }
                }
            }
            .store(in: &cancellables)

        AddressEventsBus.shared.defaultAddressChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadAddresses()
            }
            .store(in: &cancellables)
    }

    // MARK: - Payment Intents

    /// Called when user taps the primary pay button.
    /// Apple Pay → shows simulated Face ID sheet first.
    /// COD → places order directly.
    func initiatePayment() {
        guard validateBeforePayment() else { return }

        switch selectedPaymentMethod {
        case .applePay:
            isApplePaySheetPresented = true
        case .cashOnDelivery:
            Task { await placeOrder() }
        }
    }

    /// Called when user confirms on the Apple Pay simulated sheet.
    func confirmApplePay() {
        isApplePaySheetPresented = false
        Task { await placeOrder() }
    }

    // MARK: - Order Placement

    private func placeOrder() async {
        isPlacingOrder = true
        errorMessage = nil

        do {
            let order = try await placeOrderUseCase.execute(
                cart: cart,
                address: selectedAddress,
                paymentMethod: selectedPaymentMethod
            )

            // Clear cart locally + notify tab bar badge
            cartUseCases.clearCart()
            NotificationCenter.default.post(
                name: NSNotification.Name("CartUpdated"),
                object: nil
            )

            placedOrder = order

        } catch {
            showError(error.localizedDescription)
        }

        isPlacingOrder = false
    }

    // MARK: - Validation

    private func validateBeforePayment() -> Bool {
        guard selectedAddress != nil else {
            showError(CheckoutError.noAddressSelected.localizedDescription ?? "")
            return false
        }
        return true
    }

    // MARK: - Helpers

    private func showError(_ message: String) {
        errorMessage = message
        showErrorAlert = true
    }
}
