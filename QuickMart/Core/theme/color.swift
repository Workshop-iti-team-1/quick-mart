//
//  color.swift
//  QuickMart
//
//  Created by siam on 27/06/2026.
//



import SwiftUI

extension Color {
    static let backGround = Color("backGround")
    static let cyanPrimary = Color(red: 0.13, green: 0.81, blue: 0.70) // Approx brand color
    static let grayText = Color.gray
    // Brand
    static let cyan = Color(hex: "21D4B4")
    static let cyan50 = Color(hex: "F4FDFA")
    static let appBlack = Color(hex: "1C1B1B")
    static let appWhite = Color(hex: "FFFFFF")

    // Grey
    static let grey50 = Color(hex: "F4F5FD")
    static let grey100 = Color(hex: "C0C0C0")
    static let grey150 = Color(hex: "6F7384")

    // General
    static let appRed = Color(hex: "EE4D4D")
    static let appBlue = Color(hex: "1F88DA")
    static let appPurple = Color(hex: "4F1FDA")
    static let appYellow = Color(hex: "EBEF14")
    static let appOrange = Color(hex: "F0821D")
    static let appMerigold = Color(hex: "FFCB45")
    static let appBrown = Color(hex: "5A1A05")
    static let appPink = Color(hex: "CE1DEB")

    static let primaryButtonBackground = Color.appBlack

    // Hex init
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
