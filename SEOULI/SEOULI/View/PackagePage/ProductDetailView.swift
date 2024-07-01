//
//  ProductDetailView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI
import TossPayments

private enum Constants {
    static let clientKey: String = "test_ck_yL0qZ4G1VO7KnObAM5xoVoWb2MQY"
    
    static func createPaymentInfo(for product: ProductModel) -> PaymentInfo {
        return DefaultPaymentInfo(
            amount: Double(product.price),  // 제품 가격을 센트 단위로 사용할 수 있도록 가정
            orderId: UUID().uuidString,  // 랜덤 UUID를 사용하여 주문 ID 생성
            orderName: "\(product.name)",  // 제품 이름을 포함한 주문명
            customerName: "SEOULI"  // 필요한 경우 고객명 설정
        )
    }
}

struct ProductDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var product: ProductModel
    @State var issuccess : Bool = false
    
    // 토스에 필요한 변수들
    @State private var showingTossPayments: Bool = false
    @State private var showingResultAlert: Bool = false
    @State private var resultInfo: (title: String, message: String)?
    
    @State private var 입력한결제정보: PaymentInfo
    
    init(product: ProductModel) {
            self.product = product
            self._입력한결제정보 = State(initialValue: Constants.createPaymentInfo(for: product))
        }
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: "http://192.168.50.83:8000/package/image?img_name=\(product.image)"), content: { Image in
                Image
                    .resizable()
                    .ignoresSafeArea()
            }) {
                Image("seoul")
            }
            
            Text(product.name)
                .foregroundColor(.black)
                .bold()
                .font(.title)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.white.opacity(0.7))
                .offset(y: -310)
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: 700)
                    .foregroundColor(.white)
                
                ScrollView {
                    AsyncImage(url: URL(string: "http://192.168.50.83:8000/package/image?img_name=\(product.image)"), content: { Image in
                        Image
                            .resizable()
                            .frame(width: 300, height: 200)
                            .padding(30)
                    }) {
                        Image("seoul")
                    }
                        
                    Text(product.name)
                        .bold()
                        .font(.title)
                    
                    HStack {
                        Text(" • 날짜 ")
                        Text(product.startdate)
                        Text(" ~ ")
                        Text(product.enddate)
                    }
                    .padding(8)
                    
                    VStack {
                        Text("상품 POINT")
                            .bold()
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                        
                        Text("숙소 : \(product.stay)")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        Text("이동수단 : \(product.trans)")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        Text("관광 : \(product.tourlist)")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    }
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    .padding(20)
                    
                    HStack {
                        Spacer()
                        Text("\(product.price)")
                            .bold()
                            .font(.system(size: 30))
                            .padding(.trailing, 30)
                    }
                    .padding(10)
                    
                    Button(action: {
                        showingTossPayments.toggle()
                    }, label: {
                        Text("결제하기")
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    })
                    .alert("결과", isPresented: $showingResultAlert, actions: {
                        Button(role: .cancel, action: {
                            dismiss()
                            dismiss()
                        }){
                            Text("네, 알겠습니다.")
                        }
                    },message: {
                        if issuccess {
                            Text("결제가 성공하였습니다.")
                        } else {
                            Text("결제가 실패하였습니다.")
                        }
                    })
                    .padding(30)
                    .popover(isPresented: $showingTossPayments, content: {
                        TossPaymentsView(
                            clientKey: Constants.clientKey,
                            paymentMethod: .카드,
                            paymentInfo: 입력한결제정보,
                            isPresented: $showingTossPayments
                        )
                        .onSuccess { (paymentKey: String, orderId: String, amount: Int64) in
                            let title = "TossPayments 요청에 성공하였습니다."
                            let message = """
                                onSuccess
                                paymentKey: \(paymentKey)
                                orderId: \(orderId)
                                amount: \(amount)
                                """
                            resultInfo = (title, message)
                            issuccess = true
                            showingResultAlert = true
                        }
                        .onFail { (errorCode: String, errorMessage: String, orderId: String) in
                            let title = "TossPayments 요청에 실패하였습니다."
                            let message = """
                                onFail
                                errorCode: \(errorCode)
                                errorMessage: \(errorMessage)
                                orderId: \(orderId)
                                """
                            resultInfo = (title, message)
                            issuccess = false
                            showingResultAlert = true
                        }
                    })
                    
                    Text("")
                        .frame(height: 100)
                }
                .frame(height: 650)
            }
            .offset(y: 100)
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: ProductModel(id: 1, name: "나이트투어", price: 300000, startdate: "2024-06-28", enddate: "2024-06-30", trans: "고속버스", tourlist: "서울역,김포공항", stay: "신라호텔", image: "w10.jpg"))
    }
}
