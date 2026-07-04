// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class PredictiveSearchQuery: GraphQLQuery {
    static let operationName: String = "PredictiveSearch"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query PredictiveSearch($query: String!) { predictiveSearch(query: $query, types: [PRODUCT, COLLECTION]) { __typename products { __typename id title vendor priceRange { __typename minVariantPrice { __typename amount currencyCode } } images(first: 1) { __typename edges { __typename node { __typename url altText } } } } collections { __typename id title handle image { __typename url altText } } } }"#
      ))

    public var query: String

    public init(query: String) {
      self.query = query
    }

    public var __variables: Variables? { ["query": query] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
      static var __selections: [ApolloAPI.Selection] { [
        .field("predictiveSearch", PredictiveSearch?.self, arguments: [
          "query": .variable("query"),
          "types": ["PRODUCT", "COLLECTION"]
        ]),
      ] }

      /// Returns suggested results as customers type in a search field, enabling type-ahead search experiences. The query matches [products](https://shopify.dev/docs/api/storefront/current/objects/Product), [collections](https://shopify.dev/docs/api/storefront/current/objects/Collection), [pages](https://shopify.dev/docs/api/storefront/current/objects/Page), and [articles](https://shopify.dev/docs/api/storefront/current/objects/Article) based on partial search terms, and also provides [search query suggestions](https://shopify.dev/docs/api/storefront/current/objects/SearchQuerySuggestion) to help customers refine their search.
      ///
      /// You can filter results by resource type and limit the quantity. The [`limitScope`](https://shopify.dev/docs/api/storefront/current/queries/predictiveSearch#arguments-limitScope) argument controls whether limits apply across all result types or per type. Use [`unavailableProducts`](https://shopify.dev/docs/api/storefront/current/queries/predictiveSearch#arguments-unavailableProducts) to control how out-of-stock products appear in results.
      ///
      var predictiveSearch: PredictiveSearch? { __data["predictiveSearch"] }

      /// PredictiveSearch
      ///
      /// Parent Type: `PredictiveSearchResult`
      struct PredictiveSearch: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.PredictiveSearchResult }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("products", [Product].self),
          .field("collections", [Collection].self),
        ] }

        /// The products that match the search query.
        var products: [Product] { __data["products"] }
        /// The articles that match the search query.
        var collections: [Collection] { __data["collections"] }

        /// PredictiveSearch.Product
        ///
        /// Parent Type: `Product`
        struct Product: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Product }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAPI.ID.self),
            .field("title", String.self),
            .field("vendor", String.self),
            .field("priceRange", PriceRange.self),
            .field("images", Images.self, arguments: ["first": 1]),
          ] }

          /// A globally-unique ID.
          var id: ShopifyAPI.ID { __data["id"] }
          /// The name for the product that displays to customers. The title is used to construct the product's handle.
          /// For example, if a product is titled "Black Sunglasses", then the handle is `black-sunglasses`.
          ///
          var title: String { __data["title"] }
          /// The name of the product's vendor.
          var vendor: String { __data["vendor"] }
          /// The minimum and maximum prices of a product, expressed in decimal numbers.
          /// For example, if the product is priced between $10.00 and $50.00,
          /// then the price range is $10.00 - $50.00.
          ///
          var priceRange: PriceRange { __data["priceRange"] }
          /// List of images associated with the product.
          var images: Images { __data["images"] }

          /// PredictiveSearch.Product.PriceRange
          ///
          /// Parent Type: `ProductPriceRange`
          struct PriceRange: ShopifyAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductPriceRange }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("minVariantPrice", MinVariantPrice.self),
            ] }

            /// The lowest variant's price.
            var minVariantPrice: MinVariantPrice { __data["minVariantPrice"] }

            /// PredictiveSearch.Product.PriceRange.MinVariantPrice
            ///
            /// Parent Type: `MoneyV2`
            struct MinVariantPrice: ShopifyAPI.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("amount", ShopifyAPI.Decimal.self),
                .field("currencyCode", GraphQLEnum<ShopifyAPI.CurrencyCode>.self),
              ] }

              /// Decimal money amount.
              var amount: ShopifyAPI.Decimal { __data["amount"] }
              /// Currency of the money.
              var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }
            }
          }

          /// PredictiveSearch.Product.Images
          ///
          /// Parent Type: `ImageConnection`
          struct Images: ShopifyAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ImageConnection }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("edges", [Edge].self),
            ] }

            /// A list of edges.
            var edges: [Edge] { __data["edges"] }

            /// PredictiveSearch.Product.Images.Edge
            ///
            /// Parent Type: `ImageEdge`
            struct Edge: ShopifyAPI.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ImageEdge }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("node", Node.self),
              ] }

              /// The item at the end of ImageEdge.
              var node: Node { __data["node"] }

              /// PredictiveSearch.Product.Images.Edge.Node
              ///
              /// Parent Type: `Image`
              struct Node: ShopifyAPI.SelectionSet {
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
            }
          }
        }

        /// PredictiveSearch.Collection
        ///
        /// Parent Type: `Collection`
        struct Collection: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Collection }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAPI.ID.self),
            .field("title", String.self),
            .field("handle", String.self),
            .field("image", Image?.self),
          ] }

          /// A globally-unique ID.
          var id: ShopifyAPI.ID { __data["id"] }
          /// The collection’s name. Limit of 255 characters.
          var title: String { __data["title"] }
          /// A human-friendly unique string for the collection automatically generated from its title.
          /// Limit of 255 characters.
          ///
          var handle: String { __data["handle"] }
          /// Image associated with the collection.
          var image: Image? { __data["image"] }

          /// PredictiveSearch.Collection.Image
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
        }
      }
    }
  }

}