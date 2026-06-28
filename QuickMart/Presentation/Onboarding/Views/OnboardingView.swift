import SwiftUI

struct OnboardingItem {
    let title: String
    let description: String
    let image: Image
}

struct OnboardingView: View {
    @State private var currentPage = 0
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(UserDefaultsKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool = false

    
    let items = [
        OnboardingItem(
            title: "Explore a wide range of\nproducts",
            description: "Explore a wide range of products at your\nfingertips. QuickMart offers an extensive\ncollection to suit your needs.",
            image: .onboarding1
        ),
        OnboardingItem(
            title: "Unlock exclusive offers\nand discounts",
            description: "Get access to limited-time deals and special\npromotions available only to our valued\ncustomers.",
            image: .onboarding2
        ),
        OnboardingItem(
            title: "Safe and secure\npayments",
            description: "QuickMart employs industry-leading encryption\nand trusted payment gateways to safeguard your\nfinancial information.",
            image: .onboarding3
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color.backGround.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Card containing Top Bar and Image
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(Color(UIColor.secondarySystemBackground))
                        
                        VStack(spacing: 0) {
                            // Top Bar
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
                                
                                if currentPage < 2 {
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
                            
                            // Image inside the card
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
                    
                    Spacer()
                    
                    // Title and Description
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
                    
                    Spacer()
                    
                    // Bottom section (Buttons + Indicators)
                    VStack(spacing: 32) {
                        if currentPage < 2 {
                            Button(action: {
                                withAnimation {
                                    currentPage += 1
                                }
                            }) {
                                Text("Next")
                                    .appTextStyle(.button, color: colorScheme == .dark ? .black : .white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.cyanPrimary)
                                    )
                            }
                            .padding(.horizontal, 20)
                            .transition(.opacity)
                        } else {
                            HStack(spacing: 16) {
                                Button(action: {
                                    withAnimation {
                                        hasSeenOnboarding = true
                                    }
                                }) {
                                    Text("Login")
                                        .appTextStyle(.button, color: .cyanPrimary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        hasSeenOnboarding = true
                                    }
                                }) {
                                    HStack {
                                        Text("Get Started")
                                        Image(systemName: "arrow.right")
                                    }
                                    .appTextStyle(.button, color: colorScheme == .dark ? .black : .white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.cyanPrimary)
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .transition(.opacity)
                        }
                        
                        // Page Indicator
                        HStack(spacing: 8) {
                            ForEach(0..<items.count, id: \.self) { index in
                                Capsule()
                                    .fill(currentPage == index ? Color.cyanPrimary : Color.gray.opacity(0.5))
                                    .frame(width: currentPage == index ? 24 : 8, height: 8)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .animation(.easeInOut, value: currentPage)
                }
            }
        }
    }
}

#Preview {
    Group {
        OnboardingView()
            .preferredColorScheme(.light)
        OnboardingView()
            .preferredColorScheme(.dark)
    }
}
