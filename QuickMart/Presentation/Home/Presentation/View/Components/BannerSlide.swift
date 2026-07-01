//
//  BannerSlide.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//


import SwiftUI

// MARK: - Single Slide
struct BannerSlide: View {
    let item: BannerItem

    var body: some View {
        ZStack(alignment: .leading) {
            LinearGradient(
                colors: [
                    Color(item.gradientStart).opacity(0.85),
                    Color(item.gradientEnd).opacity(0.65)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.discount)
                        .appTextStyle(.caption, color: .appWhite)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.30))
                        .cornerRadius(4)

                    Text(item.subtitle)
                        .appTextStyle(.caption, color: .appWhite.opacity(0.85))

                    Text(item.title)
                        .appTextStyle(.heading2, color: .appWhite)
                }
                .padding(.leading, 20)

                Spacer()

                Group {
                    if item.isSystemImage {
                        Image(systemName: item.imageName)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: 120, height: 100)
                .foregroundColor(.white.opacity(0.9))
                .padding(.trailing, 16)
            }
        }
        .frame(height: 160)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.appPurple.opacity(0.5), lineWidth: 2)
        )
    }
}

// MARK: - Page Dots
struct PageIndicator: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<total, id: \.self) { i in
                Circle()
                    .fill(i == current ? Color.cyanPrimary : Color.grey150)
                    .frame(width: i == current ? 8 : 6, height: i == current ? 8 : 6)
                    .animation(.easeInOut(duration: 0.2), value: current)
            }
        }
    }
}

// MARK: - Pager
struct AdBannerPager: View {
    let items: [BannerItem]
    @State private var currentIndex = 0

    var body: some View {
        VStack(spacing: 10) {
            TabView(selection: $currentIndex) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    BannerSlide(item: item)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 160)

            PageIndicator(total: items.count, current: currentIndex)
        }
    }
}
