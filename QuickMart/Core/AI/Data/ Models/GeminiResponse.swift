//
//  GeminiResponse.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import Foundation

struct GeminiResponse: Decodable {
    let candidates: [Candidate]?
    struct Candidate: Decodable { let content: Content }
    struct Content: Decodable { let parts: [Part] }
    struct Part: Decodable { let text: String? }
}
