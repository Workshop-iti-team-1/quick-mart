// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol ShopifyAPI_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ShopifyAPI.SchemaMetadata {}

protocol ShopifyAPI_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ShopifyAPI.SchemaMetadata {}

protocol ShopifyAPI_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ShopifyAPI.SchemaMetadata {}

protocol ShopifyAPI_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ShopifyAPI.SchemaMetadata {}

extension ShopifyAPI {
  typealias ID = String

  typealias SelectionSet = ShopifyAPI_SelectionSet

  typealias InlineFragment = ShopifyAPI_InlineFragment

  typealias MutableSelectionSet = ShopifyAPI_MutableSelectionSet

  typealias MutableInlineFragment = ShopifyAPI_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> Object? {
      switch typename {
      case "QueryRoot": return ShopifyAPI.Objects.QueryRoot
      case "CollectionConnection": return ShopifyAPI.Objects.CollectionConnection
      case "CollectionEdge": return ShopifyAPI.Objects.CollectionEdge
      case "Collection": return ShopifyAPI.Objects.Collection
      case "Article": return ShopifyAPI.Objects.Article
      case "AppliedGiftCard": return ShopifyAPI.Objects.AppliedGiftCard
      case "Blog": return ShopifyAPI.Objects.Blog
      case "Metaobject": return ShopifyAPI.Objects.Metaobject
      case "Page": return ShopifyAPI.Objects.Page
      case "Product": return ShopifyAPI.Objects.Product
      case "SearchQuerySuggestion": return ShopifyAPI.Objects.SearchQuerySuggestion
      case "Cart": return ShopifyAPI.Objects.Cart
      case "CartLine": return ShopifyAPI.Objects.CartLine
      case "ComponentizableCartLine": return ShopifyAPI.Objects.ComponentizableCartLine
      case "Comment": return ShopifyAPI.Objects.Comment
      case "Company": return ShopifyAPI.Objects.Company
      case "CompanyContact": return ShopifyAPI.Objects.CompanyContact
      case "CompanyLocation": return ShopifyAPI.Objects.CompanyLocation
      case "ExternalVideo": return ShopifyAPI.Objects.ExternalVideo
      case "MediaImage": return ShopifyAPI.Objects.MediaImage
      case "Model3d": return ShopifyAPI.Objects.Model3d
      case "Video": return ShopifyAPI.Objects.Video
      case "GenericFile": return ShopifyAPI.Objects.GenericFile
      case "Location": return ShopifyAPI.Objects.Location
      case "MailingAddress": return ShopifyAPI.Objects.MailingAddress
      case "Market": return ShopifyAPI.Objects.Market
      case "MediaPresentation": return ShopifyAPI.Objects.MediaPresentation
      case "Menu": return ShopifyAPI.Objects.Menu
      case "MenuItem": return ShopifyAPI.Objects.MenuItem
      case "Metafield": return ShopifyAPI.Objects.Metafield
      case "Order": return ShopifyAPI.Objects.Order
      case "ProductOption": return ShopifyAPI.Objects.ProductOption
      case "ProductOptionValue": return ShopifyAPI.Objects.ProductOptionValue
      case "ProductVariant": return ShopifyAPI.Objects.ProductVariant
      case "Shop": return ShopifyAPI.Objects.Shop
      case "ShopPayInstallmentsFinancingPlan": return ShopifyAPI.Objects.ShopPayInstallmentsFinancingPlan
      case "ShopPayInstallmentsFinancingPlanTerm": return ShopifyAPI.Objects.ShopPayInstallmentsFinancingPlanTerm
      case "ShopPayInstallmentsProductVariantPricing": return ShopifyAPI.Objects.ShopPayInstallmentsProductVariantPricing
      case "ShopPolicy": return ShopifyAPI.Objects.ShopPolicy
      case "TaxonomyCategory": return ShopifyAPI.Objects.TaxonomyCategory
      case "UrlRedirect": return ShopifyAPI.Objects.UrlRedirect
      case "Customer": return ShopifyAPI.Objects.Customer
      case "SellingPlan": return ShopifyAPI.Objects.SellingPlan
      case "Image": return ShopifyAPI.Objects.Image
      case "ProductConnection": return ShopifyAPI.Objects.ProductConnection
      case "ProductEdge": return ShopifyAPI.Objects.ProductEdge
      case "PageInfo": return ShopifyAPI.Objects.PageInfo
      case "ProductPriceRange": return ShopifyAPI.Objects.ProductPriceRange
      case "MoneyV2": return ShopifyAPI.Objects.MoneyV2
      case "ImageConnection": return ShopifyAPI.Objects.ImageConnection
      case "ImageEdge": return ShopifyAPI.Objects.ImageEdge
      case "ProductVariantConnection": return ShopifyAPI.Objects.ProductVariantConnection
      case "ProductVariantEdge": return ShopifyAPI.Objects.ProductVariantEdge
      case "SelectedOption": return ShopifyAPI.Objects.SelectedOption
      case "SearchResultItemConnection": return ShopifyAPI.Objects.SearchResultItemConnection
      case "SearchResultItemEdge": return ShopifyAPI.Objects.SearchResultItemEdge
      case "StringConnection": return ShopifyAPI.Objects.StringConnection
      case "StringEdge": return ShopifyAPI.Objects.StringEdge
      case "OrderConnection": return ShopifyAPI.Objects.OrderConnection
      case "OrderEdge": return ShopifyAPI.Objects.OrderEdge
      case "DiscountApplicationConnection": return ShopifyAPI.Objects.DiscountApplicationConnection
      case "DiscountApplicationEdge": return ShopifyAPI.Objects.DiscountApplicationEdge
      case "AutomaticDiscountApplication": return ShopifyAPI.Objects.AutomaticDiscountApplication
      case "DiscountCodeApplication": return ShopifyAPI.Objects.DiscountCodeApplication
      case "ManualDiscountApplication": return ShopifyAPI.Objects.ManualDiscountApplication
      case "ScriptDiscountApplication": return ShopifyAPI.Objects.ScriptDiscountApplication
      case "PricingPercentageValue": return ShopifyAPI.Objects.PricingPercentageValue
      case "OrderLineItemConnection": return ShopifyAPI.Objects.OrderLineItemConnection
      case "OrderLineItemEdge": return ShopifyAPI.Objects.OrderLineItemEdge
      case "OrderLineItem": return ShopifyAPI.Objects.OrderLineItem
      case "Mutation": return ShopifyAPI.Objects.Mutation
      case "CustomerDefaultAddressUpdatePayload": return ShopifyAPI.Objects.CustomerDefaultAddressUpdatePayload
      case "CustomerUserError": return ShopifyAPI.Objects.CustomerUserError
      case "CartUserError": return ShopifyAPI.Objects.CartUserError
      case "MetafieldDeleteUserError": return ShopifyAPI.Objects.MetafieldDeleteUserError
      case "MetafieldsSetUserError": return ShopifyAPI.Objects.MetafieldsSetUserError
      case "UserError": return ShopifyAPI.Objects.UserError
      case "UserErrorsShopPayPaymentRequestSessionUserErrors": return ShopifyAPI.Objects.UserErrorsShopPayPaymentRequestSessionUserErrors
      case "CustomerAddressDeletePayload": return ShopifyAPI.Objects.CustomerAddressDeletePayload
      case "CustomerAddressUpdatePayload": return ShopifyAPI.Objects.CustomerAddressUpdatePayload
      case "CustomerAddressCreatePayload": return ShopifyAPI.Objects.CustomerAddressCreatePayload
      case "MailingAddressConnection": return ShopifyAPI.Objects.MailingAddressConnection
      case "MailingAddressEdge": return ShopifyAPI.Objects.MailingAddressEdge
      case "CartCreatePayload": return ShopifyAPI.Objects.CartCreatePayload
      case "CartCost": return ShopifyAPI.Objects.CartCost
      case "BaseCartLineConnection": return ShopifyAPI.Objects.BaseCartLineConnection
      case "BaseCartLineEdge": return ShopifyAPI.Objects.BaseCartLineEdge
      case "CartLineCost": return ShopifyAPI.Objects.CartLineCost
      case "CartDiscountCode": return ShopifyAPI.Objects.CartDiscountCode
      case "CartLinesAddPayload": return ShopifyAPI.Objects.CartLinesAddPayload
      case "CartLinesUpdatePayload": return ShopifyAPI.Objects.CartLinesUpdatePayload
      case "CartLinesRemovePayload": return ShopifyAPI.Objects.CartLinesRemovePayload
      case "CartDiscountCodesUpdatePayload": return ShopifyAPI.Objects.CartDiscountCodesUpdatePayload
      case "CustomerCreatePayload": return ShopifyAPI.Objects.CustomerCreatePayload
      case "CustomerAccessTokenCreatePayload": return ShopifyAPI.Objects.CustomerAccessTokenCreatePayload
      case "CustomerAccessToken": return ShopifyAPI.Objects.CustomerAccessToken
      case "CustomerRecoverPayload": return ShopifyAPI.Objects.CustomerRecoverPayload
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}