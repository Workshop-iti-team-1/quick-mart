import SwiftUI

struct OnboardingTopCardView: View {
    @Binding var currentPage: Int
    @Binding var hasSeenOnboarding: Bool
    let items: [OnboardingItem]
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 32)
                .fill(Color(UIColor.secondarySystemBackground))
            
            VStack(spacing: 0) {
                topNavigationBar
                
                TabView(selection: $currentPage) {
                    ForEach(0..<items.count, id: \.self) { index in
                        items[index].image
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 40)
                            .padding(.bottom, 30)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .frame(height: geometry.size.height * 0.55)
        .padding(.horizontal, 16)
    }
    
    private var topNavigationBar: some View {
        HStack {
            if currentPage == 0 {
                HStack(spacing: 2) {
                    Image("quickmart")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)
                }
                .transition(.opacity)
            } else {
                Button(action: {
                    withAnimation {
                        currentPage -= 1
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                .transition(.opacity)
            }
            
            Spacer()
            
            if currentPage < items.count - 1 {
                Button(action: {
                    withAnimation {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text("Skip for now")
                        .appTextStyle(.button, color: .cyanPrimary)
                }
                .transition(.opacity)
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
}
