//
//  FAQsView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import SwiftUI


struct FAQsView: View {
    @State private var expandedId: UUID? = nil

    let faqs: [FAQItem] = [
        FAQItem(question: "How do I track my order?",
                answer: "You can track your order in the Order History section of your profile. You'll also receive email updates with tracking information."),
        FAQItem(question: "What payment methods do you accept?",
                answer: "We accept all major credit cards (Visa, Mastercard, Amex), PayPal, and Apple Pay."),
        FAQItem(question: "How do I return an item?",
                answer: "Items can be returned within 30 days of receipt. Go to Order History, select the order, and tap 'Request Return'. We'll send you a prepaid label."),
        FAQItem(question: "How long does shipping take?",
                answer: "Standard shipping takes 5-7 business days. Express shipping (2-3 days) and overnight options are available at checkout."),
        FAQItem(question: "Can I change or cancel my order?",
                answer: "Orders can be modified or cancelled within 1 hour of placement. After that, please wait for delivery and use our return process."),
        FAQItem(question: "Is my payment information secure?",
                answer: "Yes. We use industry-standard SSL encryption and never store your full card details on our servers."),
        FAQItem(question: "How do I change my password?",
                answer: "Go to Profile → Account Management → Change Password. You'll receive a verification email to confirm the change."),
        FAQItem(question: "Do you ship internationally?",
                answer: "Yes, we ship to over 50 countries. International shipping rates and delivery times vary by destination.")
    ]

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.appMerigold.opacity(0.15))
                                .frame(width: 72, height: 72)
                            Image(systemName: "questionmark.bubble.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.appMerigold)
                        }
                        Text("Frequently Asked Questions")
                            .appTextStyle(.heading2, color: .appBlack)
                            .multilineTextAlignment(.center)
                        Text("Find answers to common questions below")
                            .appTextStyle(.body, color: .grayText)
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 20)

                    VStack(spacing: 10) {
                        ForEach(faqs) { faq in
                            FAQRow(
                                item: faq,
                                isExpanded: expandedId == faq.id
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    expandedId = expandedId == faq.id ? nil : faq.id
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationTitle("FAQs")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FAQRow: View {
    let item: FAQItem
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Text(item.question)
                        .appTextStyle(.label, color: .appBlack)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.cyanPrimary)
                        .frame(width: 20)
                }
                .padding(16)
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider()
                    .padding(.horizontal, 16)
                Text(item.answer)
                    .appTextStyle(.body, color: .grayText)
                    .lineSpacing(4)
                    .padding(16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(14)
        .shadow(color: Color.appBlack.opacity(0.05), radius: 6, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isExpanded ? Color.cyanPrimary.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}
