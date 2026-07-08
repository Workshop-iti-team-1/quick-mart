//
//  MockProfileView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//



import SwiftUI

struct MockProfileView: View {
    @Environment(AppRouter.self) private var router
    @ObservedObject private var session = SessionManager.shared

    var body: some View {
        VStack(spacing: 16) {
            Button { router.push(.shippingAddresses) } label: {
                HStack {
                    Image(systemName: "shippingbox").foregroundColor(.appBlack)
                    Text("Shipping Addresses").appTextStyle(.body, color: .appBlack)
                    Spacer()
                    if session.currentState != .loggedIn {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.grey150)
                    }
                    Image(systemName: "chevron.right").foregroundColor(.grey150)
                }
                .padding()
                .background(Color.grey50)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.top, 24)
    }
}
