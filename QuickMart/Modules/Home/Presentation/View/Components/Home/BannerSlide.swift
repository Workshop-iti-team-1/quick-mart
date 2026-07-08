//
//  BannerSlide.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//

import SwiftUI

struct BannerSlide: View {
    let item: BannerItem
    @State private var showCopied = false
    @State private var showFullDescription = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(item.gradientStart), Color(item.gradientEnd)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {

                    Text(item.discount)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.subtitle)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(2)

                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showFullDescription = true
                            }
                        } label: {
                            Text("Read more")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white)
                                .underline()
                        }
                        .buttonStyle(.plain)
                    }

                    // Copy button
                    Button {
                        UIPasteboard.general.string = item.code
                        withAnimation(.spring(response: 0.3)) { showCopied = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { showCopied = false }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: showCopied ? "checkmark.circle.fill" : "doc.on.doc.fill")
                                .font(.system(size: 11))
                            Text(showCopied ? "Copied!" : item.code)
                                .font(.system(size: 12, weight: .semibold))
                                .lineLimit(1)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.leading, 20)
                .padding(.vertical, 20)

                Spacer()

                Image(systemName: item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.trailing, 20)
            }
        }
        .frame(height: 150)
        .cornerRadius(20)
        .shadow(color: Color(item.gradientStart).opacity(0.25), radius: 8, x: 0, y: 4)
        .sheet(isPresented: $showFullDescription) {
            DiscountDetailSheet(item: item, showCopied: $showCopied)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
        }
    }
}

// MARK: - Detail Sheet
struct DiscountDetailSheet: View {
    let item: BannerItem
    @Binding var showCopied: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            // Gradient header
            LinearGradient(
                colors: [Color(item.gradientStart), Color(item.gradientEnd)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 160)
            .ignoresSafeArea(edges: .top)

            VStack(spacing: 0) {
                // Header
                ZStack {
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }

                    VStack(spacing: 6) {
                        Image(systemName: item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.top, 24)

                        Text(item.discount)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
                .frame(height: 160)

                // Content
                VStack(alignment: .leading, spacing: 20) {
                    // Full description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Details")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.grayText)

                        Text(item.subtitle)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.appBlack)
                            .lineSpacing(4)
                    }

                    Divider()

                    // Code + copy
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Discount Code")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.grayText)

                        Button {
                            UIPasteboard.general.string = item.code
                            withAnimation(.spring(response: 0.3)) { showCopied = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showCopied = false }
                            }
                        } label: {
                            HStack {
                                Text(item.code)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.appBlack)

                                Spacer()

                                HStack(spacing: 6) {
                                    Image(systemName: showCopied ? "checkmark.circle.fill" : "doc.on.doc.fill")
                                        .foregroundColor(showCopied ? .cyanPrimary : .grayText)
                                    Text(showCopied ? "Copied!" : "Copy")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(showCopied ? .cyanPrimary : .grayText)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.grey50)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        showCopied ? Color.cyanPrimary : Color.grey100,
                                        lineWidth: 1.5
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)

                Spacer()
            }
        }
        .background(Color.backGround)
    }
}

// MARK: - Page Dots
struct PageIndicator: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { i in
                Capsule()
                    .fill(i == current ? Color.cyanPrimary : Color.grey150)
                    .frame(width: i == current ? 20 : 6, height: 6)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: current)
            }
        }
    }
}

// MARK: - Pager
struct AdBannerPager: View {
    let items: [BannerItem]
    @State private var currentIndex = 0

    var body: some View {
        VStack(spacing: 12) {
            TabView(selection: $currentIndex) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    BannerSlide(item: item)
                        .tag(index)
                        .padding(.horizontal, 2)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 150)

            PageIndicator(total: items.count, current: currentIndex)
        }
    }
}
