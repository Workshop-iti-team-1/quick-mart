

//
//  DiscountDataSource.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//

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
        request.setValue(ShopifyConfig.adminToken, forHTTPHeaderField: "X-Shopify-Access-Token")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["query": query])

        let (data, response) = try await session.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw NSError(
                domain: "AdminAPI",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Admin API returned \(httpResponse.statusCode)"]
            )
        }

        return try parseDiscounts(from: data)
    }

    private func parseDiscounts(from data: Data) throws -> [DiscountModel] {
        guard
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let dataObj = json["data"] as? [String: Any],
            let discountNodes = dataObj["discountNodes"] as? [String: Any],
            let nodes = discountNodes["nodes"] as? [[String: Any]]
        else { return [] }

        return nodes.compactMap { node in
            guard
                let id = node["id"] as? String,
                let discount = node["discount"] as? [String: Any],
                let title = discount["title"] as? String,
                let summary = discount["summary"] as? String,
                let codesObj = discount["codes"] as? [String: Any],
                let codeNodes = codesObj["nodes"] as? [[String: Any]],
                let code = codeNodes.first?["code"] as? String
            else { return nil }

            return DiscountModel(id: id, title: title, summary: summary, code: code)
        }
    }
}
