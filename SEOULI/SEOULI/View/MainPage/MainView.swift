//
//  MainView.swift
//  SEOULI
//
//  Created by 김수민 on 6/25/24.

/*
 Author : 김수민
 
 Date : 2024.06.26 Wednesday
 Description : 1차 UI frame 작업
 
 Date : 2024.06.27 Thursday
 Description : 2차 UI frame 작업
 
 Date : 2024.06.28 Friday
 Description : HWIBOT view 추가
 
 Date : 2024.07.02 Tuesday
 Description : DB 연결 
 */

import SwiftUI

struct MainView: View {
        
    // radomly picked locations from SeoulList
    let pickedlocations: [SeoulList] = [
        
        SeoulList(name: "피규어뮤지엄W", address: "서울특별시 강남구 선릉로158길 3", description: "서울시 강남구 청담동에 위치한 피규어뮤지엄W는 피규어와 토이를 테마로 테마파크의 기능을 접목시킨 새로운 개념의 뮤지엄이다. 피규어뮤지엄W에서는 진귀한 피규어를 만나고, 감상하고, 체험하고, 즐길 수 있는 경험을 제공함으로써 어린이, 청소년, 성인 등 모든 이들에게 새로운 놀이문화와 건전한 취미생활을 제시하는 문화 관광 랜드마크를 건립하고자 한다. 총 6개의 테마로 이루어진 전시공간은 어린이뿐 아니라 온 가족이 즐길 수 있는 놀이공간, 카페가 있는 그랜드 홀, 직접 피규어를 구입할 수 있는 매니아 샵 등 다양한 컨텐츠를 만나고 즐길 수 있도록 마련되었다.", inquiries: "02-512-8865", imageName: "https://cdn.visitkorea.or.kr/img/call?cmd=VIEW&id=7917bc53-e00d-4962-9c51-3ebe5d01c94f"),
        
        SeoulList(name: "신사시장", address: "서울특별시 강남구 압구정로29길 72-1", description: "압구정역 1번 출구에서 압구정 현대아파트 방향으로 걸어가다 보면 만날 수 있는 시장으로 약 80여 개 점포가 있다. 1976년에 준공되었으나 이후로 재건축이나 리모델링을 하지 않아서 본래 모습을 거의 변함 없이 유지하고 있는 전형적인 재래시장의 모습이다. 시장 뒤쪽 출입구에 있는 40년 전통의 떡볶이집이 유명하다.",inquiries: "02-542-3516", imageName: "https://cdn.visitkorea.or.kr/img/call?cmd=VIEW&id=f6de2ea0-a1bb-4f99-a4b8-7ffcb05177af"),
        
        
        SeoulList(name: "쾨닉 서울", address: "서울특별시 강남구 압구정로 412", description: "쾨닉은 지난 20년 동안 독일에서 가장 흥미로운 현대 미술을 선도하는 갤러리로 자리 잡았다. 초창기부터 융복합적 또는 개념적 접근을 삼는 작가들에 초점을 두었으며, 그들은 현재 현대미술계에서 가장 중요한 작가들로 성장하였다. 갤러리는 현재 40명에 이르는 작가들을 대표하고 있으며, 소속 작가들은 쾨닉뿐만 아니라 국제적으로 저명한 여러 기관에서도 활발하게 활동하고 있다. 또한, 쾨닉은 서울에 갤러리 공간을 열기로 결정함에 따라 우수한 현대미술을 국제적으로 소개하는 것에 대한 강한 의지를 이어 나가고자 한다.",inquiries: "02-3442-6968",imageName: "https://cdn.visitkorea.or.kr/img/call?cmd=VIEW&id=745b8ba0-5786-40a7-84c2-738d6b14e961"),
      
    ]
    
    // Packages
    @State private var packages: [ProductModel] = []
    @State private var isLoading: Bool = true
    

    var body: some View {
        NavigationStack{
            ZStack{
                // Image (background)
                Image("seoul")
                    .resizable()
                    .frame(width: 400, height: 500)
                    .padding(.bottom, 508)
                
                
                Image("logo")
                    .resizable()
                    .frame(width: 200, height: 45)
                    .padding(.bottom, 640)
                    .padding(.trailing)
                
                // Rounded Rectangular View
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white)
                    .frame(width: 400, height: 730)
                    .padding(.top,200)
                    .shadow(radius: 10)
                    .overlay(
                        VStack {
                            Text("우리가 추천하는 여행지")
                                .font(.title)
                                .bold()
                                .foregroundColor(Color("Text Color"))
                                .padding(.trailing, 130)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        // our recommended locations
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack() {
                               ForEach(pickedlocations) { location in
                                   NavigationLink(destination: SeoulListDetailView(location: location)) {
                                       VStack {
                                           AsyncImage(url: URL(string: location.imageName)) { phase in
                                               switch phase {
                                               case .success(let image):
                                                   image
                                                       .resizable()
                                                       .frame(width: 150, height: 200)
                                                       .cornerRadius(20)
                                                       .overlay(
                                                        Rectangle()
                                                            .foregroundStyle(.black)
                                                            .cornerRadius(21)
                                                            .opacity(0.21)
                                                       )
                                                       .overlay(
                                                        Text(location.name)
                                                            .bold()
                                                            .foregroundColor(.white)
                                                            .padding(.top, 150)
                                                            .font(.title2)
                                                       )
                                               case .failure:
                                                   Image(systemName: "photo")
                                                       .resizable()
                                                       .scaledToFit()
                                                       .frame(width: 80, height: 80)
                                                       .cornerRadius(10)
                                               case .empty:
                                                   ProgressView()
                                                       .frame(width: 80, height: 80)
                                               @unknown default:
                                                   EmptyView()
                                               }
                                           }
                                       } // VStack
                                   }
                               }
                           }
                           .padding(.leading, 10)
                        }
                            .padding(.bottom)
                            Text("여행 패키지")
                                .font(.title)
                                .bold()
                                .foregroundColor(Color("Text Color"))
                                .padding(.trailing, 258)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            // our packages
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack(){
                                    ForEach(packages,id: \.id) { product in
                                        NavigationLink(destination: ProductDetailView(product: product)) {
                                            ImageRow(product: product)
                                        }
                                    }
                                }
                            }
                            .padding(.leading,10)
                            
                            // Button
                            NavigationLink(destination: SeoulListView()) {
                                Text("서울 목록 리스트")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(Color.theme)
                                    .cornerRadius(25)
                            }
                            .padding(.top,30)
                        } // VStack
                            .padding(.top, 85)
                    ) // overlay
                    .onAppear(perform: {
                        loadProduct()
                    })
                // HWIBOT VIEW
                ChatbotView()
    
            } // ZStack
        } // NavigationStack
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
        
    } // body
    
    func loadProduct(){
            let api = ProductVM()
            Task{
                packages = try await api.selectProduct()
                isLoading = false
            }
        }
    
    
    // calling images for the packages using API
    struct ImageRow: View {
        var product: ProductModel
        var body: some View {
            ZStack{
                AsyncImage(url: URL(string: "http://192.168.50.83:8000/package/image?img_name=\(product.image)"), content: { Image in
                    Image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 280,height: 160)
                        .cornerRadius(10)
                        .overlay(
                            Rectangle()
                                .foregroundStyle(.black)
                                .cornerRadius(10)
                                .opacity(0.2)
                        )
                }) {
                    Image("seoul")
                }
                    
                VStack(content: {
                    Text(product.name)
                        .bold()
                        .font(.system(.title))
                        .foregroundStyle(.white)
                    Text("\(product.price)원")
                        .bold()
                        .font(.system(.title2))
                        .foregroundStyle(.white)
                })
            }
        }
    }
} // MainView

#Preview {
    MainView()
}
