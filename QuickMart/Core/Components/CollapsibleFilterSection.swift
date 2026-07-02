//
//  CollapsibleFilterSection.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import SwiftUI

struct CollapsibleFilterSection<Content: View>: View {

    let title: String
    @Binding var isExpanded: Bool
    let selectedCount: Int
    @ViewBuilder let content: () -> Content

    private enum Layout {
        static var headerVerticalPad: CGFloat  {16}
        static var dividerLeadingPad: CGFloat  {0}
    }

    var body: some View {
        VStack(spacing: 0) {
            headerButton
            if isExpanded {
                content()
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity
                        )
                    )
            }
            Divider()
        }
        .animation(.easeInOut(duration: 0.22), value: isExpanded)
    }

    private var headerButton: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack(spacing: 6) {
                Text(title)
                    .appTextStyle(.label, color: .appBlack)

                if selectedCount > 0 {
                    Text("(\(selectedCount))")
                        .appTextStyle(.caption, color: .cyanPrimary)
                }

                Spacer()

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.grey150)
            }
            .padding(.vertical, Layout.headerVerticalPad)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var isExpanded = true
    CollapsibleFilterSection(
        title: "Categories",
        isExpanded: $isExpanded,
        selectedCount: 2
    ) {
        Text("Content goes here")
            .padding(.vertical, 8)
    }
    .padding(.horizontal, 16)
}
