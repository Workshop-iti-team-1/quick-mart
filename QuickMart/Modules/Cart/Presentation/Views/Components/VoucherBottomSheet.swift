//
//  VoucherBottomSheet.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//
// Features/Cart/Presentation/Views/Components/VoucherBottomSheet.swift

import SwiftUI

struct VoucherBottomSheet: View {

    @Binding var isPresented: Bool
    @State private var voucherCode: String = ""
    @State private var matchedDiscount: DiscountModel? = nil
    @State private var isFetchingRequirements: Bool = false

    var onApply: (String) -> Void

    private let discountDataSource = DiscountDataSource()

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // MARK: - Header
            Text(AppStrings.Cart.voucherCode)
                .appTextStyle(.heading2, color: .appBlack)
                .padding(.top, 16)

            // MARK: - Input
            CustomTextField(
                title: "",
                placeholder: AppStrings.Cart.enterVoucherCode,
                text: $voucherCode
            )
            .onChange(of: voucherCode) { _, newValue in
                handleCodeChange(newValue)
            }

            // MARK: - Requirements
            // Shown when a matching discount is found in the store
            if isFetchingRequirements {
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.7)
                    Text("Checking requirements...")
                        .appTextStyle(.caption, color: .grayText)
                }
            } else if let discount = matchedDiscount {
                requirementsSection(for: discount)
            }

            // MARK: - Apply Button
            AppButton(title: AppStrings.Cart.apply, verticalPadding: 16) {
                onApply(voucherCode)
                isPresented = false
            }
            .disabled(voucherCode.isEmpty)

            Spacer()
        }
        .padding(24)
        .background(Color.backGround.ignoresSafeArea())
    }

    // MARK: - Requirements Section

    private func requirementsSection(for discount: DiscountModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Voucher Requirements")
                .appTextStyle(.label, color: .appBlack)

            // Title
            HStack(spacing: 8) {
                Image(systemName: "tag.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.cyanPrimary)
                Text(discount.title)
                    .appTextStyle(.label, color: .appBlack)
            }

            // Summary is the human-readable condition from Shopify Admin
            // e.g. "Minimum purchase of $100" or "3 items required"
            if !discount.summary.isEmpty {
                VoucherRequirementView(
                    requirement: discount.summary,
                    isMet: false   // Unknown at this point — user hasn't applied yet
                )
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.grey50)
        )
    }

    // MARK: - Code Change Handler

    /// Debounce-style lookup: fetch discounts and find a match
    /// when the user has typed at least 3 characters.
    private func handleCodeChange(_ code: String) {
        let trimmed = code.trimmingCharacters(in: .whitespaces)
        guard trimmed.count >= 3 else {
            matchedDiscount = nil
            return
        }

        isFetchingRequirements = true

        Task {
            do {
                let discounts = try await discountDataSource.fetchActiveDiscounts()
                await MainActor.run {
                    matchedDiscount = discounts.first {
                        $0.code.lowercased() == trimmed.lowercased()
                    }
                    isFetchingRequirements = false
                }
            } catch {
                await MainActor.run {
                    matchedDiscount = nil
                    isFetchingRequirements = false
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    Color.black.opacity(0.3)
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            VoucherBottomSheet(
                isPresented: .constant(true),
                onApply: { _ in }
            )
            .presentationDetents([.height(400)])
            .presentationDragIndicator(.visible)
        }
}
