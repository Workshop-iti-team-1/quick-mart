// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class RecoverPasswordMutation: GraphQLMutation {
    static let operationName: String = "RecoverPassword"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation RecoverPassword($email: String!) { customerRecover(email: $email) { __typename customerUserErrors { __typename code field message } } }"#
      ))

    public var email: String

    public init(email: String) {
      self.email = email
    }

    public var __variables: Variables? { ["email": email] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("customerRecover", CustomerRecover?.self, arguments: ["email": .variable("email")]),
      ] }

      /// Sends a reset password email to the customer. The email contains a reset password URL and token that you can pass to the [`customerResetByUrl`](https://shopify.dev/docs/api/storefront/current/mutations/customerResetByUrl) or [`customerReset`](https://shopify.dev/docs/api/storefront/current/mutations/customerReset) mutation to reset the customer's password.
      ///
      /// This mutation is throttled by IP. With private access, you can provide a [`Shopify-Storefront-Buyer-IP` header](https://shopify.dev/docs/api/usage/authentication#optional-ip-header) instead of the request IP. The header is case-sensitive.
      ///
      /// > Caution:
      /// > Ensure the value provided to `Shopify-Storefront-Buyer-IP` is trusted. Unthrottled access to this mutation presents a security risk.
      ///
      var customerRecover: CustomerRecover? { __data["customerRecover"] }

      /// CustomerRecover
      ///
      /// Parent Type: `CustomerRecoverPayload`
      struct CustomerRecover: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerRecoverPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("customerUserErrors", [CustomerUserError].self),
        ] }

        /// The list of errors that occurred from executing the mutation.
        var customerUserErrors: [CustomerUserError] { __data["customerUserErrors"] }

        /// CustomerRecover.CustomerUserError
        ///
        /// Parent Type: `CustomerUserError`
        struct CustomerUserError: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerUserError }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("code", GraphQLEnum<ShopifyAPI.CustomerErrorCode>?.self),
            .field("field", [String]?.self),
            .field("message", String.self),
          ] }

          /// The error code.
          var code: GraphQLEnum<ShopifyAPI.CustomerErrorCode>? { __data["code"] }
          /// The path to the input field that caused the error.
          var field: [String]? { __data["field"] }
          /// The error message.
          var message: String { __data["message"] }
        }
      }
    }
  }

}