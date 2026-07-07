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
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else if let urlString = viewModel.user.avatarImageURL, let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView().frame(width: 120, height: 120)
                                case .success(let image):
                                    image.resizable().scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
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
                                    .frame(width: 36, height: 36)
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.appWhite)
                            }
                        }
                        .offset(x: 4, y: 4)
                    }
                    .padding(.top, 32)
                    
                    // User Info Section
                    VStack(alignment: .leading, spacing: 20) {
                        infoRow(title: AppStrings.UserInfo.name, value: viewModel.user.name ?? AppStrings.UserInfo.notSet)
                        infoRow(title: AppStrings.UserInfo.email, value: viewModel.user.email ?? AppStrings.UserInfo.notSet)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
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
        .confirmationDialog(AppStrings.UserInfo.chooseProfilePicture, isPresented: $showActionSheet, titleVisibility: .visible) {
            Button(AppStrings.UserInfo.camera) {
                sourceType = .camera
                showImagePicker = true
            }
            Button(AppStrings.UserInfo.photoLibrary) {
                sourceType = .photoLibrary
                showImagePicker = true
            }
            Button(AppStrings.General.cancel, role: .cancel) {}
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
            .fill(Color.gray.opacity(0.2))
            .frame(width: 120, height: 120)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
            )
    }
    
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .appTextStyle(.caption, color: .gray)
            Text(value)
                .appTextStyle(.body, color: .appBlack)
            Divider()
        }
    }
}
