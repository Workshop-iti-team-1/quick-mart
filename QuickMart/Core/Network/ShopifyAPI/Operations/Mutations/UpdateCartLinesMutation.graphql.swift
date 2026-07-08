// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class UpdateCartLinesMutation: GraphQLMutation {
    static let operationName: String = "UpdateCartLines"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateCartLines($cartId: ID!, $lines: [CartLineUpdateInput!]!) { cartLinesUpdate(cartId: $cartId, lines: $lines) { __typename cart { __typename id totalQuantity cost { __typename subtotalAmount { __typename amount currencyCode } totalAmount { __typename amount currencyCode } } lines(first: 20) { __typename edges { __typename node { __typename id quantity merchandise { __typename ... on ProductVariant { id title quantityAvailable availableForSale } } } } } } userErrors { __typename code field message } } }"#
      ))

    public var cartId: ID
    public var lines: [CartLineUpdateInput]

    public init(
      cartId: ID,
      lines: [CartLineUpdateInput]
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
        .field("cartLinesUpdate", CartLinesUpdate?.self, arguments: [
          "cartId": .variable("cartId"),
          "lines": .variable("lines")
        ]),
      ] }

      /// Updates one or more merchandise lines on a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart). You can modify the quantity, swap the merchandise, change custom attributes, or update the selling plan for each line. You can update a maximum of 250 lines per request.
      ///
      /// Omitting the [`attributes`](https://shopify.dev/docs/api/storefront/current/mutations/cartLinesUpdate#arguments-lines.fields.attributes) field or setting it to null preserves existing line attributes. Pass an empty array to clear all attributes from a line.
      ///
      var cartLinesUpdate: CartLinesUpdate? { __data["cartLinesUpdate"] }

      /// CartLinesUpdate
      ///
      /// Parent Type: `CartLinesUpdatePayload`
      struct CartLinesUpdate: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartLinesUpdatePayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The updated cart.
        var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        var userErrors: [UserError] { __data["userErrors"] }

        /// CartLinesUpdate.Cart
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

          /// CartLinesUpdate.Cart.Cost
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

            /// CartLinesUpdate.Cart.Cost.SubtotalAmount
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

            /// CartLinesUpdate.Cart.Cost.TotalAmount
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

          /// CartLinesUpdate.Cart.Lines
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

            /// CartLinesUpdate.Cart.Lines.Edge
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

              /// CartLinesUpdate.Cart.Lines.Edge.Node
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

                /// CartLinesUpdate.Cart.Lines.Edge.Node.Merchandise
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

                  /// CartLinesUpdate.Cart.Lines.Edge.Node.Merchandise.AsProductVariant
                  ///
                  /// Parent Type: `ProductVariant`
                  struct AsProductVariant: ShopifyAPI.InlineFragment {
                    let __data: DataDict
                    init(_dataDict: DataDict) { __data = _dataDict }

                    typealias RootEntityType = UpdateCartLinesMutation.Data.CartLinesUpdate.Cart.Lines.Edge.Node.Merchandise
                    static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }
                    static var __selections: [ApolloAPI.Selection] { [
                      .field("id", ShopifyAPI.ID.self),
                      .field("title", String.self),
                      .field("quantityAvailable", Int?.self),
                      .field("availableForSale", Bool.self),
                    ] }

                    /// A globally-unique ID.
                    var id: ShopifyAPI.ID { __data["id"] }
                    /// The product variant’s title.
                    var title: String { __data["title"] }
                    /// The total sellable quantity of the variant for online sales channels.
                    var quantityAvailable: Int? { __data["quantityAvailable"] }
                    /// Indicates if the product variant is available for sale.
                    var availableForSale: Bool { __data["availableForSale"] }
                  }
                }
              }
            }
          }
        }

        /// CartLinesUpdate.UserError
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