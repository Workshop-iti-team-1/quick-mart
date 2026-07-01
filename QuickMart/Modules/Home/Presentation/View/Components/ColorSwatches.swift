//
//  ColorSwatches.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//

import SwiftUI

struct ColorSwatches: View {
    let colorNames: [String]
    let totalCount: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(colorNames.prefix(3), id: \.self) { name in
                Circle()
                    .fill(Color(name))
                    .frame(width: 12, height: 12)
            }
            Text("All \(totalCount) Colors")
                .appTextStyle(.caption, color: .grayText)
        }
    }
}
