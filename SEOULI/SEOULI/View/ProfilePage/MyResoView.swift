//
//  MyResoView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.

/*
 Author : 김수민
 
 Date : 2024.06.27 Thursday
 Description : 1차 UI frame 작업
 
 */

import SwiftUI


struct MyResoView: View {
    
    var product: [ProductModel] = [
        ProductModel(id: 1, name: "나이트투어", price: 300000, startdate: "2024-06-28", enddate: "2024-06-30", trans: "고속버스", tourlist: "서울역,김포공항", stay: "신라호텔")
    ]
    
    var body: some View {

            ZStack(alignment: .top) {
                Color("Background Color")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {                    
                    ScrollView(showsIndicators: false) { // scrollbar 숨기기
                        VStack(spacing: 20) {
                            ForEach(product,id: \.id) { product in
                                CardView(product: product)
                            }
                        }
                        .padding()
                    } // ScrollView
                    .background(Color("Background Color"))
                    .padding(.top, 60)
                } // VStack
                .toolbar(content: {
                    ToolbarItem(placement: .principal){
                        Text("결제내역")
                            .bold()
                            .foregroundColor(Color("Text Color"))
                            .font(.title)
                    }
                })
            } // ZStack
        .edgesIgnoringSafeArea(.all)
    } // body
}

struct CardView: View {
    var product: ProductModel
    
    var body: some View {
        HStack {
            Image("seoul")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90) 
                .cornerRadius(8)
                .shadow(radius: 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text("\(product.price)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
    }
}
#Preview {
    MyResoView()
}
