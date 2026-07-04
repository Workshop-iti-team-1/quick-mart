//
//  AddressListView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


import SwiftUI

struct AddressListView: View {
    @StateObject var viewModel: AddressListViewModel
    @ObservedObject private var session = SessionManager.shared
    @Environment(AppRouter.self) private var router

    private var isLoggedIn: Bool { session.currentState == .loggedIn }

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            if !isLoggedIn {
                guestState
            } else if viewModel.isLoading && viewModel.addresses.isEmpty {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.addresses.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(viewModel.addresses) { address in
                        AddressRowView(
                            address: address,
                            onEdit: { router.push(.addressForm(address)) },
                            onSetDefault: { viewModel.setDefault(address) }
                        )
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            if !address.isDefault {
                                Button(role: .destructive) {
                                    viewModel.requestDelete(address)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .swipeActions(edge: .leading) {
                            if !address.isDefault {
                                Button {
                                    viewModel.setDefault(address)
                                } label: {
                                    Label("Set Default", systemImage: "checkmark.circle")
                                }
                                .tint(.cyanPrimary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .disabled(viewModel.isUpdatingDefault)
                .overlay {
                    if viewModel.isUpdatingDefault {
                        ProgressView()
                    }
                }
            }
        }
        .navigationTitle("Shipping Address")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isLoggedIn {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { router.push(.addressForm(nil)) } label: {
                        Image(systemName: "plus").foregroundColor(.appBlack)
                    }
                }
            }
        }
        .alert("Delete Address?", isPresented: $viewModel.showDeleteAlert) {
            Button("Cancel", role: .cancel) { viewModel.addressPendingDelete = nil }
            Button("Delete", role: .destructive) { viewModel.confirmDelete() }
        } message: {
            Text("This action cannot be undone.")
        }
        .alert("Can't Delete", isPresented: $viewModel.showCannotDeleteDefaultAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("This is your default address. Set another address as default before deleting this one.")
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onAppear {
            if isLoggedIn { viewModel.loadAddresses() }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.cyan50)
                    .frame(width: 120, height: 120)
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.cyan50)
            }
            VStack(spacing: 8) {
                Text("No addresses yet")
                    .appTextStyle(.heading2, color: .appBlack)
                Text("Add a shipping address to speed up checkout next time.")
                    .appTextStyle(.body, color: .grayText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            AppButton(title: "Add Address", icon: "plus") {
                router.push(.addressForm(nil))
            }
            .padding(.horizontal, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 60)
    }

    private var guestState: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.cyan50)
                    .frame(width: 120, height: 120)
                Image(systemName: "lock.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.cyanPrimary)
            }
            VStack(spacing: 8) {
                Text("Please log in")
                    .appTextStyle(.heading2, color: .appBlack)
                Text("Log in to add and manage your shipping addresses.")
                    .appTextStyle(.body, color: .grayText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            AppButton(title: "Log In", icon: "arrow.right") {
                router.push(.login)
            }
            .padding(.horizontal, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 60)
    }
}
