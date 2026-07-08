//
//  AIMessage.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  AIMessage.swift
//  QuickMart
//
import Foundation

struct AIMessage: Identifiable, Equatable {
    let id = UUID()
    let role: Role
    var text: String

    enum Role: String { case user, model }
}