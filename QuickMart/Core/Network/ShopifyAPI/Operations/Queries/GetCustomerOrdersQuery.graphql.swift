// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class GetCustomerOrdersQuery: GraphQLQuery {
    static let operationName: String = "GetCustomerOrders"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetCustomerOrders($customerAccessToken: String!, $first: Int!, $after: String) { customer(customerAccessToken: $customerAccessToken) { __typename id firstName orders(first: $first, after: $after, sortKey: PROCESSED_AT, reverse: true) { __typename edges { __typename cursor node { __typename id orderNumber processedAt financialStatus fulfillmentStatus currentTotalPrice { __typename amount currencyCode } currentSubtotalPrice { __typename amount currencyCode } discountApplications(first: 5) { __typename edges { __typename node { __typename ... on DiscountCodeApplication { code value { __typename ... on PricingPercentageValue { percentage } ... on MoneyV2 { amount currencyCode } } } } } } lineItems(first: 10) { __typename edges { __typename node { __typename title quantity originalTotalPrice { __typename amount currencyCode } variant { __typename id title image { __typename url } } } } } shippingAddress { __typename firstName lastName address1 city country phone } } } pageInfo { __typename hasNextPage endCursor } } } }"#
      ))

    public var customerAccessToken: String
    public var first: Int
    public var after: GraphQLNullable<String>

    public init(
      customerAccessToken: String,
      first: Int,
      after: GraphQLNullable<String>
    ) {
      self.customerAccessToken = customerAccessToken
      self.first = first
      self.after = after
    }

    public var __variables: Variables? { [
      "customerAccessToken": customerAccessToken,
      "first": first,
      "after": after
    ] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
      static var __selections: [ApolloAPI.Selection] { [
        .field("customer", Customer?.self, arguments: ["customerAccessToken": .variable("customerAccessToken")]),
      ] }

      /// Retrieves the [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer) associated with the provided access token. Use the [`customerAccessTokenCreate`](https://shopify.dev/docs/api/storefront/current/mutations/customerAccessTokenCreate) mutation to obtain an access token using legacy customer account authentication (email and password).
      ///
      /// The returned customer includes data such as contact information, [addresses](https://shopify.dev/docs/api/storefront/current/objects/MailingAddress), [orders](https://shopify.dev/docs/api/storefront/current/objects/Order), and [custom data](https://shopify.dev/docs/apps/build/custom-data) associated with the customer.
      ///
      var customer: Customer? { __data["customer"] }

      /// Customer
      ///
      /// Parent Type: `Customer`
      struct Customer: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Customer }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ShopifyAPI.ID.self),
          .field("firstName", String?.self),
          .field("orders", Orders.self, arguments: [
            "first": .variable("first"),
            "after": .variable("after"),
            "sortKey": "PROCESSED_AT",
            "reverse": true
          ]),
        ] }

        /// A unique ID for the customer.
        var id: ShopifyAPI.ID { __data["id"] }
        /// The customer’s first name.
        var firstName: String? { __data["firstName"] }
        /// The orders associated with the customer.
        var orders: Orders { __data["orders"] }

        /// Customer.Orders
        ///
        /// Parent Type: `OrderConnection`
        struct Orders: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderConnection }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("edges", [Edge].self),
            .field("pageInfo", PageInfo.self),
          ] }

          /// A list of edges.
          var edges: [Edge] { __data["edges"] }
          /// Information to aid in pagination.
          var pageInfo: PageInfo { __data["pageInfo"] }

          /// Customer.Orders.Edge
          ///
          /// Parent Type: `OrderEdge`
          struct Edge: ShopifyAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderEdge }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("cursor", String.self),
              .field("node", Node.self),
            ] }

            /// A cursor for use in pagination.
            var cursor: String { __data["cursor"] }
            /// The item at the end of OrderEdge.
            var node: Node { __data["node"] }

            /// Customer.Orders.Edge.Node
            ///
            /// Parent Type: `Order`
            struct Node: ShopifyAPI.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Order }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", ShopifyAPI.ID.self),
                .field("orderNumber", Int.self),
                .field("processedAt", ShopifyAPI.DateTime.self),
                .field("financialStatus", GraphQLEnum<ShopifyAPI.OrderFinancialStatus>?.self),
                .field("fulfillmentStatus", GraphQLEnum<ShopifyAPI.OrderFulfillmentStatus>.self),
                .field("currentTotalPrice", CurrentTotalPrice.self),
                .field("currentSubtotalPrice", CurrentSubtotalPrice.self),
                .field("discountApplications", DiscountApplications.self, arguments: ["first": 5]),
                .field("lineItems", LineItems.self, arguments: ["first": 10]),
                .field("shippingAddress", ShippingAddress?.self),
              ] }

              /// A globally-unique ID.
              var id: ShopifyAPI.ID { __data["id"] }
              /// A unique numeric identifier for the order for use by shop owner and customer.
              var orderNumber: Int { __data["orderNumber"] }
              /// The date and time when the order was imported.
              /// This value can be set to dates in the past when importing from other systems.
              /// If no value is provided, it will be auto-generated based on current date and time.
              ///
              var processedAt: ShopifyAPI.DateTime { __data["processedAt"] }
              /// The financial status of the order.
              var financialStatus: GraphQLEnum<ShopifyAPI.OrderFinancialStatus>? { __data["financialStatus"] }
              /// The fulfillment status for the order.
              var fulfillmentStatus: GraphQLEnum<ShopifyAPI.OrderFulfillmentStatus> { __data["fulfillmentStatus"] }
              /// The total amount of the order, including duties, taxes and discounts, minus amounts for line items that have been removed.
              var currentTotalPrice: CurrentTotalPrice { __data["currentTotalPrice"] }
              /// The subtotal of line items and their discounts, excluding line items that have been removed. Does not contain order-level discounts, duties, shipping costs, or shipping discounts. Taxes aren't included unless the order is a taxes-included order.
              var currentSubtotalPrice: CurrentSubtotalPrice { __data["currentSubtotalPrice"] }
              /// Discounts that have been applied on the order.
              var discountApplications: DiscountApplications { __data["discountApplications"] }
              /// List of the order’s line items.
              var lineItems: LineItems { __data["lineItems"] }
              /// The address to where the order will be shipped.
              var shippingAddress: ShippingAddress? { __data["shippingAddress"] }

              /// Customer.Orders.Edge.Node.CurrentTotalPrice
              ///
              /// Parent Type: `MoneyV2`
              struct CurrentTotalPrice: ShopifyAPI.SelectionSet {
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

              /// Customer.Orders.Edge.Node.CurrentSubtotalPrice
              ///
              /// Parent Type: `MoneyV2`
              struct CurrentSubtotalPrice: ShopifyAPI.SelectionSet {
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

              /// Customer.Orders.Edge.Node.DiscountApplications
              ///
              /// Parent Type: `DiscountApplicationConnection`
              struct DiscountApplications: ShopifyAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.DiscountApplicationConnection }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("edges", [Edge].self),
                ] }

                /// A list of edges.
                var edges: [Edge] { __data["edges"] }

                /// Customer.Orders.Edge.Node.DiscountApplications.Edge
                ///
                /// Parent Type: `DiscountApplicationEdge`
                struct Edge: ShopifyAPI.SelectionSet {
                  let __data: DataDict
                  init(_dataDict: DataDict) { __data = _dataDict }

                  static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.DiscountApplicationEdge }
                  static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("node", Node.self),
                  ] }

                  /// The item at the end of DiscountApplicationEdge.
                  var node: Node { __data["node"] }

                  /// Customer.Orders.Edge.Node.DiscountApplications.Edge.Node
                  ///
                  /// Parent Type: `DiscountApplication`
                  struct Node: ShopifyAPI.SelectionSet {
                    let __data: DataDict
                    init(_dataDict: DataDict) { __data = _dataDict }

                    static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Interfaces.DiscountApplication }
                    static var __selections: [ApolloAPI.Selection] { [
                      .field("__typename", String.self),
                      .inlineFragment(AsDiscountCodeApplication.self),
                    ] }

                    var asDiscountCodeApplication: AsDiscountCodeApplication? { _asInlineFragment() }

                    /// Customer.Orders.Edge.Node.DiscountApplications.Edge.Node.AsDiscountCodeApplication
                    ///
                    /// Parent Type: `DiscountCodeApplication`
                    struct AsDiscountCodeApplication: ShopifyAPI.InlineFragment {
                      let __data: DataDict
                      init(_dataDict: DataDict) { __data = _dataDict }

                      typealias RootEntityType = GetCustomerOrdersQuery.Data.Customer.Orders.Edge.Node.DiscountApplications.Edge.Node
                      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.DiscountCodeApplication }
                      static var __selections: [ApolloAPI.Selection] { [
                        .field("code", String.self),
                        .field("value", Value.self),
                      ] }

                      /// The string identifying the discount code that was used at the time of application.
                      var code: String { __data["code"] }
                      /// The value of the discount application.
                      var value: Value { __data["value"] }

                      /// Customer.Orders.Edge.Node.DiscountApplications.Edge.Node.AsDiscountCodeApplication.Value
                      ///
                      /// Parent Type: `PricingValue`
                      struct Value: ShopifyAPI.SelectionSet {
                        let __data: DataDict
                        init(_dataDict: DataDict) { __data = _dataDict }

                        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Unions.PricingValue }
                        static var __selections: [ApolloAPI.Selection] { [
                          .field("__typename", String.self),
                          .inlineFragment(AsPricingPercentageValue.self),
                          .inlineFragment(AsMoneyV2.self),
                        ] }

                        var asPricingPercentageValue: AsPricingPercentageValue? { _asInlineFragment() }
                        var asMoneyV2: AsMoneyV2? { _asInlineFragment() }

                        /// Customer.Orders.Edge.Node.DiscountApplications.Edge.Node.AsDiscountCodeApplication.Value.AsPricingPercentageValue
                        ///
                        /// Parent Type: `PricingPercentageValue`
                        struct AsPricingPercentageValue: ShopifyAPI.InlineFragment {
                          let __data: DataDict
                          init(_dataDict: DataDict) { __data = _dataDict }

                          typealias RootEntityType = GetCustomerOrdersQuery.Data.Customer.Orders.Edge.Node.DiscountApplications.Edge.Node.AsDiscountCodeApplication.Value
                          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.PricingPercentageValue }
                          static var __selections: [ApolloAPI.Selection] { [
                            .field("percentage", Double.self),
                          ] }

                          /// The percentage value of the object.
                          var percentage: Double { __data["percentage"] }
                        }

                        /// Customer.Orders.Edge.Node.DiscountApplications.Edge.Node.AsDiscountCodeApplication.Value.AsMoneyV2
                        ///
                        /// Parent Type: `MoneyV2`
                        struct AsMoneyV2: ShopifyAPI.InlineFragment {
                          let __data: DataDict
                          init(_dataDict: DataDict) { __data = _dataDict }

                          typealias RootEntityType = GetCustomerOrdersQuery.Data.Customer.Orders.Edge.Node.DiscountApplications.Edge.Node.AsDiscountCodeApplication.Value
                          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MoneyV2 }
                          static var __selections: [ApolloAPI.Selection] { [
                            .field("amount", ShopifyAPI.Decimal.self),
                            .field("currencyCode", GraphQLEnum<ShopifyAPI.CurrencyCode>.self),
                          ] }

                          /// Decimal money amount.
                          var amount: ShopifyAPI.Decimal { __data["amount"] }
                          /// Currency of the money.
                          var currencyCode: GraphQLEnum<ShopifyAPI.CurrencyCode> { __data["currencyCode"] }
                        }
                      }
                    }
                  }
                }
              }

              /// Customer.Orders.Edge.Node.LineItems
              ///
              /// Parent Type: `OrderLineItemConnection`
              struct LineItems: ShopifyAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderLineItemConnection }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("edges", [Edge].self),
                ] }

                /// A list of edges.
                var edges: [Edge] { __data["edges"] }

                /// Customer.Orders.Edge.Node.LineItems.Edge
                ///
                /// Parent Type: `OrderLineItemEdge`
                struct Edge: ShopifyAPI.SelectionSet {
                  let __data: DataDict
                  init(_dataDict: DataDict) { __data = _dataDict }

                  static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderLineItemEdge }
                  static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("node", Node.self),
                  ] }

                  /// The item at the end of OrderLineItemEdge.
                  var node: Node { __data["node"] }

                  /// Customer.Orders.Edge.Node.LineItems.Edge.Node
                  ///
                  /// Parent Type: `OrderLineItem`
                  struct Node: ShopifyAPI.SelectionSet {
                    let __data: DataDict
                    init(_dataDict: DataDict) { __data = _dataDict }

                    static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.OrderLineItem }
                    static var __selections: [ApolloAPI.Selection] { [
                      .field("__typename", String.self),
                      .field("title", String.self),
                      .field("quantity", Int.self),
                      .field("originalTotalPrice", OriginalTotalPrice.self),
                      .field("variant", Variant?.self),
                    ] }

                    /// The title of the product combined with title of the variant.
                    var title: String { __data["title"] }
                    /// The number of products variants associated to the line item.
                    var quantity: Int { __data["quantity"] }
                    /// The total price of the line item, not including any discounts. The total price is calculated using the original unit price multiplied by the quantity, and it's displayed in the presentment currency.
                    var originalTotalPrice: OriginalTotalPrice { __data["originalTotalPrice"] }
                    /// The product variant object associated to the line item.
                    var variant: Variant? { __data["variant"] }

                    /// Customer.Orders.Edge.Node.LineItems.Edge.Node.OriginalTotalPrice
                    ///
                    /// Parent Type: `MoneyV2`
                    struct OriginalTotalPrice: ShopifyAPI.SelectionSet {
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

                    /// Customer.Orders.Edge.Node.LineItems.Edge.Node.Variant
                    ///
                    /// Parent Type: `ProductVariant`
                    struct Variant: ShopifyAPI.SelectionSet {
                      let __data: DataDict
                      init(_dataDict: DataDict) { __data = _dataDict }

                      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }
                      static var __selections: [ApolloAPI.Selection] { [
                        .field("__typename", String.self),
                        .field("id", ShopifyAPI.ID.self),
                        .field("title", String.self),
                        .field("image", Image?.self),
                      ] }

                      /// A globally-unique ID.
                      var id: ShopifyAPI.ID { __data["id"] }
                      /// The product variant’s title.
                      var title: String { __data["title"] }
                      /// Image associated with the product variant. This field falls back to the product image if no image is available.
                      var image: Image? { __data["image"] }

                      /// Customer.Orders.Edge.Node.LineItems.Edge.Node.Variant.Image
                      ///
                      /// Parent Type: `Image`
                      struct Image: ShopifyAPI.SelectionSet {
                        let __data: DataDict
                        init(_dataDict: DataDict) { __data = _dataDict }

                        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Image }
                        static var __selections: [ApolloAPI.Selection] { [
                          .field("__typename", String.self),
                          .field("url", ShopifyAPI.URL.self),
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
                      }
                    }
                  }
                }
              }

              /// Customer.Orders.Edge.Node.ShippingAddress
              ///
              /// Parent Type: `MailingAddress`
              struct ShippingAddress: ShopifyAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddress }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("firstName", String?.self),
                  .field("lastName", String?.self),
                  .field("address1", String?.self),
                  .field("city", String?.self),
                  .field("country", String?.self),
                  .field("phone", String?.self),
                ] }

                /// The first name of the customer.
                var firstName: String? { __data["firstName"] }
                /// The last name of the customer.
                var lastName: String? { __data["lastName"] }
                /// The first line of the address. Typically the street address or PO Box number.
                var address1: String? { __data["address1"] }
                /// The name of the city, district, village, or town.
                var city: String? { __data["city"] }
                /// The name of the country.
                var country: String? { __data["country"] }
                /// A unique phone number for the customer.
                ///
                /// Formatted using E.164 standard. For example, _+16135551111_.
                ///
                var phone: String? { __data["phone"] }
              }
            }
          }

          /// Customer.Orders.PageInfo
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

}