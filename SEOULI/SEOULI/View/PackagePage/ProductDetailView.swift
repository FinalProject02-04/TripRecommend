//
//  ProductDetailView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI

struct ProductDetailView: View {
    var product : ProductModel
    
    var body: some View {
        ZStack(content: {
            
            Image(product.image)
                .resizable()
                .ignoresSafeArea()
            
            Text(product.name)
                .foregroundColor(.black)
                .bold()
                .font(.title)
                .frame(maxWidth: .infinity,minHeight: 50)
                .background(Color.white.opacity(0.7))
                .offset(y:-310)
            
            ZStack(content: {
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: 700)
                    .foregroundColor(.white)
                
                ScrollView {
                    
                    Image(product.image)
                        .resizable()
                        .frame(width: 300,height: 200)
                        .padding(30)
                    
                    Text (product.name)
                        .bold()
                        .font(.title)
                    
                    HStack(content: {
                        Text(" • 날짜 ")
                        Text("24.06.20 ~ 24.06.22")
                    })
                    .padding(8)
                    
                    VStack(content: {
                        Text("상품 POINT")
                            .bold()
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)

                        Text("숙소 : 롯데 호텔")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        Text("이동수단 : 버스")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        Text("관광 : 롯데월드, 롯데타워, 석촌호수")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    })
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    .padding(20)

                    
                    HStack(content: {
                        Spacer()
                        Text(product.price)
                            .bold()
                            .font(.system(size: 30))
                            .padding(.trailing,30)
                    })
                    .padding(10)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("결제하기")
                            .frame(width: 200, height: 50)
                            .background(.theme)
                            .foregroundColor(.white)
                            .clipShape(.capsule)
                    })
                    .padding(30)
                    
                    Text("")
                        .frame(height: 100)
                }
                .frame(height: 650)
            })
            .offset(y:100)
            
        })
        
    }
}

#Preview {
    ProductDetailView(product: ProductModel(name: "데이트투어 & 나이트투어", image: "product1", price: "300000원"))
}
