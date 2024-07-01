//
//  ChangePwView.swift
//  SEOULI
//
//  Created by 김소리 on 6/27/24.
//

import SwiftUI

struct ChangePwView: View {
    
    @State var password = ""
    @State var passwordCheck = ""
    @State var passwordAlert = false
    @State private var shouldNavigate = false
    @Binding var path: NavigationPath
    
    var body: some View {
        // MARK: ZStack
        ZStack(content: {
            
            // MARK: 배경색
            Color(red: 0.9, green: 0.9843, blue: 1.0)
                // 가장자리까지 확장되도록 설정
                .ignoresSafeArea()
            
            VStack(alignment: .leading, content: {
                // MARK: 비밀번호
                Text("비밀번호")
                    // 원하는 색상으로 변경
                    .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                    .bold()
                    .padding(.leading,35)
                SecureField("비밀번호 입력하세요.", text: $password)
                    .keyboardType(.emailAddress)
                    // 높이 조절
                    .frame(height: 40)
                    // 내각 여백
                    .padding([.horizontal], 20)
                    // 배경색
                    .background(Color.white)
                    // 둥근 테두리를 추가
                    .cornerRadius(8)
                    // 그림자 추가
                    .shadow(
                        color: Color.gray.opacity(0.4),
                        radius: 5, x: 0, y: 2
                    )
                    // 테두리 둥근 정도, 색상
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    // 외각 여백
                    .padding([.horizontal], 30)
                    // 폰트 사이즈
                    .font(.system(size: 16))
                
                Text("비밀번호는 대문자와 특수문자를 포함해야 합니다.")
                    .foregroundStyle(.red)
                    .bold()
                    .font(.system(size: 12))
                    .padding(.leading, 30)
                
                
                // MARK: 비밀번호 확인
                Text("비밀번호 확인")
                    // 원하는 색상으로 변경
                    .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                    .bold()
                    .padding(.leading,35)
                SecureField("비밀번호 입력하세요.", text: $passwordCheck)
                    .keyboardType(.emailAddress)
                    // 높이 조절
                    .frame(height: 40)
                    // 내각 여백
                    .padding([.horizontal], 20)
                    // 배경색
                    .background(Color.white)
                    // 둥근 테두리를 추가
                    .cornerRadius(8)
                    // 그림자 추가
                    .shadow(
                        color: Color.gray.opacity(0.4),
                        radius: 5, x: 0, y: 2
                    )
                    // 테두리 둥근 정도, 색상
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    // 외각 여백
                    .padding([.horizontal], 30)
                    // 폰트 사이즈
                    .font(.system(size: 16))
                
                Text("비밀번호가 일치합니다.")
                    .foregroundStyle(.blue)
                    .bold()
                    .font(.system(size: 12))
                    .padding(.leading, 30)
                
                
                Spacer()
                
                HStack(content: {
                    
                    Spacer()
                    
                    // MARK: 비밀번호 변경 버튼
                    VStack {
                            Button(action: {
                                passwordAlert = true
                            }) {
                                Text("비밀번호 변경")
                                    .padding()
                                    .frame(width: 200)
                                    .bold()
                                    .background(Color.theme) // Customize your theme color
                                    .foregroundColor(.white)
                                    .cornerRadius(10) // Customize your shape
                            }
                            .padding(.bottom, 50)
                            .alert("변경완료", isPresented: $passwordAlert, actions: {
                                Button("OK") {
                                    path.removeLast()
                                    path.removeLast()
                                }
                            }, message: {
                                Text("비밀번호가 성공적으로 변경되었습니다.")
                            })
                            .navigationDestination(isPresented: $shouldNavigate) {
                                LoginView()
                        }
                    }
                            
                    Spacer()
                })
                
            }) // VStack
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("비밀번호 변경")
                        .bold()
                        .font(.system(size: 24))
                }
            })
//            .navigationDestination(isPresented: $shouldNavigate) {
//                LoginView()
//            }
        })
    }
}

#Preview {
    ChangePwView(path:LoginView().$path)
}
