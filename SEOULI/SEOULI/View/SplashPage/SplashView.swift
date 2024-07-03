import SwiftUI

struct SplashView: View {
    @State private var showMainView = false
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            if showMainView{
                // 여기서 유저 정보 있는지 없는지 판단하면 됨
                LoginView()
            } else {
                SplashContentView(imageScale: $imageScale, imageOpacity: $imageOpacity)
                    .onAppear {
                        // 페이드인 애니메이션
                        withAnimation(.easeInOut(duration: 1.0)) {
                            imageOpacity = 1.0
                        }
                        // 1초 후 페이드아웃 애니메이션 시작
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 2.0)) {
                                imageOpacity = 0.0
                            }
                            // 2초 후 메인 뷰 표시
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showMainView = true
                                }
                            }
                        }
                    }
            }
        }
        .onAppear{
            // 여기에 유저 정보 있는지 없는지 판단하는 함수 삽입
        }
    }
}

struct SplashContentView: View {
    @Binding var imageScale: CGFloat
    @Binding var imageOpacity: Double
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.theme]),
                           startPoint: .top,
                           endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            VStack {
                Image("faceLogo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding()
                Image("logo")
                    .resizable()
                    .frame(width: 200, height: 50)
                    .padding()
            }
            .scaleEffect(imageScale)
            .opacity(imageOpacity)
        }
    }
}

#Preview {
    SplashView()
}
