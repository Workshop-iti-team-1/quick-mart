// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class AddCustomerAddressMutation: GraphQLMutation {
    static let operationName: String = "AddCustomerAddress"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation AddCustomerAddress($customerAccessToken: String!, $address: MailingAddressInput!) { customerAddressCreate( customerAccessToken: $customerAccessToken address: $address ) { __typename customerAddress { __typename id firstName lastName address1 address2 city province country zip phone } customerUserErrors { __typename code field message } } }"#
      ))

    public var customerAccessToken: String
    public var address: MailingAddressInput

    public init(
      customerAccessToken: String,
      address: MailingAddressInput
    ) {
      self.customerAccessToken = customerAccessToken
      self.address = address
    }

    public var __variables: Variables? { [
      "customerAccessToken": customerAccessToken,
      "address": address
    ] }

    struct Data: ShopifyAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("customerAddressCreate", CustomerAddressCreate?.self, arguments: [
          "customerAccessToken": .variable("customerAccessToken"),
          "address": .variable("address")
        ]),
      ] }

      /// Creates a new [`MailingAddress`](https://shopify.dev/docs/api/storefront/current/objects/MailingAddress) for a [`Customer`](https://shopify.dev/docs/api/storefront/current/objects/Customer). Use the customer's [access token](https://shopify.dev/docs/api/storefront/current/mutations/customerAddressCreate#arguments-customerAccessToken) to identify them. Successful creation returns the new address. 
      ///
      /// Each customer can have multiple addresses.
      ///
      var customerAddressCreate: CustomerAddressCreate? { __data["customerAddressCreate"] }

      /// CustomerAddressCreate
      ///
      /// Parent Type: `CustomerAddressCreatePayload`
      struct CustomerAddressCreate: ShopifyAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.CustomerAddressCreatePayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("customerAddress", CustomerAddress?.self),
          .field("customerUserErrors", [CustomerUserError].self),
        ] }

        /// The new customer address object.
        var customerAddress: CustomerAddress? { __data["customerAddress"] }
        /// The list of errors that occurred from executing the mutation.
        var customerUserErrors: [CustomerUserError] { __data["customerUserErrors"] }

        /// CustomerAddressCreate.CustomerAddress
        ///
        /// Parent Type: `MailingAddress`
        struct CustomerAddress: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddress }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAPI.ID.self),
            .field("firstName", String?.self),
            .field("lastName", String?.self),
            .field("address1", String?.self),
            .field("address2", String?.self),
            .field("city", String?.self),
            .field("province", String?.self),
            .field("country", String?.self),
            .field("zip", String?.self),
            .field("phone", String?.self),
          ] }

          /// A globally-unique ID.
          var id: ShopifyAPI.ID { __data["id"] }
          /// The first name of the customer.
          var firstName: String? { __data["firstName"] }
          /// The last name of the customer.
          var lastName: String? { __data["lastName"] }
          /// The first line of the address. Typically the street address or PO Box number.
          var address1: String? { __data["address1"] }
          /// The second line of the address. Typically the number of the apartment, suite, or unit.
          ///
          var address2: String? { __data["address2"] }
          /// The name of the city, district, village, or town.
          var city: String? { __data["city"] }
          /// The region of the address, such as the province, state, or district.
          var province: String? { __data["province"] }
          /// The name of the country.
          var country: String? { __data["country"] }
          /// The zip or postal code of the address.
          var zip: String? { __data["zip"] }
          /// A unique phone number for the customer.
          ///
          /// Formatted using E.164 standard. For example, _+16135551111_.
          ///
          var phone: String? { __data["phone"] }
        }

        /// CustomerAddressCreate.CustomerUserError
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