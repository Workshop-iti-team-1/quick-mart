//
//  UserInfoView.swift
//  QuickMart
//
//  Created by siam on 07/07/2026.
//

import SwiftUI

struct UserInfoView: View {
    @StateObject private var viewModel: UserInfoViewModel
    @Environment(AppRouter.self) private var router
    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    
    init(viewModel: UserInfoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .top) {
            Color.backGround.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Profile Image Section
                    ZStack(alignment: .bottomTrailing) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        } else if let urlString = viewModel.user.avatarImageURL, let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView().frame(width: 140, height: 140)
                                case .success(let image):
                                    image.resizable().scaledToFill()
                                        .frame(width: 140, height: 140)
                                        .clipShape(Circle())
                                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                case .failure:
                                    placeholderView
                                @unknown default:
                                    placeholderView
                                }
                            }
                        } else {
                            placeholderView
                        }
                        
                        Button {
                            showActionSheet = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.cyanPrimary)
                                    .frame(width: 40, height: 40)
                                    .shadow(color: Color.cyanPrimary.opacity(0.4), radius: 6, x: 0, y: 3)
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.appWhite)
                            }
                        }
                        .offset(x: 4, y: 4)
                    }
                    .padding(.top, 40)
                    
                    // User Info Section
                    VStack(alignment: .leading, spacing: 0) {
                        infoRow(title: AppStrings.UserInfo.name, value: viewModel.user.name ?? AppStrings.UserInfo.notSet, showDivider: true)
                        infoRow(title: AppStrings.UserInfo.email, value: viewModel.user.email ?? AppStrings.UserInfo.notSet, showDivider: false)
                    }
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.grey100.opacity(colorScheme == .dark ? 0.1 : 0.4), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle(AppStrings.UserInfo.title)
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if viewModel.isLoading {
                ShimmeringLoadingOverlay(message: AppStrings.UserInfo.uploading)
            }
        }
        .alert(AppStrings.General.error, isPresented: $viewModel.showError) {
            Button(AppStrings.General.ok, role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? AppStrings.UserInfo.unknownError)
        }
        .sheet(isPresented: $showActionSheet) {
            ImagePickerOptionsSheet(showImagePicker: $showImagePicker, sourceType: $sourceType)
                .presentationDetents([.height(240)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { _, newImage in
            if let image = newImage {
                viewModel.uploadImage(image)
            }
        }
    }
    
    private var placeholderView: some View {
        Circle()
            .fill(Color.grey50)
            .frame(width: 140, height: 140)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.grey150)
            )
    }
    
    private func infoRow(title: String, value: String, showDivider: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .appTextStyle(.caption, color: .grayText)
            Text(value)
                .appTextStyle(.body, color: .appBlack)
            if showDivider {
                Divider().padding(.top, 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, showDivider ? 0 : 16)
    }
}

struct ImagePickerOptionsSheet: View {
    @Binding var showImagePicker: Bool
    @Binding var sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Text(AppStrings.UserInfo.chooseProfilePicture)
                .appTextStyle(.heading3, color: .appBlack)
                .padding(.top, 24)
            
            HStack(spacing: 40) {
                OptionButton(icon: "camera.fill", title: AppStrings.UserInfo.camera) {
                    sourceType = .camera
                    showImagePicker = true
                    dismiss()
                }
                
                OptionButton(icon: "photo.on.rectangle", title: AppStrings.UserInfo.photoLibrary) {
                    sourceType = .photoLibrary
                    showImagePicker = true
                    dismiss()
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    private func OptionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 70, height: 70)
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(.cyanPrimary)
                }
                Text(title)
                    .appTextStyle(.body, color: .appBlack)
            }
        }
    }
}
