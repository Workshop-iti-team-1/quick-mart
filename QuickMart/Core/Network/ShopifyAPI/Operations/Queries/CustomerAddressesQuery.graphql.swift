// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension ShopifyAPI {
  class CustomerAddressesQuery: GraphQLQuery {
    static let operationName: String = "CustomerAddresses"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query CustomerAddresses($customerAccessToken: String!) { customer(customerAccessToken: $customerAccessToken) { __typename id defaultAddress { __typename id } addresses(first: 20) { __typename edges { __typename node { __typename id firstName lastName address1 address2 city province country zip phone } } } } }"#
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
          .field("defaultAddress", DefaultAddress?.self),
          .field("addresses", Addresses.self, arguments: ["first": 20]),
        ] }

        /// A unique ID for the customer.
        var id: ShopifyAPI.ID { __data["id"] }
        /// The customer’s default address.
        var defaultAddress: DefaultAddress? { __data["defaultAddress"] }
        /// A list of addresses for the customer.
        var addresses: Addresses { __data["addresses"] }

        /// Customer.DefaultAddress
        ///
        /// Parent Type: `MailingAddress`
        struct DefaultAddress: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddress }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShopifyAPI.ID.self),
          ] }

          /// A globally-unique ID.
          var id: ShopifyAPI.ID { __data["id"] }
        }

        /// Customer.Addresses
        ///
        /// Parent Type: `MailingAddressConnection`
        struct Addresses: ShopifyAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddressConnection }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("edges", [Edge].self),
          ] }

          /// A list of edges.
          var edges: [Edge] { __data["edges"] }

          /// Customer.Addresses.Edge
          ///
          /// Parent Type: `MailingAddressEdge`
          struct Edge: ShopifyAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { ShopifyAPI.Objects.MailingAddressEdge }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("node", Node.self),
            ] }

            /// The item at the end of MailingAddressEdge.
            var node: Node { __data["node"] }

            /// Customer.Addresses.Edge.Node
            ///
            /// Parent Type: `MailingAddress`
            struct Node: ShopifyAPI.SelectionSet {
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
          }
        }
      }
    }
  }

}