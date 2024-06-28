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
 */

import SwiftUI

struct MainView: View {
    
    // test locations
    let pickedlocations: [SeoulList] = [
        SeoulList(name: "서울스카이", imageName: "seoul", description: "Very nice, very good.", address: "위례대로 6길 20", inquiries: "010-1111-1111"),
        SeoulList(name: "청계천", imageName: "seoul2", description: "verynice, very good.",address: "위례대로 6길 20",inquiries: "010-1111-1111"),
        SeoulList(name: "한옥마을", imageName: "seoul3", description: "very nice, very good.",address: "위례대로 6길 20",inquiries: "010-1111-1111"),
      
    ]
    
    // test packages
    let packages: [ProductModel] = [
        (ProductModel(name: "데이트 투어 & 나이트 투어", image: "product1", price: 300000)),(ProductModel(name: "야간 경복궁 투어", image: "product2", price: 150000)),(ProductModel(name: "동대문 쇼핑센터 투어", image: "product3", price: 55000)),(ProductModel(name: "데이트 투어 & 나이트 투어", image: "product1", price: 300000)),(ProductModel(name: "데이트 투어 & 나이트 투어", image: "product1", price: 300000))
    ]
    
    
    
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
                            
                            // our recommended locations (test)
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack() {
                                   ForEach(pickedlocations) { location in
                                       NavigationLink(destination: SeoulListDetailView(location: location)) {
                                           VStack {
                                               Image(location.imageName)
                                                   .resizable()
                                                   .frame(width: 140, height: 200)
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
                                                           .padding(.trailing, 10)
                                                           .font(.title2)
                                                   )
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
                            
                            // our recommended packages (test)
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack(){
                                    ForEach(packages) { packages in
                                        NavigationLink(destination: ProductDetailView(product: packages)){
                                            VStack{
                                                Image(packages.image)
                                                    .resizable()
                                                    .frame(width: 230 ,height: 140 )
                                                    .cornerRadius(20)
                                                    .overlay(
                                                        Rectangle()
                                                            .foregroundStyle(.black)
                                                            .cornerRadius(21)
                                                            .opacity(0.21)
                                                    )
                                                    .overlay(
                                                        Text(packages.name)
                                                            .bold()
                                                            .foregroundColor(.white)
                                                            .padding(.top,80)
                                                            .font(.system(size: 20))
                                                )
                                            } // VStack
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
  
                // HWIBOT VIEW
                ChatbotView()
    
            } // ZStack
        } // NavigationStack
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
    } // body
} // MainView

#Preview {
    MainView()
}
