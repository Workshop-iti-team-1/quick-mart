//
//  SectionHeader.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//



import SwiftUI

struct SectionHeader: View {
    let title: String
    let onSeeAll: (() -> Void)?

    init(title: String, onSeeAll: (() -> Void)? = nil) {
        self.title = title
        self.onSeeAll = onSeeAll
    }

    var body: some View {
        HStack {
            Text(title)
                .appTextStyle(.heading2, color: .appBlack)
            Spacer()
            if let onSeeAll {
                Button(action: onSeeAll) {
                    Text("SEE ALL")
                        .appTextStyle(.caption, color: .cyanPrimary)
                }
            }
        }
    }
}
