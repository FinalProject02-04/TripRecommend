//
//  ProductListView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI

struct ProductListView: View {
    var product : [ProductModel] = [(ProductModel(name: "데이트 투어 & 나이트 투어", image: "product1", price: 300000)),(ProductModel(name: "야간 경복궁 투어", image: "product2", price: 150000)),(ProductModel(name: "동대문 쇼핑센터 투어", image: "product3", price: 55000)),(ProductModel(name: "데이트 투어 & 나이트 투어", image: "product1", price: 300000)),(ProductModel(name: "데이트 투어 & 나이트 투어", image: "product1", price: 300000))]
    
    var body: some View {
            NavigationView {
                ScrollView(showsIndicators: false) { // scrollbar 숨기기
                    VStack(spacing: 20) {
                        ForEach(product) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                FullImageRow(product: product)
                            }
                        }
                    }
                    Text("")
                        .frame(height: 30)
                }
            }
        }
}

struct FullImageRow: View {
    var product: ProductModel
    var body: some View {
        ZStack{
            Image(product.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350,height: 200)
                .cornerRadius(10)
                .overlay(
                    Rectangle()
                        .foregroundStyle(.black)
                        .cornerRadius(10)
                        .opacity(0.2)
                )
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

#Preview {
    ProductListView()
}
