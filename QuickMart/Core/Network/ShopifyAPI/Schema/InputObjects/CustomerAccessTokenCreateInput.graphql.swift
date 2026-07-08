// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension ShopifyAPI {
  /// The input fields for authenticating a customer with email and password. Used by the [`customerAccessTokenCreate`](https://shopify.dev/docs/api/storefront/current/mutations/customerAccessTokenCreate) mutation to generate a [`CustomerAccessToken`](https://shopify.dev/docs/api/storefront/current/objects/CustomerAccessToken), which is required to read or modify customer data.
  ///
  struct CustomerAccessTokenCreateInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      email: String,
      password: String
    ) {
      __data = InputDict([
        "email": email,
        "password": password
      ])
    }

    /// The email associated to the customer.
    var email: String {
      get { __data["email"] }
      set { __data["email"] = newValue }
    }

    /// The login password to be used by the customer.
    var password: String {
      get { __data["password"] }
      set { __data["password"] = newValue }
    }
  }

}