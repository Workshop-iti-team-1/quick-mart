// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class GetCollectionsQuery: GraphQLQuery {
    static let operationName: String = "GetCollections"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetCollections($first: Int!, $after: String) { collections(first: $first, after: $after) { __typename edges { __typename node { __typename id title handle description image { __typename url altText } products(first: 1) { __typename edges { __typename node { __typename id } } } } } pageInfo { __typename hasNextPage endCursor } } }"#
      ))

    public var first: Int
    public var after: GraphQLNullable<String>

    public init(
      first: Int,
      after: GraphQLNullable<String>
    ) {
      self.first = first
      self.after = after
    }

    public var __variables: Variables? { [
      "first": first,
      "after": after
    ] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
      static var __selections: [ApolloAPI.Selection] { [
        .field("collections", Collections.self, arguments: [
          "first": .variable("first"),
          "after": .variable("after")
        ]),
      ] }

      /// Returns a paginated list of the shop's [collections](https://shopify.dev/docs/api/storefront/current/objects/Collection). Each `Collection` object includes a nested connection to its [products](https://shopify.dev/docs/api/storefront/current/objects/Collection#field-Collection.fields.products).
      ///
      var collections: Collections { __data["collections"] }

      /// Collections
      ///
      /// Parent Type: `CollectionConnection`
      struct Collections: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CollectionConnection }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("edges", [Edge].self),
          .field("pageInfo", PageInfo.self),
        ] }

        /// A list of edges.
        var edges: [Edge] { __data["edges"] }
        /// Information to aid in pagination.
        var pageInfo: PageInfo { __data["pageInfo"] }

        /// Collections.Edge
        ///
        /// Parent Type: `CollectionEdge`
        struct Edge: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CollectionEdge }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", Node.self),
          ] }

          /// The item at the end of CollectionEdge.
          var node: Node { __data["node"] }

          /// Collections.Edge.Node
          ///
          /// Parent Type: `Collection`
          struct Node: ShopifyAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Collection }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", ShopifyAPI.ID.self),
              .field("title", String.self),
              .field("handle", String.self),
              .field("description", String.self),
              .field("image", Image?.self),
              .field("products", Products.self, arguments: ["first": 1]),
            ] }

            /// A globally-unique ID.
            var id: ShopifyAPI.ID { __data["id"] }
            /// The collection’s name. Limit of 255 characters.
            var title: String { __data["title"] }
            /// A human-friendly unique string for the collection automatically generated from its title.
            /// Limit of 255 characters.
            ///
            var handle: String { __data["handle"] }
            /// Stripped description of the collection, single line with HTML tags removed.
            var description: String { __data["description"] }
            /// Image associated with the collection.
            var image: Image? { __data["image"] }
            /// List of products in the collection.
            var products: Products { __data["products"] }

            /// Collections.Edge.Node.Image
            ///
            /// Parent Type: `Image`
            struct Image: ShopifyAPI.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Image }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("url", ShopifyAPI.URL.self),
                .field("altText", String?.self),
              ] }

              /// The location of the image as a URL.
              ///
              /// If no transform options are specified, then the original image will be preserved including any pre-applied transforms.
              ///
              /// All transformation options are considered "best-effort". Any transformation that the original image type doesn't support will be ignored.
              ///
              /// If you need multiple variations of the same image, then you can use [GraphQL aliases](https://graphql.org/learn/queries/#aliases).
              ///
              var url: ShopifyAPI.URL { __data["url"] }
              /// A word or phrase to share the nature or contents of an image.
              var altText: String? { __data["altText"] }
            }

            /// Collections.Edge.Node.Products
            ///
            /// Parent Type: `ProductConnection`
            struct Products: ShopifyAPI.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductConnection }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("edges", [Edge].self),
              ] }

              /// A list of edges.
              var edges: [Edge] { __data["edges"] }

              /// Collections.Edge.Node.Products.Edge
              ///
              /// Parent Type: `ProductEdge`
              struct Edge: ShopifyAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductEdge }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("node", Node.self),
                ] }

                /// The item at the end of ProductEdge.
                var node: Node { __data["node"] }

                /// Collections.Edge.Node.Products.Edge.Node
                ///
                /// Parent Type: `Product`
                struct Node: ShopifyAPI.SelectionSet {
                  let __data: DataDict
                  init(_dataDict: DataDict) { __data = _dataDict }

                  static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Product }
                  static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("id", ShopifyAPI.ID.self),
                  ] }

                  /// A globally-unique ID.
                  var id: ShopifyAPI.ID { __data["id"] }
                }
              }
            }
          }
        }

        /// Collections.PageInfo
        ///
        /// Parent Type: `PageInfo`
        struct PageInfo: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.PageInfo }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("hasNextPage", Bool.self),
            .field("endCursor", String?.self),
          ] }

          /// Whether there are more pages to fetch following the current page.
          var hasNextPage: Bool { __data["hasNextPage"] }
          /// The cursor corresponding to the last node in edges.
          var endCursor: String? { __data["endCursor"] }
        }
      }
    }
  }

}