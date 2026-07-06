// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class GetCustomerQuery: GraphQLQuery {
    static let operationName: String = "GetCustomer"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetCustomer($customerAccessToken: String!) { customer(customerAccessToken: $customerAccessToken) { __typename id firstName lastName email } }"#
      ))

    public var customerAccessToken: String

    public init(customerAccessToken: String) {
      self.customerAccessToken = customerAccessToken
    }

    public var __variables: Variables? { ["customerAccessToken": customerAccessToken] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.QueryRoot }
      static var __selections: [ApolloAPI.Selection] { [
        .field("customer", Customer?.self, arguments: ["customerAccessToken": .variable("customerAccessToken")]),
      ] }

      /// Retrieves the [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer) associated with the provided access token. Use the [`customerAccessTokenCreate`](https://shopify.dev/docs/api/storefront/current/mutations/customerAccessTokenCreate) mutation to obtain an access token using legacy customer account authentication (email and password).
      ///
      /// The returned customer includes data such as contact information, [addresses](https://shopify.dev/docs/api/storefront/current/objects/MailingAddress), [orders](https://shopify.dev/docs/api/storefront/current/objects/Order), and [custom data](https://shopify.dev/docs/apps/build/custom-data) associated with the customer.
      ///
      var customer: Customer? { __data["customer"] }

      /// Customer
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
    }
  }

}