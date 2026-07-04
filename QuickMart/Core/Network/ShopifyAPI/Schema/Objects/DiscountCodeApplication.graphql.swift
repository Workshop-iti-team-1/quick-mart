// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension ShopifyAPI.Objects {
  /// Records the configuration and intent of a [discount code](https://help.shopify.com/manual/discounts/discount-methods/discount-codes) when a customer applies it. This includes the code string, allocation method, target type, and discount value at the time of application. The [`applicable`](https://shopify.dev/docs/api/storefront/latest/objects/DiscountCodeApplication#field-DiscountCodeApplication.fields.applicable) field indicates whether the code was successfully applied.
  ///
  /// > Note:
  /// > To see the actual amounts discounted on specific line items or shipping lines, use the [`DiscountAllocation`](https://shopify.dev/docs/api/storefront/current/objects/DiscountAllocation) object instead.
  ///
  static let DiscountCodeApplication = Object(
    typename: "DiscountCodeApplication",
    implementedInterfaces: [ShopifyAPI.Interfaces.DiscountApplication.self]
  )
}