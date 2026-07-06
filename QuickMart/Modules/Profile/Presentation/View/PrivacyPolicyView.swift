//
//  PrivacyPolicyView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        StaticContentView(
            icon: "shield.lefthalf.filled",
            iconColor: .appBlue,
            title: "Privacy Policy",
            lastUpdated: "Last updated: January 1, 2025",
            sections: [
                StaticSection(title: "Information We Collect",
                    content: "We collect information you provide directly to us, such as when you create an account, make a purchase, or contact us for support. This includes your name, email address, shipping address, and payment information."),
                StaticSection(title: "How We Use Your Information",
                    content: "We use the information we collect to process transactions, send order confirmations, provide customer support, send promotional communications (with your consent), and improve our services."),
                StaticSection(title: "Information Sharing",
                    content: "We do not sell, trade, or otherwise transfer your personally identifiable information to third parties without your consent, except to trusted partners who assist us in operating our app."),
                StaticSection(title: "Data Security",
                    content: "We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction."),
                StaticSection(title: "Your Rights",
                    content: "You have the right to access, correct, or delete your personal data at any time. You may also opt out of marketing communications by following the unsubscribe instructions in any email we send."),
                StaticSection(title: "Contact Us",
                    content: "If you have any questions about this Privacy Policy, please contact us at privacy@quickmart.com")
            ]
        )
    }
}
