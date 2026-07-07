//
//  ChatViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  ChatViewModel.swift
//  QuickMart
//
import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [AIMessage] = []
    @Published var draftText: String = ""
    @Published private(set) var isSending: Bool = false
    @Published var errorMessage: String?

    private let useCase: SendChatMessageUseCaseProtocol

    init(useCase: SendChatMessageUseCaseProtocol) {
        self.useCase = useCase
        messages = [AIMessage(role: .model, text: "Hi! I'm your QuickMart assistant — ask me anything about products, or what you're shopping for today.")]
    }

    func sendMessage() {
        let trimmed = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isSending else { return }

        let userMessage = AIMessage(role: .user, text: trimmed)
        messages.append(userMessage)
        draftText = ""
        isSending = true
        errorMessage = nil

        Task {
            do {
                let reply = try await useCase.execute(history: messages, message: trimmed)
                messages.append(AIMessage(role: .model, text: reply))
            } catch {
                errorMessage = error.localizedDescription
            }
            isSending = false
        }
    }
}
