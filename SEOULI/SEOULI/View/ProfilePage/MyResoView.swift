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
        ProductModel(name: "데이트 투어 & 나이트 투어", image: "product1", price: "300000원"),
        ProductModel(name: "야간 경복궁 투어", image: "product2", price: "150000원"),
        ProductModel(name: "동대문 쇼핑센터 투어", image: "product3", price: "55000원"),
        ProductModel(name: "데이트 투어 & 나이트 투어", image: "product1", price: "300000원"),
        ProductModel(name: "데이트 투어 & 나이트 투어", image: "product1", price: "300000원")
    ]
    
    var body: some View {

            ZStack(alignment: .top) {
                Color("Background Color")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {                    
                    ScrollView(showsIndicators: false) { // scrollbar 숨기기
                        VStack(spacing: 20) {
                            ForEach(product) { product in
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
            Image(product.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90) 
                .cornerRadius(8)
                .shadow(radius: 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(product.price)
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
