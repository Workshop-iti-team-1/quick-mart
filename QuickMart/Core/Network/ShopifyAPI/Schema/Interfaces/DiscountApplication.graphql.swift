// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension ShopifyAPI.Interfaces {
  /// Captures the intent of a discount at the time it was applied. Each implementation represents a different discount source, such as [automatic discounts](https://help.shopify.com/manual/discounts/discount-methods/automatic-discounts), [discount codes](https://help.shopify.com/manual/discounts/discount-methods/discount-codes), and manual discounts.
  ///
  /// The actual discounted amount on a line item or shipping line is represented by the [`DiscountAllocation`](https://shopify.dev/docs/api/storefront/current/objects/DiscountAllocation) object, which references the discount application it originated from.
  ///
  static let DiscountApplication = Interface(name: "DiscountApplication")
}