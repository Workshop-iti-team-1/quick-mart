//
//  DIContainer+Network.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation
import Apollo

extension DIContainer {
    public var apolloClient: ApolloClient {
        return Network.shared.apollo
    }
}
