// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class CreateCartMutation: GraphQLMutation {
    static let operationName: String = "CreateCart"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateCart($input: CartInput!) { cartCreate(input: $input) { __typename cart { __typename id checkoutUrl totalQuantity cost { __typename subtotalAmount { __typename amount currencyCode } totalAmount { __typename amount currencyCode } totalTaxAmount { __typename amount currencyCode } } lines(first: 20) { __typename edges { __typename node { __typename id quantity cost { __typename totalAmount { __typename amount currencyCode } } merchandise { __typename ... on ProductVariant { id title price { __typename amount currencyCode } availableForSale quantityAvailable image { __typename url altText } product { __typename id title vendor } } } } } } } userErrors { __typename code field message } } }"#
      ))

    public var input: CartInput

    public init(input: CartInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("cartCreate", CartCreate?.self, arguments: ["input": .variable("input")]),
      ] }

      /// Creates a new [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart) for a buyer session. You can optionally initialize the cart with merchandise lines, discount codes, gift card codes, buyer identity for international pricing, and custom attributes.
      ///
      /// The returned cart includes a `checkoutUrl` that directs the buyer to complete their purchase.
      ///
      var cartCreate: CartCreate? { __data["cartCreate"] }

      /// CartCreate
      ///
      /// Parent Type: `CartCreatePayload`
      struct CartCreate: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartCreatePayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The new cart.
        var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        var userErrors: [UserError] { __data["userErrors"] }

        /// CartCreate.Cart
        ///
        /// Parent Type: `Cart`
        struct Cart: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Cart }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAPI.ID.self),
            .field("checkoutUrl", ShopifyAPI.URL.self),
            .field("totalQuantity", Int.self),
            .field("cost", Cost.self),
            .field("lines", Lines.self, arguments: ["first": 20]),
          ] }

          /// A globally-unique ID.
          var id: ShopifyAPI.ID { __data["id"] }
          /// The URL of the checkout for the cart.
          var checkoutUrl: ShopifyAPI.URL { __data["checkoutUrl"] }
          /// The total number of items in the cart.
          var totalQuantity: Int { __data["totalQuantity"] }
          /// The estimated costs that the buyer will pay at checkout. The costs are subject to change and changes will be reflected at checkout. The `cost` field uses the `buyerIdentity` field to determine [international pricing](https://shopify.dev/custom-storefronts/internationalization/international-pricing).
          var cost: Cost { __data["cost"] }
          /// A list of lines containing information about the items the customer intends to purchase.
          var lines: Lines { __data["lines"] }

          /// CartCreate.Cart.Cost
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
              .field("totalTaxAmount", TotalTaxAmount?.self),
            ] }

            /// The amount, before taxes and cart-level discounts, for the customer to pay.
            var subtotalAmount: SubtotalAmount { __data["subtotalAmount"] }
            /// The total amount for the customer to pay.
            var totalAmount: TotalAmount { __data["totalAmount"] }
            /// The tax amount for the customer to pay at checkout.
            @available(*, deprecated, message: "Tax and duty amounts are no longer available and will be removed in a future version.\nPlease see [the changelog](https://shopify.dev/changelog/tax-and-duties-are-deprecated-in-storefront-cart-api)\nfor more information.\n")
            var totalTaxAmount: TotalTaxAmount? { __data["totalTaxAmount"] }

            /// CartCreate.Cart.Cost.SubtotalAmount
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

            /// CartCreate.Cart.Cost.TotalAmount
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

            /// CartCreate.Cart.Cost.TotalTaxAmount
            ///
            /// Parent Type: `MoneyV2`
            struct TotalTaxAmount: ShopifyAPI.SelectionSet {
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

          /// CartCreate.Cart.Lines
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

            /// CartCreate.Cart.Lines.Edge
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

              /// CartCreate.Cart.Lines.Edge.Node
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
                  .field("cost", Cost.self),
                  .field("merchandise", Merchandise.self),
                ] }

                /// A globally-unique ID.
                var id: ShopifyAPI.ID { __data["id"] }
                /// The quantity of the merchandise that the customer intends to purchase.
                var quantity: Int { __data["quantity"] }
                /// The cost of the merchandise that the buyer will pay for at checkout. The costs are subject to change and changes will be reflected at checkout.
                var cost: Cost { __data["cost"] }
                /// The merchandise that the buyer intends to purchase.
                var merchandise: Merchandise { __data["merchandise"] }

                /// CartCreate.Cart.Lines.Edge.Node.Cost
                ///
                /// Parent Type: `CartLineCost`
                struct Cost: ShopifyAPI.SelectionSet {
                  let __data: DataDict
                  init(_dataDict: DataDict) { __data = _dataDict }

                  static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartLineCost }
                  static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("totalAmount", TotalAmount.self),
                  ] }

                  /// The total cost of the merchandise line.
                  var totalAmount: TotalAmount { __data["totalAmount"] }

                  /// CartCreate.Cart.Lines.Edge.Node.Cost.TotalAmount
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

                /// CartCreate.Cart.Lines.Edge.Node.Merchandise
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

                  /// CartCreate.Cart.Lines.Edge.Node.Merchandise.AsProductVariant
                  ///
                  /// Parent Type: `ProductVariant`
                  struct AsProductVariant: ShopifyAPI.InlineFragment {
                    let __data: DataDict
                    init(_dataDict: DataDict) { __data = _dataDict }

                    typealias RootEntityType = CreateCartMutation.Data.CartCreate.Cart.Lines.Edge.Node.Merchandise
                    static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.ProductVariant }
                    static var __selections: [ApolloAPI.Selection] { [
                      .field("id", ShopifyAPI.ID.self),
                      .field("title", String.self),
                      .field("price", Price.self),
                      .field("availableForSale", Bool.self),
                      .field("quantityAvailable", Int?.self),
                      .field("image", Image?.self),
                      .field("product", Product.self),
                    ] }

                    /// A globally-unique ID.
                    var id: ShopifyAPI.ID { __data["id"] }
                    /// The product variant’s title.
                    var title: String { __data["title"] }
                    /// The product variant’s price.
                    var price: Price { __data["price"] }
                    /// Indicates if the product variant is available for sale.
                    var availableForSale: Bool { __data["availableForSale"] }
                    /// The total sellable quantity of the variant for online sales channels.
                    var quantityAvailable: Int? { __data["quantityAvailable"] }
                    /// Image associated with the product variant. This field falls back to the product image if no image is available.
                    var image: Image? { __data["image"] }
                    /// The product object that the product variant belongs to.
                    var product: Product { __data["product"] }

                    /// CartCreate.Cart.Lines.Edge.Node.Merchandise.AsProductVariant.Price
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

                    /// CartCreate.Cart.Lines.Edge.Node.Merchandise.AsProductVariant.Image
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

                    /// CartCreate.Cart.Lines.Edge.Node.Merchandise.AsProductVariant.Product
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
                      ] }

                      /// A globally-unique ID.
                      var id: ShopifyAPI.ID { __data["id"] }
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

        /// CartCreate.UserError
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