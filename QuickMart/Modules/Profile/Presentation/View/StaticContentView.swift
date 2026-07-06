//
//  StaticContentView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//
import SwiftUI
struct StaticContentView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let lastUpdated: String
    let sections: [StaticSection]

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(iconColor.opacity(0.12))
                                .frame(width: 72, height: 72)
                            Image(systemName: icon)
                                .font(.system(size: 30))
                                .foregroundColor(iconColor)
                        }
                        Text(title)
                            .appTextStyle(.heading2, color: .appBlack)
                        Text(lastUpdated)
                            .appTextStyle(.caption, color: .grayText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)

                    // Sections
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(Array(sections.enumerated()), id: \.offset) { _, section in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(section.title)
                                    .appTextStyle(.label, color: .appBlack)
                                Text(section.content)
                                    .appTextStyle(.body, color: .grayText)
                                    .lineSpacing(5)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.cardBackground)
                            .cornerRadius(14)
                            .shadow(color: Color.appBlack.opacity(0.04), radius: 6, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
