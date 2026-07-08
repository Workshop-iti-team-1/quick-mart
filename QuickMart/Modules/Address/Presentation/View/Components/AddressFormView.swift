//
//  AddressFormView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//



import SwiftUI



struct AddressFormView: View {
    @Environment(\.colorScheme) var colorScheme // Added for Dark Mode handling
    
    @StateObject var viewModel: AddressFormViewModel
    let router: AppRouter

    @State private var showCountryPicker = false
    @State private var showCityPicker = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                labeledField("First Name", $viewModel.firstName, "Enter first name")
                labeledField("Last Name", $viewModel.lastName, "Enter last name")
                labeledField("Phone Number", $viewModel.phone, "Enter phone number")

                pickerField(
                    title: "Country",
                    value: viewModel.country,
                    placeholder: "Select country"
                ) {
                    showCountryPicker = true
                }

                pickerField(
                    title: "City",
                    value: viewModel.city,
                    placeholder: viewModel.country.isEmpty ? "Select country first" : "Select city"
                ) {
                    if !viewModel.country.isEmpty { showCityPicker = true }
                }

                labeledField("Province", $viewModel.province, "Enter province")
                labeledField("Street Address", $viewModel.address1, "Enter street address")
                labeledField("Postal Code", $viewModel.zip, "Enter postal code")

                if let error = viewModel.errorMessage {
                    Text(error).appTextStyle(.caption, color: .appRed)
                }

                Group {
                    if viewModel.isSaving {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.appButton.opacity(0.6)))
                    } else {
                        AppButton(title: "Save") {
                            viewModel.save()
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.onSaved = { _ in router.pop() }
        }
        .sheet(isPresented: $showCountryPicker) {
            SearchablePickerView(
                title: "Country",
                items: viewModel.countryProvider.countryNames,
                selectedItem: viewModel.country,
                onSelect: { viewModel.selectCountry($0) }
            )
        }
        .sheet(isPresented: $showCityPicker) {
            SearchablePickerView(
                title: "City",
                items: viewModel.availableCities,
                selectedItem: viewModel.city,
                onSelect: { viewModel.selectCity($0) }
            )
        }
    }

    private func labeledField(_ title: String, _ text: Binding<String>, _ placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).appTextStyle(.label, color: .appBlack)
            TextField(placeholder, text: text)
                .padding()
                // Dynamic background applied here
                .background(colorScheme == .dark ? Color(UIColor.darkGray) : Color.grey50)
                .cornerRadius(10)
        }
    }

    private func pickerField(title: String, value: String, placeholder: String, onTap: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).appTextStyle(.label, color: .appBlack)
            Button(action: onTap) {
                HStack {
                    Text(value.isEmpty ? placeholder : value)
                        .appTextStyle(.body, color: value.isEmpty ? .grayText : .appBlack)
                    Spacer()
                    Image(systemName: "chevron.down").foregroundColor(.grey150)
                }
                .padding()
                // Dynamic background applied here
                .background(colorScheme == .dark ? Color(UIColor.darkGray) : Color.grey50)
                .cornerRadius(10)
            }
        }
    }
}
