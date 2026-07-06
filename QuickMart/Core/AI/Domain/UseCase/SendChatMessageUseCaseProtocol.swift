//
//  SendChatMessageUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  SendChatMessageUseCase.swift
//  QuickMart
//
import Foundation

protocol SendChatMessageUseCaseProtocol {
    func execute(history: [AIMessage], message: String) async throws -> String
}

struct SendChatMessageUseCase: SendChatMessageUseCaseProtocol {
    private let repository: AIRepositoryProtocol
    private let catalogContextProvider: () -> String

    init(repository: AIRepositoryProtocol, catalogContextProvider: @escaping () -> String) {
        self.repository = repository
        self.catalogContextProvider = catalogContextProvider
    }

    func execute(history: [AIMessage], message: String) async throws -> String {
        try await repository.sendChat(history: history, newMessage: message, catalogContext: catalogContextProvider())
    }
}
