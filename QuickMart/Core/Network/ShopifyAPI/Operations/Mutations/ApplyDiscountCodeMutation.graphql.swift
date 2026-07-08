// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class ApplyDiscountCodeMutation: GraphQLMutation {
    static let operationName: String = "ApplyDiscountCode"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation ApplyDiscountCode($cartId: ID!, $discountCodes: [String!]!) { cartDiscountCodesUpdate(cartId: $cartId, discountCodes: $discountCodes) { __typename cart { __typename id discountCodes { __typename code applicable } cost { __typename subtotalAmount { __typename amount currencyCode } totalAmount { __typename amount currencyCode } } } userErrors { __typename code field message } } }"#
      ))

    public var cartId: ID
    public var discountCodes: [String]

    public init(
      cartId: ID,
      discountCodes: [String]
    ) {
      self.cartId = cartId
      self.discountCodes = discountCodes
    }

    public var __variables: Variables? { [
      "cartId": cartId,
      "discountCodes": discountCodes
    ] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("cartDiscountCodesUpdate", CartDiscountCodesUpdate?.self, arguments: [
          "cartId": .variable("cartId"),
          "discountCodes": .variable("discountCodes")
        ]),
      ] }

      /// Updates the discount codes applied to a [`Cart`](https://shopify.dev/docs/api/storefront/current/objects/Cart). This mutation replaces all existing discount codes with the provided list, so pass an empty array to remove all codes. Discount codes are case-insensitive.
      ///
      /// After updating, check each [`CartDiscountCode`](https://shopify.dev/docs/api/storefront/current/objects/CartDiscountCode) in the cart's [`discountCodes`](https://shopify.dev/docs/api/storefront/current/objects/Cart#field-Cart.fields.discountCodes) field to see whether the code is applicable to the cart's current contents.
      ///
      var cartDiscountCodesUpdate: CartDiscountCodesUpdate? { __data["cartDiscountCodesUpdate"] }

      /// CartDiscountCodesUpdate
      ///
      /// Parent Type: `CartDiscountCodesUpdatePayload`
      struct CartDiscountCodesUpdate: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartDiscountCodesUpdatePayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cart", Cart?.self),
          .field("userErrors", [UserError].self),
        ] }

        /// The updated cart.
        var cart: Cart? { __data["cart"] }
        /// The list of errors that occurred from executing the mutation.
        var userErrors: [UserError] { __data["userErrors"] }

        /// CartDiscountCodesUpdate.Cart
        ///
        /// Parent Type: `Cart`
        struct Cart: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Cart }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAPI.ID.self),
            .field("discountCodes", [DiscountCode].self),
            .field("cost", Cost.self),
          ] }

          /// A globally-unique ID.
          var id: ShopifyAPI.ID { __data["id"] }
          /// The case-insensitive discount codes that the customer added at checkout.
          var discountCodes: [DiscountCode] { __data["discountCodes"] }
          /// The estimated costs that the buyer will pay at checkout. The costs are subject to change and changes will be reflected at checkout. The `cost` field uses the `buyerIdentity` field to determine [international pricing](https://shopify.dev/custom-storefronts/internationalization/international-pricing).
          var cost: Cost { __data["cost"] }

          /// CartDiscountCodesUpdate.Cart.DiscountCode
          ///
          /// Parent Type: `CartDiscountCode`
          struct DiscountCode: ShopifyAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CartDiscountCode }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("code", String.self),
              .field("applicable", Bool.self),
            ] }

            /// The code for the discount.
            var code: String { __data["code"] }
            /// Whether the discount code is applicable to the cart's current contents.
            var applicable: Bool { __data["applicable"] }
          }

          /// CartDiscountCodesUpdate.Cart.Cost
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

            /// CartDiscountCodesUpdate.Cart.Cost.SubtotalAmount
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

            /// CartDiscountCodesUpdate.Cart.Cost.TotalAmount
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
        }

        /// CartDiscountCodesUpdate.UserError
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