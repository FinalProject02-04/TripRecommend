//
//  FindInfoView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI

// MARK: FindInfoView
struct FindInfoView: View {
    
    @State var selectedFindInfo: Int
    @State var idPhoneNumber = ""
    @State var idCheckNumber = ""
    @State var pwPhoneNumber = ""
    @State var pwCheckNumber = ""
    @State var verificationCode = ""
    @State var idSendAlert = false
    @State var idCheckAlert = false
    @State var pwSendAlert = false
    @State var pwCheckAlert = false
    @State var resultIdAlert = false
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    
    var body: some View {
        
            ZStack(content: {
                
                // MARK: 배경색
                Color(red: 0.9, green: 0.9843, blue: 1.0)
                    // 가장자리까지 확장되도록 설정
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Picker(selection: $selectedFindInfo, label: Text("Map Type")){
                        Text("아이디 찾기").tag(0)
                        Text("비밀번호 찾기").tag(1)
                    } // Picker
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if selectedFindInfo == 0{
                        
                        HStack {
                            // MARK: 휴대폰 번호 입력
                            TextField("- 제외하고 번호를 입력하세요.", text: $idPhoneNumber)
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
                                idSendAlert = true
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
                            .alert("완료", isPresented: $idSendAlert, actions: {
                                Button("OK", role: .none, action: {
                                    print("성공")
                                })
                            },
                            message: {
                                Text("전송되었습니다.")
                            })
                        } // HStack
                        .padding(.bottom, 5)
                        
                        // MARK: 인증번호 입력
                        HStack {
                            TextField("인증번호를 입력하세요.", text: $idCheckNumber)
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
                                idCheckAlert = true
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
                            .alert("완료", isPresented: $idCheckAlert, actions: {
                                Button("OK", role: .none, action: {
                                    print("성공")
                                })
                            },
                            message: {
                                Text("인증되었습니다.")
                            })
                        } // HStack
                        .padding(.bottom, 5)
                        
                        Spacer()
                        
                        // MARK: 아이디 찾기 버튼
                        Button{
                            resultIdAlert = true
                        } label: {
                            Text("아이디 찾기")
                                .padding()
                                .frame(width: 200)
                                .bold()
                                .background(.theme)
                                .foregroundStyle(.white)
                                .clipShape(.buttonBorder)
                        }
                        .alert("아이디 확인", isPresented: $resultIdAlert, actions: {
                            Button("OK", role: .none, action: {
                                path.removeLast()
                                print("성공")
                            })
                        },
                        message: {
                            Text("hwicoding0625@gmail.com")
                        })
                        
                    } else{
                        // MARK: 휴대폰 번호 입력
                        HStack {
                            TextField("- 제외하고 번호를 입력하세요.", text: $pwPhoneNumber)
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
                                pwSendAlert = true
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
                            .alert("전송완료", isPresented: $pwSendAlert, actions: {
                                Button("OK", role: .none, action: {
                                    print("성공")
                                })
                            },
                            message: {
                                Text("전송되었습니다.")
                            })
                        } // HStack
                        .padding(.bottom, 5)
                        
                        // MARK: 인증번호 입력
                        HStack {
                            TextField("인증번호를 입력하세요.", text: $pwCheckNumber)
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
                                pwCheckAlert = true
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
                            .alert("인증완료", isPresented: $pwCheckAlert, actions: {
                                Button("OK", role: .none, action: {
                                    print("성공")
                                })
                            },
                            message: {
                                Text("인증되었습니다.")
                            })
                        } // HStack
                        .padding(.bottom, 5)
                        
                        Spacer()
                        
                        // MARK: 비밀번호 찾기 버튼
                        
                        Button(action: {
                            path.append("ChangePwView")
                        }, label: {
                            Text("비밀번호 찾기")
                                .padding()
                                .frame(width: 200)
                                .bold()
                                .background(.theme)
                                .foregroundStyle(.white)
                                .clipShape(.buttonBorder)
                        })
                        
                    }
                    Spacer()
                } // VStack
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        Text(selectedFindInfo == 0 ? "아이디 찾기" : "비밀번호 찾기")
                            .bold()
                            .font(.system(size: 24))
                    }
                })
            }) // ZStack

    }
} // FindInfoView

#Preview {
    FindInfoView(selectedFindInfo: 0, path:LoginView().$path)
}
