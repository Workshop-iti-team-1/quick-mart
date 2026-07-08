// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension ShopifyAPI.Unions {
  /// The price value (fixed or percentage) for a discount application.
  static let PricingValue = Union(
    name: "PricingValue",
    possibleTypes: [
      ShopifyAPI.Objects.MoneyV2.self,
      ShopifyAPI.Objects.PricingPercentageValue.self
    ]
  )
}