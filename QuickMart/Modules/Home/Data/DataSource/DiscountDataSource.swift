//
//  DiscountDataSource.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//

// Features/Discount/Data/DataSources/DiscountDataSource.swift

import Foundation

final class DiscountDataSource: DiscountDataSourceProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchActiveDiscounts() async throws -> [DiscountModel] {
        let query = """
        {
          discountNodes(first: 20, query: "method:code status:active") {
            nodes {
              id
              discount {
                ... on DiscountCodeBasic {
                  title
                  summary
                  codes(first: 1) { nodes { code } }
                }
                ... on DiscountCodeFreeShipping {
                  title
                  summary
                  codes(first: 1) { nodes { code } }
                }
              }
            }
          }
        }
        """

        var request = URLRequest(url: ShopifyConfig.adminURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            ShopifyConfig.adminToken,
            forHTTPHeaderField: "X-Shopify-Access-Token"
        )
        request.httpBody = try JSONEncoder().encode(["query": query])

        let (data, response) = try await session.data(for: request)
        try validateHTTPResponse(response)

        let decoded = try JSONDecoder().decode(DiscountGraphQLResponse.self, from: data)

        if let errors = decoded.errors, !errors.isEmpty {
            let message = errors.map(\.message).joined(separator: "\n")
            throw NSError(
                domain: "AdminAPI",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: message]
            )
        }

        return decoded.data?.discountNodes.nodes.compactMap(Self.mapToModel) ?? []
    }

    // MARK: - Mapping

    private static func mapToModel(_ node: DiscountNodeDTO) -> DiscountModel? {
        guard
            let discount = node.discount,
            let title    = discount.title,
            let summary  = discount.summary,
            let code     = discount.codes?.nodes.first?.code
        else { return nil }

        return DiscountModel(
            id: node.id,
            title: title,
            summary: summary,
            code: code
        )
    }

    // MARK: - Helpers

    private func validateHTTPResponse(_ response: URLResponse) throws {
        guard
            let http = response as? HTTPURLResponse,
            (200...299).contains(http.statusCode)
        else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw NSError(
                domain: "AdminAPI",
                code: code,
                userInfo: [NSLocalizedDescriptionKey: "Admin API returned \(code)"]
            )
        }
    }
}
