// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension ShopifyAPI.Objects {
  /// An [automatic discount](https://help.shopify.com/manual/discounts/discount-methods/automatic-discounts) applied to a cart or checkout without requiring a discount code. Implements the [`DiscountApplication`](https://shopify.dev/docs/api/storefront/current/interfaces/DiscountApplication) interface.
  ///
  /// Includes the discount's title, value, and allocation details that specify how the discount amount distributes across entitled line items or shipping lines.
  ///
  static let AutomaticDiscountApplication = Object(
    typename: "AutomaticDiscountApplication",
    implementedInterfaces: [ShopifyAPI.Interfaces.DiscountApplication.self]
  )
}