// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class SearchProductsQuery: GraphQLQuery {
    static let operationName: String = "SearchProducts"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query SearchProducts($query: String!, $first: Int!, $after: String, $sortKey: SearchSortKeys, $reverse: Boolean) { search( query: $query types: PRODUCT first: $first after: $after sortKey: $sortKey reverse: $reverse ) { __typename edges { __typename node { __typename ... on Product { id title vendor productType availableForSale priceRange { __typename minVariantPrice { __typename amount currencyCode } maxVariantPrice { __typename amount currencyCode } } compareAtPriceRange { __typename minVariantPrice { __typename amount } } images(first: 1) { __typename edges { __typename node { __typename url altText } } } collections(first: 10) { __typename edges { __typename node { __typename id handle } } } variants(first: 1) { __typename edges { __typename node { __typename id availableForSale } } } } } } pageInfo { __typename hasNextPage endCursor } totalCount } }"#
      ))

    public var query: String
    public var first: Int
    public var after: GraphQLNullable<String>
    public var sortKey: GraphQLNullable<GraphQLEnum<SearchSortKeys>>
    public var reverse: GraphQLNullable<Bool>

    public init(
      query: String,
      first: Int,
      after: GraphQLNullable<String>,
      sortKey: GraphQLNullable<GraphQLEnum<SearchSortKeys>>,
      reverse: GraphQLNullable<Bool>
    ) {
      self.query = query
      self.first = first
      self.after = after
      self.sortKey = sortKey
      self.reverse = reverse
    }

    public var __variables: Variables? { [
      "query": query,
      "first": first,
      "after": after,
      "sortKey": sortKey,
      "reverse": reverse
    ] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
      static var __selections: [ApolloAPI.Selection] { [
        .field("search", Search.self, arguments: [
          "query": .variable("query"),
          "types": "PRODUCT",
          "first": .variable("first"),
          "after": .variable("after"),
          "sortKey": .variable("sortKey"),
          "reverse": .variable("reverse")
        ]),
      ] }

      /// Returns paginated search results for [`Product`](https://shopify.dev/docs/api/storefront/current/objects/Product), [`Page`](https://shopify.dev/docs/api/storefront/current/objects/Page), and [`Article`](https://shopify.dev/docs/api/storefront/current/objects/Article) resources based on a query string. Results are sorted by relevance by default.
      ///
      /// The response includes the total result count and available product filters for building [faceted search interfaces](https://shopify.dev/docs/storefronts/headless/building-with-the-storefront-api/products-collections/filter-products). Use the [`prefix`](https://shopify.dev/docs/api/storefront/current/enums/SearchPrefixQueryType) argument to enable partial word matching on the last search term, allowing queries like "winter snow" to match "snowboard" or "snowshoe".
      ///
      var search: Search { __data["search"] }

      /// Search
      ///
      /// Parent Type: `SearchResultItemConnection`
      struct Search: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.SearchResultItemConnection }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("edges", [Edge].self),
          .field("pageInfo", PageInfo.self),
          .field("totalCount", Int.self),
        ] }

        /// A list of edges.
        var edges: [Edge] { __data["edges"] }
        /// Information to aid in pagination.
        var pageInfo: PageInfo { __data["pageInfo"] }
        /// The total number of results.
        var totalCount: Int { __data["totalCount"] }

        /// Search.Edge
        ///
        /// Parent Type: `SearchResultItemEdge`
        struct Edge: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.SearchResultItemEdge }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", Node.self),
          ] }

          /// The item at the end of SearchResultItemEdge.
          var node: Node { __data["node"] }

          /// Search.Edge.Node
          ///
          /// Parent Type: `SearchResultItem`
          struct Node: ShopifyAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Unions.SearchResultItem }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .inlineFragment(AsProduct.self),
            ] }

            var asProduct: AsProduct? { _asInlineFragment() }

            /// Search.Edge.Node.AsProduct
            ///
            /// Parent Type: `Product`
            struct AsProduct: ShopifyAPI.InlineFragment {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              typealias RootEntityType = SearchProductsQuery.Data.Search.Edge.Node
              static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Product }
              static var __selections: [ApolloAPI.Selection] { [
                .field("id", ShopifyAPI.ID.self),
                .field("title", String.self),
                .field("vendor", String.self),
                .field("productType", String.self),
                .field("availableForSale", Bool.self),
                .field("priceRange", PriceRange.self),
                .field("compareAtPriceRange", CompareAtPriceRange.self),
                .field("images", Images.self, arguments: ["first": 1]),
                .field("collections", Collections.self, arguments: ["first": 10]),
                .field("variants", Variants.self, arguments: ["first": 1]),
              ] }

              /// A globally-unique ID.
              var id: ShopifyAPI.ID { __data["id"] }
              /// The name for the product that displays to customers. The title is used to construct the product's handle.
              /// For example, if a product is titled "Black Sunglasses", then the handle is `black-sunglasses`.
              ///
              var title: String { __data["title"] }
              /// The name of the product's vendor.
              var vendor: String { __data["vendor"] }
              /// The [product type](https://help.shopify.com/manual/products/details/product-type)
              /// that merchants define.
              ///
              var productType: String { __data["productType"] }
              /// Indicates if at least one product variant is available for sale.
              var availableForSale: Bool { __data["availableForSale"] }
              /// The minimum and maximum prices of a product, expressed in decimal numbers.
              /// For example, if the product is priced between $10.00 and $50.00,
              /// then the price range is $10.00 - $50.00.
              ///
              var priceRange: PriceRange { __data["priceRange"] }
              /// The [compare-at price range](https://help.shopify.com/manual/products/details/product-pricing/sale-pricing) of the product in the shop's default currency.
              var compareAtPriceRange: CompareAtPriceRange { __data["compareAtPriceRange"] }
              /// List of images associated with the product.
              var images: Images { __data["images"] }
              /// A list of [collections](/docs/api/storefront/latest/objects/Collection) that include the product.
              var collections: Collections { __data["collections"] }
              /// A list of [variants](/docs/api/storefront/latest/objects/ProductVariant) that are associated with the product.
              var variants: Variants { __data["variants"] }

              /// Search.Edge.Node.AsProduct.PriceRange
              ///
              /// Parent Type: `ProductPriceRange`
              struct PriceRange: ShopifyAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductPriceRange }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("minVariantPrice", MinVariantPrice.self),
                  .field("maxVariantPrice", MaxVariantPrice.self),
                ] }

                /// The lowest variant's price.
                var minVariantPrice: MinVariantPrice { __data["minVariantPrice"] }
                /// The highest variant's price.
                var maxVariantPrice: MaxVariantPrice { __data["maxVariantPrice"] }

                /// Search.Edge.Node.AsProduct.PriceRange.MinVariantPrice
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

                /// Search.Edge.Node.AsProduct.PriceRange.MaxVariantPrice
                ///
                /// Parent Type: `MoneyV2`
                struct MaxVariantPrice: ShopifyAPI.SelectionSet {
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

              /// Search.Edge.Node.AsProduct.CompareAtPriceRange
              ///
              /// Parent Type: `ProductPriceRange`
              struct CompareAtPriceRange: ShopifyAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductPriceRange }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("minVariantPrice", MinVariantPrice.self),
                ] }

                /// The lowest variant's price.
                var minVariantPrice: MinVariantPrice { __data["minVariantPrice"] }

                /// Search.Edge.Node.AsProduct.CompareAtPriceRange.MinVariantPrice
                ///
                /// Parent Type: `MoneyV2`
                struct MinVariantPrice: ShopifyAPI.SelectionSet {
                  let __data: DataDict
                  init(_dataDict: DataDict) { __data = _dataDict }

                  static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
                  static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("amount", ShopifyAPI.Decimal.self),
                  ] }

                  /// Decimal money amount.
                  var amount: ShopifyAPI.Decimal { __data["amount"] }
                }
              }

              /// Search.Edge.Node.AsProduct.Images
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

                /// Search.Edge.Node.AsProduct.Images.Edge
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

                  /// Search.Edge.Node.AsProduct.Images.Edge.Node
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

              /// Search.Edge.Node.AsProduct.Collections
              ///
              /// Parent Type: `CollectionConnection`
              struct Collections: ShopifyAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CollectionConnection }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("edges", [Edge].self),
                ] }

                /// A list of edges.
                var edges: [Edge] { __data["edges"] }

                /// Search.Edge.Node.AsProduct.Collections.Edge
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

                  /// Search.Edge.Node.AsProduct.Collections.Edge.Node
                  ///
                  /// Parent Type: `Collection`
                  struct Node: ShopifyAPI.SelectionSet {
                    let __data: DataDict
                    init(_dataDict: DataDict) { __data = _dataDict }

                    static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Collection }
                    static var __selections: [ApolloAPI.Selection] { [
                      .field("__typename", String.self),
                      .field("id", ShopifyAPI.ID.self),
                      .field("handle", String.self),
                    ] }

                    /// A globally-unique ID.
                    var id: ShopifyAPI.ID { __data["id"] }
                    /// A human-friendly unique string for the collection automatically generated from its title.
                    /// Limit of 255 characters.
                    ///
                    var handle: String { __data["handle"] }
                  }
                }
              }

              /// Search.Edge.Node.AsProduct.Variants
              ///
              /// Parent Type: `ProductVariantConnection`
              struct Variants: ShopifyAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariantConnection }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("edges", [Edge].self),
                ] }

                /// A list of edges.
                var edges: [Edge] { __data["edges"] }

                /// Search.Edge.Node.AsProduct.Variants.Edge
                ///
                /// Parent Type: `ProductVariantEdge`
                struct Edge: ShopifyAPI.SelectionSet {
                  let __data: DataDict
                  init(_dataDict: DataDict) { __data = _dataDict }

                  static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariantEdge }
                  static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("node", Node.self),
                  ] }

                  /// The item at the end of ProductVariantEdge.
                  var node: Node { __data["node"] }

                  /// Search.Edge.Node.AsProduct.Variants.Edge.Node
                  ///
                  /// Parent Type: `ProductVariant`
                  struct Node: ShopifyAPI.SelectionSet {
                    let __data: DataDict
                    init(_dataDict: DataDict) { __data = _dataDict }

                    static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }
                    static var __selections: [ApolloAPI.Selection] { [
                      .field("__typename", String.self),
                      .field("id", ShopifyAPI.ID.self),
                      .field("availableForSale", Bool.self),
                    ] }

                    /// A globally-unique ID.
                    var id: ShopifyAPI.ID { __data["id"] }
                    /// Indicates if the product variant is available for sale.
                    var availableForSale: Bool { __data["availableForSale"] }
                  }
                }
              }
            }
          }
        }

        /// Search.PageInfo
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