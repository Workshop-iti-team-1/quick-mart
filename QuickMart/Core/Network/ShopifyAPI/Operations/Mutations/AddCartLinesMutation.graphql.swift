// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class AddCartLinesMutation: GraphQLMutation {
    static let operationName: String = "AddCartLines"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation AddCartLines($cartId: ID!, $lines: [CartLineInput!]!) { cartLinesAdd(cartId: $cartId, lines: $lines) { __typename cart { __typename id totalQuantity cost { __typename subtotalAmount { __typename amount currencyCode } totalAmount { __typename amount currencyCode } } lines(first: 20) { __typename edges { __typename node { __typename id quantity merchandise { __typename ... on ProductVariant { id title price { __typename amount currencyCode } quantityAvailable product { __typename title vendor } } } } } } } userErrors { __typename code field message } } }"#
      ))

    public var cartId: ID
    public var lines: [CartLineInput]

    public init(
      cartId: ID,
      lines: [CartLineInput]
    ) {
      self.cartId = cartId
      self.lines = lines
    }

    public var __variables: Variables? { [
      "cartId": cartId,
      "lines": lines
    ] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("cartLinesAdd", CartLinesAdd?.self, arguments: [
          "cartId": .variable("cartId"),
          "lines": .variable("lines")
        ]),
      ] }

      /// Adds one or more merchandise lines to an existing [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart). Each line specifies the [product variant](https://shopify.dev/docs/api/storefront/current/objects/ProductVariant) to purchase. Quantity defaults to `1` if not provided.
      ///
      /// You can add up to 250 lines in a single request. Use [`CartLineInput`](https://shopify.dev/docs/api/storefront/current/input-objects/CartLineInput) to configure each line's merchandise, quantity, selling plan, custom attributes, and any parent relationships for nested line items such as warranties or add-ons.
      ///
      var cartLinesAdd: CartLinesAdd? { __data["cartLinesAdd"] }

      /// CartLinesAdd
      ///
      /// Parent Type: `CartLinesAddPayload`
      struct CartLinesAdd: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartLinesAddPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The updated cart.
        var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        var userErrors: [UserError] { __data["userErrors"] }

        /// CartLinesAdd.Cart
        ///
        /// Parent Type: `Cart`
        struct Cart: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Cart }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAPI.ID.self),
            .field("totalQuantity", Int.self),
            .field("cost", Cost.self),
            .field("lines", Lines.self, arguments: ["first": 20]),
          ] }

          /// A globally-unique ID.
          var id: ShopifyAPI.ID { __data["id"] }
          /// The total number of items in the cart.
          var totalQuantity: Int { __data["totalQuantity"] }
          /// The estimated costs that the buyer will pay at checkout. The costs are subject to change and changes will be reflected at checkout. The `cost` field uses the `buyerIdentity` field to determine [international pricing](https://shopify.dev/custom-storefronts/internationalization/international-pricing).
          var cost: Cost { __data["cost"] }
          /// A list of lines containing information about the items the customer intends to purchase.
          var lines: Lines { __data["lines"] }

          /// CartLinesAdd.Cart.Cost
          ///
          /// Parent Type: `CartCost`
          struct Cost: ShopifyAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartCost }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("subtotalAmount", SubtotalAmount.self),
              .field("totalAmount", TotalAmount.self),
            ] }

            /// The amount, before taxes and cart-level discounts, for the customer to pay.
            var subtotalAmount: SubtotalAmount { __data["subtotalAmount"] }
            /// The total amount for the customer to pay.
            var totalAmount: TotalAmount { __data["totalAmount"] }

            /// CartLinesAdd.Cart.Cost.SubtotalAmount
            ///
            /// Parent Type: `MoneyV2`
            struct SubtotalAmount: ShopifyAPI.SelectionSet {
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

            /// CartLinesAdd.Cart.Cost.TotalAmount
            ///
            /// Parent Type: `MoneyV2`
            struct TotalAmount: ShopifyAPI.SelectionSet {
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

          /// CartLinesAdd.Cart.Lines
          ///
          /// Parent Type: `BaseCartLineConnection`
          struct Lines: ShopifyAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.BaseCartLineConnection }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("edges", [Edge].self),
            ] }

            /// A list of edges.
            var edges: [Edge] { __data["edges"] }

            /// CartLinesAdd.Cart.Lines.Edge
            ///
            /// Parent Type: `BaseCartLineEdge`
            struct Edge: ShopifyAPI.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.BaseCartLineEdge }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("node", Node.self),
              ] }

              /// The item at the end of BaseCartLineEdge.
              var node: Node { __data["node"] }

              /// CartLinesAdd.Cart.Lines.Edge.Node
              ///
              /// Parent Type: `BaseCartLine`
              struct Node: ShopifyAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Interfaces.BaseCartLine }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("id", ShopifyAPI.ID.self),
                  .field("quantity", Int.self),
                  .field("merchandise", Merchandise.self),
                ] }

                /// A globally-unique ID.
                var id: ShopifyAPI.ID { __data["id"] }
                /// The quantity of the merchandise that the customer intends to purchase.
                var quantity: Int { __data["quantity"] }
                /// The merchandise that the buyer intends to purchase.
                var merchandise: Merchandise { __data["merchandise"] }

                /// CartLinesAdd.Cart.Lines.Edge.Node.Merchandise
                ///
                /// Parent Type: `Merchandise`
                struct Merchandise: ShopifyAPI.SelectionSet {
                  let __data: DataDict
                  init(_dataDict: DataDict) { __data = _dataDict }

                  static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Unions.Merchandise }
                  static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .inlineFragment(AsProductVariant.self),
                  ] }

                  var asProductVariant: AsProductVariant? { _asInlineFragment() }

                  /// CartLinesAdd.Cart.Lines.Edge.Node.Merchandise.AsProductVariant
                  ///
                  /// Parent Type: `ProductVariant`
                  struct AsProductVariant: ShopifyAPI.InlineFragment {
                    let __data: DataDict
                    init(_dataDict: DataDict) { __data = _dataDict }

                    typealias RootEntityType = AddCartLinesMutation.Data.CartLinesAdd.Cart.Lines.Edge.Node.Merchandise
                    static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }
                    static var __selections: [ApolloAPI.Selection] { [
                      .field("id", ShopifyAPI.ID.self),
                      .field("title", String.self),
                      .field("price", Price.self),
                      .field("quantityAvailable", Int?.self),
                      .field("product", Product.self),
                    ] }

                    /// A globally-unique ID.
                    var id: ShopifyAPI.ID { __data["id"] }
                    /// The product variant’s title.
                    var title: String { __data["title"] }
                    /// The product variant’s price.
                    var price: Price { __data["price"] }
                    /// The total sellable quantity of the variant for online sales channels.
                    var quantityAvailable: Int? { __data["quantityAvailable"] }
                    /// The product object that the product variant belongs to.
                    var product: Product { __data["product"] }

                    /// CartLinesAdd.Cart.Lines.Edge.Node.Merchandise.AsProductVariant.Price
                    ///
                    /// Parent Type: `MoneyV2`
                    struct Price: ShopifyAPI.SelectionSet {
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

                    /// CartLinesAdd.Cart.Lines.Edge.Node.Merchandise.AsProductVariant.Product
                    ///
                    /// Parent Type: `Product`
                    struct Product: ShopifyAPI.SelectionSet {
                      let __data: DataDict
                      init(_dataDict: DataDict) { __data = _dataDict }

                      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Product }
                      static var __selections: [ApolloAPI.Selection] { [
                        .field("__typename", String.self),
                        .field("title", String.self),
                        .field("vendor", String.self),
                      ] }

                      /// The name for the product that displays to customers. The title is used to construct the product's handle.
                      /// For example, if a product is titled "Black Sunglasses", then the handle is `black-sunglasses`.
                      ///
                      var title: String { __data["title"] }
                      /// The name of the product's vendor.
                      var vendor: String { __data["vendor"] }
                    }
                  }
                }
              }
            }
          }
        }

        /// CartLinesAdd.UserError
        ///
        /// Parent Type: `CartUserError`
        struct UserError: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartUserError }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("code", GraphQLEnum<ShopifyAPI.CartErrorCode>?.self),
            .field("field", [String]?.self),
            .field("message", String.self),
          ] }

          /// The error code.
          var code: GraphQLEnum<ShopifyAPI.CartErrorCode>? { __data["code"] }
          /// The path to the input field that caused the error.
          var field: [String]? { __data["field"] }
          /// The error message.
          var message: String { __data["message"] }
        }
      }
    }
  }

}