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
    
    @State var product: [PurchaseModel] = []
    @State private var userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "none"
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Background Color")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) { // scrollbar 숨기기
                    VStack(spacing: 20) {
                        ForEach(product,id: \.pur_id) { product in
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
        .onAppear{
            print(userEmail)
            selectList()
        }
        .edgesIgnoringSafeArea(.all)
    } // body
    
    func selectList(){
        let api = PurchaseVM()
        Task{
            product = try await api.selectPurchase(user_id: userEmail)
        }
        
    }
}

struct CardView: View {
    var product: PurchaseModel
    
    var body: some View {
        HStack {
            
            AsyncImage(url: URL(string: "http://192.168.50.83:8000/package/image?img_name=\(product.package_info.image)"), content: { Image in
                Image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .cornerRadius(8)
                    .shadow(radius: 4)
            }) {
                Image("seoul")
            }
            
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(product.purchase_date)
                    .font(.system(size: 10))
                
                Text(product.package_info.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text("\(product.package_info.price)")
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
    MyResoView(product: [PurchaseModel(package_info: ProductModel(id: 1, name: "한라산 등반", price: 200000, startdate: "2024-08-08", enddate: "2024-08-09", trans: "고속버스", tourlist: "제주공항, 한라산", stay: "제주호텔", image: "w10.jpg"), purchase_date: "2024-07-03", pur_id: 3)])
}
