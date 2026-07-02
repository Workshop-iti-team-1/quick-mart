//
//  CollectionMapper.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//


import Foundation

extension ShopifyAPI.GetCollectionsQuery.Data.Collections.Edge.Node {

    func toDTO() -> CollectionModel{
        CollectionModel(
            id: id,
            title: title,
            handle: handle,
            description: description,
            imageURL: image?.url,
            imageAltText: image?.altText
        )
    }
}

extension CollectionModel {

    func toBrandEntity() -> BrandItem {
        BrandItem(
            id: id,
            name: title,
            imageName: imageURL ?? "bag.fill",
            isSystemImage: imageURL == nil
        )
    }

    func toCategoryEntity() -> CategoryItem {
        CategoryItem(
            id: id,
            name: title,
            imageName: assetImage(for: handle),
            isSystemImage: false
        )
    }

   

    private func assetImage(for handle: String) -> String {
        switch handle.lowercased() {
        case "women": return "women"
        case "men":   return "men"
        case "kid":   return "kid"
        case "sale":  return "sale"
        default:      return "women"
        }
    }
}
