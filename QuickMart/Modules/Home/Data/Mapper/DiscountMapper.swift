//
//  DiscountMapper.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//


extension DiscountModel{
    func toBannerItem(index: Int) -> BannerItem {
        let gradients: [(String, String)] = [
            ("appBlue", "cyanPrimary"),
            ("appPurple", "appPink"),
            ("appMerigold", "appOrange")
        ]
        let gradient = gradients[index % gradients.count]

        return BannerItem(
            id: id,
            discount: title,      
            subtitle: summary,
            title: code,
            code: code,
            imageName: "tag.fill",
            isSystemImage: true,
            gradientStart: gradient.0,
            gradientEnd: gradient.1
        )
    }
}
