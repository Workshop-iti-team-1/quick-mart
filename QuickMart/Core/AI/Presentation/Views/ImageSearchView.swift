//
//  ImageSearchView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

//
//  ImageSearchView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import SwiftUI
import PhotosUI

struct ImageSearchView: View {
    @StateObject var viewModel: ImageSearchViewModel
    @Environment(AppRouter.self) private var router
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 0) {
            appBar

            ScrollView {
                VStack(spacing: 16) {
                    // Photo picker
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        pickerContent
                    }
                    .onChange(of: pickerItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                viewModel.analyzeAndSearch(imageData: data)
                            }
                        }
                    }

                    // Status indicators
                    if viewModel.isAnalyzing {
                        statusCard(icon: "eye.fill", message: "Identifying item in photo...", isLoading: true)
                    } else if viewModel.isSearching {
                        VStack(spacing: 10) {
                            if let query = viewModel.detectedQuery {
                                queryChip(query)
                            }
                            statusCard(icon: "magnifyingglass", message: "Searching catalog...", isLoading: true)
                        }
                    } else if let query = viewModel.detectedQuery, !viewModel.results.isEmpty {
                        queryChip(query)
                    }

                    // Results grid
                    if !viewModel.results.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("\(viewModel.results.count) results found")
                                    .appTextStyle(.label, color: .appBlack)
                                Spacer()
                            }

                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                                ForEach(viewModel.results) { item in
                                    Button {
                                        router.push(.productDetails(productId: item.id))
                                    } label: {
                                        ProductCard(item: item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    } else if let error = viewModel.errorMessage {
                        errorSection(error)
                    }
                }
                .padding(16)
                .padding(.bottom, 24)
            }
        }
        .background(Color.backGround.ignoresSafeArea())
    }

    // MARK: - Picker Content
    private var pickerContent: some View {
        Group {
            if let data = viewModel.selectedImageData, let uiImage = UIImage(data: data) {
                ZStack(alignment: .bottom) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)

                    // Overlay label
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.system(size: 12, weight: .medium))
                        Text("Change photo")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(.bottom, 10)
                }
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.cyanPrimary)

                    Text("Tap to choose a photo")
                        .appTextStyle(.label, color: .grayText)
                    Text("We'll find matching products")
                        .appTextStyle(.caption, color: .grey150)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color.grey50)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                        .foregroundColor(.cyanPrimary.opacity(0.3))
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Status Card
    private func statusCard(icon: String, message: String, isLoading: Bool) -> some View {
        HStack(spacing: 10) {
            if isLoading {
                AICompactLoading()
            } else {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(.cyanPrimary)
            }
            Text(message)
                .appTextStyle(.body, color: .grayText)
            Spacer()
        }
        .padding(14)
        .background(Color.cyan50.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Query Chip
    private func queryChip(_ query: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.cyanPrimary)
            Text(query)
                .appTextStyle(.label, color: .cyanPrimary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.cyan50.opacity(0.4))
        .overlay(
            Capsule()
                .stroke(Color.cyanPrimary.opacity(0.2), lineWidth: 1)
        )
        .clipShape(Capsule())
    }

    // MARK: - Error
    private func errorSection(_ error: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.appRed)
            Text(error)
                .appTextStyle(.body, color: .appRed)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appRed.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - App Bar
    private var appBar: some View {
        HStack {
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.cyanPrimary)
                Text("Search by Photo")
                    .appTextStyle(.heading2, color: .appBlack)
            }
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
