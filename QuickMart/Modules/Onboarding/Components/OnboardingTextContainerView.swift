import SwiftUI

struct OnboardingTextContainerView: View {
    @Binding var currentPage: Int
    let items: [OnboardingItem]
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<items.count, id: \.self) { index in
                VStack(spacing: 16) {
                    Text(items[index].title)
                        .appTextStyle(.heading2, color: .primary)
                        .multilineTextAlignment(.center)
                    
                    Text(items[index].description)
                        .appTextStyle(.body, color: .grayText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .lineSpacing(4)
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 140)
    }
}
