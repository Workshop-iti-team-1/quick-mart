//
//  TermsAndConditionsView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//
import SwiftUI

struct TermsAndConditionsView: View {
    var body: some View {
        StaticContentView(
            icon: "doc.text.fill",
            iconColor: .appPurple,
            title: "Terms & Conditions",
            lastUpdated: "Last updated: January 1, 2025",
            sections: [
                StaticSection(title: "Acceptance of Terms",
                    content: "By accessing and using QuickMart, you accept and agree to be bound by the terms and provision of this agreement."),
                StaticSection(title: "Use of the App",
                    content: "You agree to use QuickMart only for lawful purposes and in a way that does not infringe the rights of others or restrict their use of the app."),
                StaticSection(title: "Product Information",
                    content: "We strive to display accurate product information. However, we do not warrant that product descriptions or other content is accurate, complete, or error-free."),
                StaticSection(title: "Orders and Payment",
                    content: "All orders are subject to availability. We reserve the right to refuse or cancel any order. Payment must be received before dispatch of goods."),
                StaticSection(title: "Returns & Refunds",
                    content: "Items may be returned within 30 days of receipt in their original condition. Refunds will be processed within 5-10 business days after we receive the returned item."),
                StaticSection(title: "Limitation of Liability",
                    content: "QuickMart shall not be liable for any indirect, incidental, special, or consequential damages resulting from the use or inability to use our services.")
            ]
        )
    }
}
