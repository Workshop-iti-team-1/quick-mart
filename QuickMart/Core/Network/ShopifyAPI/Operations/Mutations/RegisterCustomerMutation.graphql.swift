// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class RegisterCustomerMutation: GraphQLMutation {
    static let operationName: String = "RegisterCustomer"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation RegisterCustomer($input: CustomerCreateInput!) { customerCreate(input: $input) { __typename customer { __typename id firstName lastName email } customerUserErrors { __typename code field message } } }"#
      ))

    public var input: CustomerCreateInput

    public init(input: CustomerCreateInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("customerCreate", CustomerCreate?.self, arguments: ["input": .variable("input")]),
      ] }

      /// Creates a new [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer) account with the provided contact information and login credentials. The customer can then sign in for things such as accessing their account, viewing order history, and managing saved addresses.
      ///
      /// > Caution:
      /// > This mutation creates customer credentials. Ensure passwords are collected securely and never logged or exposed in client-side code.
      ///
      var customerCreate: CustomerCreate? { __data["customerCreate"] }

      /// CustomerCreate
      ///
      /// Parent Type: `CustomerCreatePayload`
      struct CustomerCreate: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerCreatePayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("customer", Customer?.self),
          .field("customerUserErrors", [CustomerUserError].self),
        ] }

        /// The created customer object.
        var customer: Customer? { __data["customer"] }
        /// The list of errors that occurred from executing the mutation.
        var customerUserErrors: [CustomerUserError] { __data["customerUserErrors"] }

        /// CustomerCreate.Customer
        ///
        /// Parent Type: `Customer`
        struct Customer: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Customer }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAPI.ID.self),
            .field("firstName", String?.self),
            .field("lastName", String?.self),
            .field("email", String?.self),
          ] }

          /// A unique ID for the customer.
          var id: ShopifyAPI.ID { __data["id"] }
          /// The customer’s first name.
          var firstName: String? { __data["firstName"] }
          /// The customer’s last name.
          var lastName: String? { __data["lastName"] }
          /// The customer’s email address.
          var email: String? { __data["email"] }
        }

        /// CustomerCreate.CustomerUserError
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