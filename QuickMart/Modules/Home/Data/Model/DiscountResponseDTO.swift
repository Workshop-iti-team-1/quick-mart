//
//  DiscountResponseDTO.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 06/07/2026.
//

import Foundation

struct DiscountGraphQLResponse: Decodable {
    let data: DiscountDataDTO?
    let errors: [GraphQLErrorMessageDTO]?
}

struct DiscountDataDTO: Decodable {
    let discountNodes: DiscountNodesDTO
}

struct DiscountNodesDTO: Decodable {
    let nodes: [DiscountNodeDTO]
}

struct DiscountNodeDTO: Decodable {
    let id: String
    let discount: DiscountDetailDTO?
}

struct DiscountDetailDTO: Decodable {
    let title: String?
    let summary: String?
    let codes: DiscountCodesConnectionDTO?
}

struct DiscountCodesConnectionDTO: Decodable {
    let nodes: [DiscountCodeNodeDTO]
}

struct DiscountCodeNodeDTO: Decodable {
    let code: String
}

struct GraphQLErrorMessageDTO: Decodable {
    let message: String
}
