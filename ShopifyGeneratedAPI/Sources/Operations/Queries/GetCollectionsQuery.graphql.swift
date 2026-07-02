// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetCollectionsQuery: GraphQLQuery {
  public static let operationName: String = "GetCollections"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
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

  public struct Data: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("collections", Collections.self, arguments: [
        "first": .variable("first"),
        "after": .variable("after")
      ]),
    ] }

    /// Returns a paginated list of the shop's [collections](https://shopify.dev/docs/api/storefront/current/objects/Collection). Each `Collection` object includes a nested connection to its [products](https://shopify.dev/docs/api/storefront/current/objects/Collection#field-Collection.fields.products).
    ///
    public var collections: Collections { __data["collections"] }

    /// Collections
    ///
    /// Parent Type: `CollectionConnection`
    public struct Collections: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CollectionConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("edges", [Edge].self),
        .field("pageInfo", PageInfo.self),
      ] }

      /// A list of edges.
      public var edges: [Edge] { __data["edges"] }
      /// Information to aid in pagination.
      public var pageInfo: PageInfo { __data["pageInfo"] }

      /// Collections.Edge
      ///
      /// Parent Type: `CollectionEdge`
      public struct Edge: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CollectionEdge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("node", Node.self),
        ] }

        /// The item at the end of CollectionEdge.
        public var node: Node { __data["node"] }

        /// Collections.Edge.Node
        ///
        /// Parent Type: `Collection`
        public struct Node: ShopifyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Collection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAPI.ID.self),
            .field("title", String.self),
            .field("handle", String.self),
            .field("description", String.self),
            .field("image", Image?.self),
            .field("products", Products.self, arguments: ["first": 1]),
          ] }

          /// A globally-unique ID.
          public var id: ShopifyAPI.ID { __data["id"] }
          /// The collection’s name. Limit of 255 characters.
          public var title: String { __data["title"] }
          /// A human-friendly unique string for the collection automatically generated from its title.
          /// Limit of 255 characters.
          ///
          public var handle: String { __data["handle"] }
          /// Stripped description of the collection, single line with HTML tags removed.
          public var description: String { __data["description"] }
          /// Image associated with the collection.
          public var image: Image? { __data["image"] }
          /// List of products in the collection.
          public var products: Products { __data["products"] }

          /// Collections.Edge.Node.Image
          ///
          /// Parent Type: `Image`
          public struct Image: ShopifyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Image }
            public static var __selections: [ApolloAPI.Selection] { [
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
            public var url: ShopifyAPI.URL { __data["url"] }
            /// A word or phrase to share the nature or contents of an image.
            public var altText: String? { __data["altText"] }
          }

          /// Collections.Edge.Node.Products
          ///
          /// Parent Type: `ProductConnection`
          public struct Products: ShopifyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductConnection }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("edges", [Edge].self),
            ] }

            /// A list of edges.
            public var edges: [Edge] { __data["edges"] }

            /// Collections.Edge.Node.Products.Edge
            ///
            /// Parent Type: `ProductEdge`
            public struct Edge: ShopifyAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductEdge }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("node", Node.self),
              ] }

              /// The item at the end of ProductEdge.
              public var node: Node { __data["node"] }

              /// Collections.Edge.Node.Products.Edge.Node
              ///
              /// Parent Type: `Product`
              public struct Node: ShopifyAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Product }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("id", ShopifyAPI.ID.self),
                ] }

                /// A globally-unique ID.
                public var id: ShopifyAPI.ID { __data["id"] }
              }
            }
          }
        }
      }

      /// Collections.PageInfo
      ///
      /// Parent Type: `PageInfo`
      public struct PageInfo: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.PageInfo }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("hasNextPage", Bool.self),
          .field("endCursor", String?.self),
        ] }

        /// Whether there are more pages to fetch following the current page.
        public var hasNextPage: Bool { __data["hasNextPage"] }
        /// The cursor corresponding to the last node in edges.
        public var endCursor: String? { __data["endCursor"] }
      }
    }
  }
}
