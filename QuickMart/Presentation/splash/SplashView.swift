import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.backGround
                .ignoresSafeArea()
            
            Image.logoPrimary
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    SplashView()
}
