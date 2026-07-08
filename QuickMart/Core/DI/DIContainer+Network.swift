//
//  DIContainer+Network.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation
import Apollo

extension DIContainer {
    var graphQLClient: ShopifyGraphQLClientProtocol {
        return GraphQLClient(apollo: self.apolloClient)
    }
}

