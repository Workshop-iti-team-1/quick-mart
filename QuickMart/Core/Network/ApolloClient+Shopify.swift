//
//  ApolloClient+Shopify.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation
import Apollo

class Network {

    static let shared = Network()

    private(set) lazy var apollo: ApolloClient = {

        let store = ApolloStore()

        let transport = RequestChainNetworkTransport(
            interceptorProvider: DefaultInterceptorProvider(store: store),
            endpointURL: ShopifyConfig.url,
            additionalHeaders: [
                "X-Shopify-Storefront-Access-Token": ShopifyConfig.storefrontToken
            ]
        )

        return ApolloClient(networkTransport: transport, store: store)
    }()
}
