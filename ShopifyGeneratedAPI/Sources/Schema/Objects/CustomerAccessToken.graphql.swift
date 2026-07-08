// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// A unique authentication token that identifies a logged-in customer and authorizes modifications to the [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer) object. The token is required for customer-specific operations like updating profile information or managing addresses.
  ///
  /// Tokens have an expiration date and must be renewed using [`customerAccessTokenRenew`](https://shopify.dev/docs/api/storefront/current/mutations/customerAccessTokenRenew) before they expire. Create tokens with [`customerAccessTokenCreate`](https://shopify.dev/docs/api/storefront/current/mutations/customerAccessTokenCreate) using legacy customer account authentication (email and password), or with [`customerAccessTokenCreateWithMultipass`](https://shopify.dev/docs/api/storefront/current/mutations/customerAccessTokenCreateWithMultipass) for single sign-on flows.
  ///
  static let CustomerAccessToken = Object(
    typename: "CustomerAccessToken",
    implementedInterfaces: []
  )
}