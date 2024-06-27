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
                amount: Double(product.price)!,  // 제품 가격을 센트 단위로 사용할 수 있도록 가정
                orderId: UUID().uuidString,  // 랜덤 UUID를 사용하여 주문 ID 생성
                orderName: "\(product.name)",  // 제품 이름을 포함한 주문명
                customerName: "SEOULI"  // 필요한 경우 고객명 설정
            )
        }
        
    // 예시에서 사용될 초기 테스트 결제 정보
    static let 테스트결제정보: PaymentInfo = createPaymentInfo(for: ProductModel(name: "데이트투어&나이트투어", image: "", price: "300000"))
}

struct ProductDetailView: View {
    
    var product : ProductModel
    
    @State private var showingTossPayments: Bool = false
    @State private var showingResultAlert: Bool = false
    @State private var resultInfo: (title: String, message: String)?

    @State private var 입력한결제정보: PaymentInfo = Constants.테스트결제정보
    
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
                    
                    Button(action: {
                        showingTossPayments.toggle()
                    }, label: {
                        Text("결제하기")
                            .frame(width: 200, height: 50)
                            .background(.theme)
                            .foregroundColor(.white)
                            .clipShape(.capsule)
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
                            print("onSuccess paymentKey \(paymentKey)")
                            print("onSuccess orderId \(orderId)")
                            print("onSuccess amount \(amount)")
                            let title = "TossPayments 요청에 성공하였습니다."
                            let message = """
                                onSuccess
                                paymentKey: \(paymentKey)
                                orderId: \(orderId)
                                amount: \(amount)
                                """
                            resultInfo = (title, message)
                            showingResultAlert = true
                        }
                        .onFail { (errorCode: String, errorMessage: String, orderId: String) in
                            print("onFail errorCode \(errorCode)")
                            print("onFail errorMessage \(errorMessage)")
                            print("onFail orderId \(orderId)")
                            let title = "TossPayments 요청에 실패하였습니다."
                            let message = """
                            onFail
                            errorCode: \(errorCode)
                            errorMessage: \(errorMessage)
                            orderId: \(orderId)
                            """
                            resultInfo = (title, message)
                            showingResultAlert = true
                        }
                        .alert(isPresented: $showingResultAlert) {
                            Alert(
                                title: Text("\(resultInfo?.title ?? "")"),
                                message: Text("\(resultInfo?.message ?? "")"),
                                primaryButton: .default(Text("확인"), action: {
                                    resultInfo = nil
                                }),
                                secondaryButton: .destructive(Text("클립보드에 복사하기"), action: {
                                    UIPasteboard.general.string = resultInfo?.message
                                    resultInfo = nil
                                })
                            )
                        }
                    })
                    
                    Text("")
                        .frame(height: 100)
                }
                .frame(height: 650)
            })
            .offset(y:100)
            
        })
        
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: ProductModel(name: "데이트투어 & 나이트투어", image: "product1", price: "300000원"))
    }
}
