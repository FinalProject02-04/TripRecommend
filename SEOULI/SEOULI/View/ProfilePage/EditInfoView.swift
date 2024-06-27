//
//  EditInfoView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

/*
 Author : 김수민
 
 Date : 2024.06.27 Thursday
 Description : 1차 UI frame 작업
 */

import SwiftUI

struct EditInfoView: View {
    
    @State var email = ""
    @State var password = ""
    @State var passwordCheck = ""
    @State var name = ""
    @State var nickname = ""
    
    
    var body: some View {
            ZStack{
                // Background Color
                Color("Background Color")
                    .edgesIgnoringSafeArea(.all)
    
                VStack(alignment: .leading, spacing: 40){
                    Spacer()
                    // Password
                    VStack {
                        Text("비밀번호")
                            .font(.system(size: 18))
                            .foregroundColor(Color("Text Color"))
                            .bold()
                            .padding(.trailing,260)
                        
                        TextField("비밀번호", text: $password)
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
                            .padding([.horizontal], 30)
                            // 폰트 사이즈
                            .font(.system(size: 16))
                            .padding(.bottom, 20)
                    }

                    // Password Check
                    VStack {
                        Text("비밀번호 확인")
                            .font(.system(size: 18))
                            .foregroundColor(Color("Text Color"))
                            .bold()
                            .padding(.trailing, 230)
                        
                        TextField("비밀번호 확인", text: $passwordCheck)
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
                            .padding([.horizontal], 30)
                            // 폰트 사이즈
                            .font(.system(size: 16))
                            .padding(.bottom, 20)
                    }

                    // Nickname
                    VStack {
                        Text("닉네임")
                            .font(.system(size: 18))
                            .foregroundColor(Color("Text Color"))
                            .bold()
                            .padding(.trailing, 280)
                        
                        TextField("닉네임", text: $nickname)
                            .keyboardType(.default)
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
                            .padding([.horizontal], 30)
                            // 폰트 사이즈
                            .font(.system(size: 16))
                    }
                    .padding(.bottom, 20)

                    HStack {
                        Spacer()
                        Button(action: {
                            
                            print("Button tapped!")
                        }) {
                            Text("변경하기")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(Color.theme)
                                .cornerRadius(25)
                        }
                    .padding(.top, 30)
                        Spacer()
                    }
                    
                    
                    Spacer(minLength: 40)
 
                } // VStack
                .toolbar(content: {
                    ToolbarItem(placement: .principal){
                        Text("내 정보")
                            .bold()
                            .foregroundColor(Color("Text Color"))
                            .font(.title)
                    }
                })
            } // ZStack
    } // body
} // view

#Preview {
    EditInfoView()
}
