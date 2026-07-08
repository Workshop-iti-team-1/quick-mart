//
//  SearchablePickerView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//



import SwiftUI

struct SearchablePickerView: View {
    let title: String
    let items: [String]
    let selectedItem: String
    let onSelect: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    private var filteredItems: [String] {
        searchText.isEmpty
            ? items
            : items.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List(filteredItems, id: \.self) { item in
                Button {
                    onSelect(item)
                    dismiss()
                } label: {
                    HStack {
                        Text(item).appTextStyle(.body, color: .appBlack)
                        Spacer()
                        if item == selectedItem {
                            Image(systemName: "checkmark").foregroundColor(.cyanPrimary)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Search \(title)")
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
