// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LoginCustomerMutation: GraphQLMutation {
  public static let operationName: String = "LoginCustomer"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation LoginCustomer($input: CustomerAccessTokenCreateInput!) { customerAccessTokenCreate(input: $input) { __typename customerAccessToken { __typename accessToken expiresAt } customerUserErrors { __typename code field message } } }"#
    ))

  public var input: CustomerAccessTokenCreateInput

  public init(input: CustomerAccessTokenCreateInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ShopifyAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("customerAccessTokenCreate", CustomerAccessTokenCreate?.self, arguments: ["input": .variable("input")]),
    ] }

    /// For legacy customer accounts only.
    ///
    /// Creates a [`CustomerAccessToken`](https://shopify.dev/docs/api/storefront/current/objects/CustomerAccessToken) using the customer's email and password. The access token is required to read or modify the [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer) object, such as updating account information or managing addresses.
    ///
    /// The token has an expiration time. Use [`customerAccessTokenRenew`](https://shopify.dev/docs/api/storefront/current/mutations/customerAccessTokenRenew) to extend the token before it expires, or create a new token if it's already expired.
    ///
    /// > Caution:
    /// > This mutation handles customer credentials. Always transmit requests over HTTPS and never log or expose the password.
    ///
    public var customerAccessTokenCreate: CustomerAccessTokenCreate? { __data["customerAccessTokenCreate"] }

    /// CustomerAccessTokenCreate
    ///
    /// Parent Type: `CustomerAccessTokenCreatePayload`
    public struct CustomerAccessTokenCreate: ShopifyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerAccessTokenCreatePayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("customerAccessToken", CustomerAccessToken?.self),
        .field("customerUserErrors", [CustomerUserError].self),
      ] }

      /// The newly created customer access token object.
      public var customerAccessToken: CustomerAccessToken? { __data["customerAccessToken"] }
      /// The list of errors that occurred from executing the mutation.
      public var customerUserErrors: [CustomerUserError] { __data["customerUserErrors"] }

      /// CustomerAccessTokenCreate.CustomerAccessToken
      ///
      /// Parent Type: `CustomerAccessToken`
      public struct CustomerAccessToken: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerAccessToken }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("accessToken", String.self),
          .field("expiresAt", ShopifyAPI.DateTime.self),
        ] }

        /// The customer’s access token.
        public var accessToken: String { __data["accessToken"] }
        /// The date and time when the customer access token expires.
        public var expiresAt: ShopifyAPI.DateTime { __data["expiresAt"] }
      }

      /// CustomerAccessTokenCreate.CustomerUserError
      ///
      /// Parent Type: `CustomerUserError`
      public struct CustomerUserError: ShopifyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerUserError }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("code", GraphQLEnum<ShopifyAPI.CustomerErrorCode>?.self),
          .field("field", [String]?.self),
          .field("message", String.self),
        ] }

        /// The error code.
        public var code: GraphQLEnum<ShopifyAPI.CustomerErrorCode>? { __data["code"] }
        /// The path to the input field that caused the error.
        public var field: [String]? { __data["field"] }
        /// The error message.
        public var message: String { __data["message"] }
      }
    }
  }
}
