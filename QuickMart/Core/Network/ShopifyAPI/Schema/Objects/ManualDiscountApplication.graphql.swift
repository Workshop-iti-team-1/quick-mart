// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension ShopifyAPI.Objects {
  /// A discount created manually by a merchant, as opposed to [automatic discounts](https://help.shopify.com/manual/discounts/discount-methods/automatic-discounts) or [discount codes](https://help.shopify.com/manual/discounts/discount-methods/discount-codes). Implements the [`DiscountApplication`](https://shopify.dev/docs/api/storefront/current/interfaces/DiscountApplication) interface and includes a title, optional description, and the discount value as either a fixed amount or percentage.
  ///
  static let ManualDiscountApplication = Object(
    typename: "ManualDiscountApplication",
    implementedInterfaces: [ShopifyAPI.Interfaces.DiscountApplication.self]
  )
}