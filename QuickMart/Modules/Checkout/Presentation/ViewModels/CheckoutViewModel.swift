import Combine
import Foundation

@MainActor
final class CheckoutViewModel: ObservableObject {

    // MARK: - Address State
    @Published private(set) var addresses: [Address] = []
    @Published var selectedAddress: Address? = nil
    @Published private(set) var isLoadingAddresses: Bool = false

    // MARK: - Payment State
    @Published var selectedPaymentMethod: PaymentMethod = .applePay

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
    private let requestApplePayUseCase: RequestApplePayPaymentUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(
        cart: Cart,
        placeOrderUseCase: PlaceOrderUseCaseProtocol,
        addressUseCases: AddressUseCases,
        cartUseCases: CartUseCases,
        requestApplePayUseCase: RequestApplePayPaymentUseCaseProtocol
    ) {
        self.cart = cart
        self.placeOrderUseCase = placeOrderUseCase
        self.addressUseCases = addressUseCases
        self.cartUseCases = cartUseCases
        self.requestApplePayUseCase = requestApplePayUseCase

        observeAddressEvents()
    }

    var isApplePayAvailable: Bool {
        return requestApplePayUseCase.canMakePayments()
    }

    // MARK: - Address Loading & Events
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
                if self.selectedAddress == nil {
                    self.selectedAddress =
                        addresses.first { $0.isDefault } ?? addresses.first
                }
            }
            .store(in: &cancellables)
    }

    private func observeAddressEvents() {
        AddressEventsBus.shared.addressSaved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] saved in
                guard let self else { return }
                if let index = self.addresses.firstIndex(where: {
                    $0.id == saved.id
                }) {
                    self.addresses[index] = saved
                } else {
                    self.addresses.append(saved)
                    if self.selectedAddress == nil {
                        self.selectedAddress = saved
                    }
                }
            }
            .store(in: &cancellables)

        AddressEventsBus.shared.defaultAddressChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.loadAddresses() }
            .store(in: &cancellables)
    }

    // MARK: - Payment Intents

    func initiatePayment(amount: Double, currencyCode: String) {
        guard validateBeforePayment() else { return }

        switch selectedPaymentMethod {
        case .applePay:
            Task {
                await handleApplePayFlow(
                    amount: amount, currencyCode: currencyCode)
            }
        case .cashOnDelivery:
            Task { await placeOrder() }
        }
    }

    private func handleApplePayFlow(amount: Double, currencyCode: String) async
    {
        isPlacingOrder = true

        let result = await requestApplePayUseCase.execute(
            amount: amount,
            currencyCode: currencyCode
        )

        switch result {
        case .success(let transactionIdentifier):
            print(
                "Native Apple Pay Auth Success! Token: \(transactionIdentifier)"
            )
            await placeOrder()

        case .cancelled:
            print("User dismissed the Apple Pay sheet.")
            isPlacingOrder = false

        case .failed(let error):
            isPlacingOrder = false
            showError(error.localizedDescription)
        }
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

            cartUseCases.clearCart()
//            NotificationCenter.default.post(
//                name: NSNotification.Name("CartUpdated"), object: nil)
            placedOrder = order
            OrderEventsBus.shared.orderPlaced.send(order)

        } catch {
            showError(error.localizedDescription)
        }

        isPlacingOrder = false
    }

    // MARK: - Validation & Helpers
    private func validateBeforePayment() -> Bool {
        guard selectedAddress != nil else {
            showError(
                CheckoutError.noAddressSelected.localizedDescription)
            return false
        }
        return true
    }

    private func showError(_ message: String) {
        errorMessage = message
        showErrorAlert = true
    }
}
