//
//  AddressListViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


import Combine
import Foundation

@MainActor
final class AddressListViewModel: ObservableObject {
    @Published var addresses: [Address] = []
    @Published var isLoading = false
    @Published var isUpdatingDefault = false
    @Published var errorMessage: String?
    @Published var addressPendingDelete: Address?
    @Published var showDeleteAlert = false
    @Published var showCannotDeleteDefaultAlert = false

    private let useCases: AddressUseCases
    private var cancellables = Set<AnyCancellable>()

    init(useCases: AddressUseCases) {
        self.useCases = useCases
        observeAddressEvents()
    }

    private func observeAddressEvents() {
        // Add / edit from the form screen still patches in directly — that's a different
        // instance's mutation, no need to force a full refetch for it.
        AddressEventsBus.shared.addressSaved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] saved in
                guard let self else { return }
                if let index = self.addresses.firstIndex(where: { $0.id == saved.id }) {
                    self.addresses[index] = saved
                } else {
                    self.addresses.append(saved)
                }
            }
            .store(in: &cancellables)

        AddressEventsBus.shared.addressDeleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] deletedId in
                self?.addresses.removeAll { $0.id == deletedId }
            }
            .store(in: &cancellables)

        // Default changed anywhere — safest is to just reload from server rather than
        // trust local patching, since only ONE address can ever be default.
        AddressEventsBus.shared.defaultAddressChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadAddresses()
            }
            .store(in: &cancellables)
    }

    func loadAddresses() {
        isLoading = true
        errorMessage = nil
        useCases.fetchAddresses()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion { self?.errorMessage = error.localizedDescription }
            } receiveValue: { [weak self] in self?.addresses = $0 }
            .store(in: &cancellables)
    }

    // MARK: - Delete (hard-blocked for default, double-checked here even if UI slips)

    func requestDelete(_ address: Address) {
        guard !address.isDefault else {
            showCannotDeleteDefaultAlert = true
            return
        }
        addressPendingDelete = address
        showDeleteAlert = true
    }

    func confirmDelete() {
        guard let address = addressPendingDelete else { return }

        // Defensive re-check right before firing the network call — refuses even if
        // addressPendingDelete somehow got set to the default address.
        guard !address.isDefault else {
            addressPendingDelete = nil
            showCannotDeleteDefaultAlert = true
            return
        }

        let idToRemove = address.id
        addressPendingDelete = nil

        useCases.deleteAddress(id: idToRemove)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion { self?.errorMessage = error.localizedDescription }
            } receiveValue: { [weak self] deletedId in
                self?.addresses.removeAll { $0.id == deletedId }
                AddressEventsBus.shared.addressDeleted.send(deletedId)
            }
            .store(in: &cancellables)
    }

    // MARK: - Set default (refetch after success = single source of truth)

    func setDefault(_ address: Address) {
        guard !address.isDefault else { return }
        isUpdatingDefault = true
        useCases.setDefaultAddress(id: address.id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isUpdatingDefault = false
                if case .failure(let error) = completion { self?.errorMessage = error.localizedDescription }
            } receiveValue: { [weak self] updated in
                // Refetch instead of trusting local patch — guarantees only ONE
                // address shows the checkbox/tag as default, matching the server exactly.
                self?.loadAddresses()
                AddressEventsBus.shared.defaultAddressChanged.send(updated.id)
            }
            .store(in: &cancellables)
    }
}
