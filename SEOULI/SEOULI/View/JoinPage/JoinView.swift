//
//  JoinView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI

struct JoinView: View {
    
    // MARK: 변수
    @State var email = ""
    @State var password = ""
    @State var passwordCheck = ""
    @State var name = ""
    @State var nickname = ""
    @State var phoneNumber = ""
    @State var verificationCode = ""
    
    var body: some View {
        NavigationView(content: {
            ZStack(content: {
                // 배경색
                Color(red: 0.9, green: 0.9843, blue: 1.0)
                    // 가장자리까지 확장되도록 설정
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment:.leading, content: {
                    
                    CustomNavigationBar(titleName: "회원가입", backButton: true)
                    
                    Spacer()
                    
                    // MARK: 이메일
                    Text("이메일")
                        // 원하는 색상으로 변경
                        .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                        .bold()
                        .padding(.leading,35)

                    TextField("이메일을 입력하세요.", text: $email)
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
                    
                    // MARK: 이름
                    Text("이름")
                        // 원하는 색상으로 변경
                        .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                        .bold()
                        .padding(.leading,35)
                    TextField("이름을 입력하세요.", text: $name)
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
                    
                    // MARK: 닉네임
                    Text("닉네임")
                        // 원하는 색상으로 변경
                        .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                        .bold()
                        .padding(.leading,35)
                    TextField("닉네임을 입력하세요.", text: $nickname)
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
                    
                    // MARK: 휴대폰 인증
                    Text("휴대폰 인증")
                        // 원하는 색상으로 변경
                        .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                        .bold()
                        .padding(.leading,35)
                    HStack {
                        TextField("- 제외하고 번호를 입력하세요.", text: $phoneNumber)
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
                            .padding(.leading, 30)
                            // 폰트 사이즈
                        .font(.system(size: 16))
                        
                        Button{
                            
                        } label: {
                            Text("전송")
                                .padding(10)
                                .bold()
                                .font(.system(size: 16))
                                .frame(width: 70)
                                .background(.theme)
                                .foregroundStyle(.white)
                                .clipShape(.buttonBorder)
                                .padding(.trailing, 30)
                        }
                    }
                    .padding(.bottom, 5)
                    HStack {
                        TextField("인증번호를 입력하세요.", text: $verificationCode)
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
                            .padding(.leading, 30)
                            // 폰트 사이즈
                        .font(.system(size: 16))
                        
                        Button{
                            
                        } label: {
                            Text("확인")
                                .padding(10)
                                .bold()
                                .font(.system(size: 16))
                                .frame(width: 70)
                                .background(.theme)
                                .foregroundStyle(.white)
                                .clipShape(.buttonBorder)
                                .padding(.trailing, 30)
                        }
 
                    }
                    .padding(.bottom, 50)
                    
                    HStack {
                        
                        Spacer()
                        
                        Button{
                            
                        }label: {
                            Text("가입하기")
                                .frame(width: 200)
                                .padding()
                                .bold()
                                .background(.theme)
                                .foregroundStyle(.white)
                                .clipShape(.buttonBorder)
                    }
                        
                        Spacer()
                    }
                    
                    Spacer()

                }) // VStack
                .padding([.leading, .trailing], 15)
                
                
            })
            
            
        })
        .navigationBarBackButtonHidden(true)
    }
}

struct CustomNavigationBar: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var titleName: String
    @State var backButton: Bool
    
    var body: some View {
        ZStack(content: {
            if backButton {
                HStack(content: {
                    Button(action: {
                        dismiss.callAsFunction()
                    }, label: {
                        HStack(content: {
                            Image(systemName: "arrowtriangle.backward.fill")
                                .foregroundStyle(Color(red: 0.259, green: 0.345, blue: 0.518))
                            
                            Text("뒤로 가기")
                                .foregroundStyle(Color(red: 0.259, green: 0.345, blue: 0.518))
                                .bold()
                        })
                        .frame(width: UIScreen.main.bounds.width / 4, alignment: .trailing)
                    })
                    
                    Text("")
                        .frame(width: (UIScreen.main.bounds.width / 4) * 3, alignment: .leading)
                })
            }
            
            Text(titleName)
                .font(.title)
                .bold()
                .foregroundStyle(Color(red: 0.259, green: 0.345, blue: 0.518))
                .frame(width: UIScreen.main.bounds.width)
        })
        .ignoresSafeArea()
        .frame(width: UIScreen.main.bounds.width, height: 50)

        
    } // body
}

#Preview {
    JoinView()
}
