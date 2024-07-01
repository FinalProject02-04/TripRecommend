//
//  ProductListView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI

struct ProductListView: View {
    @State var product : [ProductModel] = []
    @State var productImage : Image?
    @State var isLoading : Bool = true
    
    var body: some View {
        NavigationView {
            if isLoading{
                ProgressView()
            }else{
                ScrollView(showsIndicators: false) { // scrollbar 숨기기
                    VStack(spacing: 20) {
                        ForEach(product,id: \.id) { product in
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
        .onAppear(perform: {
            loadProduct()
        })
    }
    
    func loadProduct(){
        let api = ProductVM()
        Task{
            product = try await api.selectProduct()
            isLoading = false
        }
    }
}


struct FullImageRow: View {
    var product: ProductModel
    var body: some View {
        ZStack{
            if let imageData = Data(base64Encoded: product.image), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(10)
                
            }else{
                Image("seoul")
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

#Preview {
    ProductListView()
}
