// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class FetchProductTypesQuery: GraphQLQuery {
    static let operationName: String = "FetchProductTypes"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query FetchProductTypes($first: Int!) { productTypes(first: $first) { __typename edges { __typename node } } }"#
      ))

    public var first: Int

    public init(first: Int) {
      self.first = first
    }

    public var __variables: Variables? { ["first": first] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
      static var __selections: [ApolloAPI.Selection] { [
        .field("productTypes", ProductTypes.self, arguments: ["first": .variable("first")]),
      ] }

      /// Returns a list of product types from the shop's [`Product`](https://shopify.dev/docs/api/storefront/current/objects/Product) objects that are published to your app. Use this query to build [filtering interfaces](https://shopify.dev/docs/storefronts/headless/building-with-the-storefront-api/products-collections/filter-products) or navigation menus based on product categorization.
      ///
      var productTypes: ProductTypes { __data["productTypes"] }

      /// ProductTypes
      ///
      /// Parent Type: `StringConnection`
      struct ProductTypes: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.StringConnection }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("edges", [Edge].self),
        ] }

        /// A list of edges.
        var edges: [Edge] { __data["edges"] }

        /// ProductTypes.Edge
        ///
        /// Parent Type: `StringEdge`
        struct Edge: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.StringEdge }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", String.self),
          ] }

          /// The item at the end of StringEdge.
          var node: String { __data["node"] }
        }
      }
    }
  }

}