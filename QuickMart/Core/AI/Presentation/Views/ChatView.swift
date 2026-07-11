//
//  ChatView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//
//
//  ChatView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    @Environment(AppRouter.self) private var router
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            appBar

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 14) {
                        ForEach(viewModel.messages) { message in
                            ChatBubbleView(message: message)
                                .id(message.id)
                        }

                        // Typing indicator
                        if viewModel.isSending {
                            typingIndicator
                                .id("typing")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: viewModel.isSending) { _ in
                    scrollToBottom(proxy: proxy)
                }
            }

            inputBar
        }
        .background(Color.backGround.ignoresSafeArea())
        .alert(AppStrings.General.error, isPresented: .constant(viewModel.errorMessage != nil)) {
            Button(AppStrings.General.ok, role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        let target: String = viewModel.isSending ? "typing" : (viewModel.messages.last?.id.uuidString ?? "")
        if !target.isEmpty {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(target.isEmpty ? nil : (viewModel.isSending ? "typing" as AnyHashable : viewModel.messages.last?.id as AnyHashable), anchor: .bottom)
            }
        }
    }

    // MARK: - Typing Indicator
    private var typingIndicator: some View {
        HStack(alignment: .bottom, spacing: 8) {
            // AI Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.cyanPrimary.opacity(0.15), .cyan50.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                Image(systemName: "sparkles")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.cyanPrimary)
            }

            // Bouncing dots
            HStack(spacing: 5) {
                AICompactLoading()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.grey50)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Spacer(minLength: 60)
        }
    }

    // MARK: - App Bar
    private var appBar: some View {
        HStack {
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "bubble.left.and.text.bubble.right.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.cyanPrimary)
                Text("Shopping Assistant")
                    .appTextStyle(.heading2, color: .appBlack)
            }
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }

    // MARK: - Input Bar
    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider().opacity(0.3)

            HStack(spacing: 12) {
                TextField("Ask me anything...", text: $viewModel.draftText, axis: .vertical)
                    .appTextStyle(.body, color: .appBlack)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.grey50)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isInputFocused ? Color.cyanPrimary.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
                    .focused($isInputFocused)
                    .lineLimit(1...4)

                Button(action: viewModel.sendMessage) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.appWhite)
                        .frame(width: 36, height: 36)
                        .background(
                            canSend
                                ? LinearGradient(colors: [.cyanPrimary, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                                : LinearGradient(colors: [.grey150, .grey150], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(Circle())
                        .shadow(color: canSend ? .cyanPrimary.opacity(0.25) : .clear, radius: 4, x: 0, y: 2)
                }
                .disabled(!canSend)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color.backGround)
    }

    private var canSend: Bool {
        !viewModel.draftText.trimmingCharacters(in: .whitespaces).isEmpty && !viewModel.isSending
    }
}

// MARK: - Chat Bubble View
struct ChatBubbleView: View {
    let message: AIMessage
    private var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 48) }

            // AI Avatar (only for model messages)
            if !isUser {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.cyanPrimary.opacity(0.15), .cyan50.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 28, height: 28)
                    Image(systemName: "sparkles")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.cyanPrimary)
                }
            }

            // Bubble
            Text(message.text)
                .appTextStyle(.body, color: isUser ? .appWhite : .appBlack)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    isUser
                        ? AnyShapeStyle(LinearGradient(colors: [.cyanPrimary, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                        : AnyShapeStyle(Color.grey50)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)

            if !isUser { Spacer(minLength: 48) }
        }
    }
}
