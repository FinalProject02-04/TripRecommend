//
//  LoginView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//
import SwiftUI

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    @FocusState var isTextFieldFocused: Bool
    @State var path = NavigationPath()
    // Alert 표시 여부를 관리하는 상태 변수
    @State private var showAlert = false
    // Alert창의 메세지를 저장할 상태 변수
    @State private var errorMessage: String = ""
    
    @Binding var isLogin: Bool
    
    // Firebase Query Request가 완료 됬는지 확인하는 상태 변수
    @State var result: Bool = false
    
    var body: some View {
        
        NavigationStack(path: $path){
            
            ZStack {
                
                VStack {
                    
                    Spacer(minLength: 300)
                    
                    // MARK: 배경색 설정
                    LinearGradient(gradient: Gradient(colors: [Color.white, Color.theme]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                    
                } // VStack(배경색)
                
                VStack(content: {
                    
                    Spacer()
                    
                    // MARK: LOGO
                    Image("logo")
                        .resizable()
                        .frame(width: 230, height: 50)
                    
                    // 간격 조절
                    Spacer().frame(height: 50)
                    
                    // MARK: 아이디
                    TextField("이메일을 입력하세요.", text: $email)
                        .frame(height: 54)
                        .padding([.horizontal], 20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                        .padding([.horizontal], 30)
                        .font(.system(size: 20))
                 
                    
                    // 간격 조절
                    Spacer().frame(height: 20)
                    
                    // MARK: 비밀번호
                    SecureField("비밀번호를 입력하세요.", text: $password)
                        .focused($isTextFieldFocused)
                        .frame(height: 54)
                        .padding([.horizontal], 20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                        .padding([.horizontal], 30)
                        .font(.system(size: 20))
                    
                    // 간격 조절
                    Spacer().frame(height: 20)
                    
                    // MARK: ID, Password 찾기
                    HStack {
                        
                        Button {
                            path.append("FindInfoView_Id")
                        } label: {
                            Text("아이디 찾기")
                                .foregroundStyle(.black)
                                .padding(.leading, 10)
                        }
                        Divider()
                            .frame(height: 14)
                            .overlay(Rectangle().frame(width: 1))
                        Button {
                            path.append("FindInfoView_Pw")
                        } label: {
                            Text("비밀번호 찾기")
                                .foregroundStyle(.black)
                        }
                    } // HStack
                    .padding(.top, 30)
                    
                    // 간격 조절
                    Spacer().frame(height: 30)
                    
                    // MARK: 로그인 버튼
                    Button(action: {
                        
                        // 로그인 로직
                        Task{
                            let userQuery = UserInfo(result: $result)
                            let userInfo = try await userQuery.fetchUserInfo(userid: email, userpw: password)

                            if result {
                                print("로그인성공")
                                
                                print(userInfo.documentId)
                                // firebase request 성공
                                if userInfo.documentId.isEmpty{
                                    // id, pw 잘못 입력
                                    self.showAlert = true
                                    self.errorMessage = "Please Check your ID or password"
                                }else{
                                    // id, pw 제대로 입력
                                    self.isLogin = true
                                    UserDefaults.standard.set(email, forKey: "userEmail")
                                }
                            }else{
                                // firebase request 실패
                                self.showAlert = true
                                self.errorMessage = "Failed to connect to the server"
                            }
                            
                        } // Task
                        
                    }, label: {
                        Text("로그인")
                            .padding()
                            .frame(width: 200)
                            .background(.theme)
                            .foregroundStyle(.white)
                            .clipShape(.buttonBorder)
                    })
                    
                    // MARK: 개인 회원 로그인
                    HStack(content: {
                        VStack{
                            Divider()
                                .overlay(Rectangle().frame(height: 1))
                                .padding(.leading, 30)
                        }
                        Text("개인회원 SNS 로그인")
                            .frame(width: 160)
                            .bold()
                        
                        VStack{
                            Divider()
                                .overlay(Rectangle().frame(height: 1))
                                .padding(.trailing, 30)
                        }

                    }) // HStack
                    .padding([.top, .bottom], 30)
                    
                    // MARK: 소셜 로그인 버튼
                    Button(action: {
//                        Authentication.googleOauth()
                    }, label: {
                        Image("google_icon")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .scaledToFit()
                    })
                    
                    // MARK: 회원 가입
                    HStack {
                        Text("계정이 없으세요?")
                        
                        Button(action: {
                            path.append("JoinView")
                        }, label: {
                            Text("가입하기")
                                .bold()
                                .underline()
                                .foregroundColor(.black)
                        })
                        
                    } // HStack
                    .padding(.top, 30)
                    
                    Spacer()
                    
                }) // VStack
            } // ZStack
            .navigationDestination(for: String.self) { value in
                switch value {
                case "FindInfoView_Id":
                    FindInfoView(selectedFindInfo: 0, path: $path)
                case "FindInfoView_Pw":
                    FindInfoView(selectedFindInfo: 1, path: $path)
                case "JoinView":
                    JoinView(path: $path)
                case "ChangePwView":
                    ChangePwView(path: $path)
                case "ContentView":
                    ContentView(isLogin: $isLogin)
                default:
                    Text("Unknown View")
                }
            }
        } // NavigationStack
    } //body
    
    // 이메일 저장 함수
    private func saveEmail() {
        UserDefaults.standard.set($email, forKey: "userEmail")
        print("이메일 저장됨: \($email)")
    }
} // LoginView

#Preview {
    LoginView(isLogin: .constant(false))
}
