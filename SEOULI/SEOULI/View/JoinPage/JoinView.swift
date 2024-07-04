/*
 Author : 이 휘
 Date : 2024.07.03 Thursday
 Description : 1차 UI frame 작업
 JoinView.swift
 */

import SwiftUI
import Firebase

struct JoinView: View {
    
    // MARK: 변수
    @State var verificationCode = ""
    @State var joinAlert = false
    @State var isAlert = false
    @Binding var path: NavigationPath
    
    @State private var email = ""
    @State private var password = ""
    @State private var passwordcheck = ""
    @State private var name = ""
    @State private var nickname = ""
    @State private var phoneNumber = ""
    
    // Firebase Query Request가 완료 됬는지 확인하는 상태 변수
    @State private var result: Bool = true

    // 정규식
    @State private var isValidEmail = true // 이메일
    @State private var isValidPw = true // 비밀번호
    @State private var isCheckPw = true // 일치 여부
    
    // 키보드를 내릴때 필요한 상태 변수
    @FocusState private var isFocused: Bool
    // 완료 버튼 후 뒤로가기
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPasswordValid = true // 비밀번호 유효성 상태 변수
    
    @State private var verificationID: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isVerificationSent = false
    @State private var isVerificationSuccessful = false
    @State private var isLoading = false // 로딩 상태를 관리하는 변수
    
    // RegularExpression 구조체 인스턴스 생성
    private let regexValidator = RegularExpression()
        
    var body: some View {
//        NavigationView(content: {
            ZStack(content: {
                
                // MARK: 배경색
                Color(red: 0.9, green: 0.9843, blue: 1.0)
                    // 가장자리까지 확장되도록 설정
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment:.leading, content: {
                    
                    Spacer()
                    
                    // MARK: 이메일
                    Text("이메일")
                        // 원하는 색상으로 변경
                        .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                        .bold()
                        .padding(.leading,35)

                    TextField("이메일을 입력하세요.", text: $email)
                        .focused($isFocused)
                        // 자동 대문자 비활성화
                        .textInputAutocapitalization(.never)
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

                    
                    // MARK: 비밀번호 확인
                    Text("비밀번호 확인")
                        // 원하는 색상으로 변경
                        .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                        .bold()
                        .padding(.leading,35)
                    SecureField("비밀번호 입력하세요.", text: $passwordcheck)
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
                    
//                    Text("비밀번호가 일치합니다.")
//                        .foregroundStyle(.blue)
//                        .bold()
//                        .font(.system(size: 12))
//                        .padding(.leading, 30)
                    
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
                        TextField("- 제외 번호를 입력하세요.", text: $phoneNumber)
                            .keyboardType(.phonePad)
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
                            sendVerificationCode()
                            
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
                                .disabled(isVerificationSent)
                        }
                    }
                    .padding(.bottom, 5)
                    HStack {
                        TextField("인증번호를 입력하세요.", text: $verificationCode)
                            .keyboardType(.numberPad)
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
                            verifyCode()
                        }
                    label: {
                            Text("확인")
                                .padding(10)
                                .bold()
                                .font(.system(size: 16))
                                .frame(width: 70)
                                .background(.theme)
                                .foregroundStyle(.white)
                                .clipShape(.buttonBorder)
                                .padding(.trailing, 30)
                                .disabled(!isVerificationSent)
                        }
 
                    }
                    .padding(.bottom, 50)
                    
                    
                    // MARK: 가입버튼
                    HStack {
                        
                        Spacer()
                        
                        Button{
                            Task{
                                alertMessage = "You have passed the verification!"
                                showAlert = true
                                
                                let userInsert = UserInfo(result: $result)
                                let result = try await userInsert.insertUser(email: email, password: password, name: name, nickname: nickname)
                                print(result)
                                joinAlert = true
                            }

                            
                        }label: {
                            Text("가입하기")
                                .frame(width: 200)
                                .padding()
                                .bold()
                                .background(.theme)
                                .foregroundStyle(.white)
                                .clipShape(.buttonBorder)
                        }
                        .alert("가입완료", isPresented: $joinAlert, actions: {
                            Button("OK", role: .none, action: {
                                path.removeLast()
                                print("성공")
                            })
                        },
                        message: {
                            Text("가입이 완료되었습니다.")
                        })
                        
                        Spacer()
                    }
                    
                    Spacer()

                }) // VStack
                .padding([.leading, .trailing], 15)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        Text("회원가입")
                            .bold()
                            .font(.system(size: 24))
                    }
                }) // toolbar
                
                // 전체 화면을 덮는 로딩 프로그레스바
                if isLoading {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                } // isLoading
                
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            } // alert
    } // body
    
    // 전화번호 인증 코드 전송
    private func sendVerificationCode() {
        isLoading = true // 전송 중에 로딩 상태 활성화
        
        let formattedPhoneNumber = formatPhoneNumber(phoneNumber)
        
        guard !formattedPhoneNumber.isEmpty else {
            isLoading = false // 오류 발생 시 로딩 상태 비활성화
            alertMessage = "Invalid phone number format. Please enter a number starting with 010."
            showAlert = true
            return
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { verificationID, error in
            isLoading = false // 작업 완료 시 로딩 상태 비활성화
            
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
                return
            }
            
            if let verificationID = verificationID {
                self.verificationID = verificationID
                self.isVerificationSent = true
                alertMessage = "Verification code sent successfully."
                showAlert = true
            }
        }
    }
    
    // 인증 코드 확인
    private func verifyCode() {
        isLoading = true // 확인 중에 로딩 상태 활성화
        
        guard let verificationID = verificationID else {
            isLoading = false // 오류 발생 시 로딩 상태 비활성화
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            isLoading = false // 작업 완료 시 로딩 상태 비활성화
            
            if let error = error {
                alertMessage = "Verification failed: \(error.localizedDescription)"
                showAlert = true
                return
            }
            
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }
                
                if let idToken = idToken {
                    alertMessage = "Verification successful! ID Token: \(idToken)"
                    isVerificationSuccessful = true
                    showAlert = true
                }
            }
        }
    }
    
    // 전화번호 형식 변환
    private func formatPhoneNumber(_ number: String) -> String {
        var formattedNumber = number.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch formattedNumber.prefix(3) {
        case "010", "011", "016", "017", "018", "019":
            formattedNumber = "+82" + formattedNumber.dropFirst()
        default:
            formattedNumber = ""
        }
        
        return formattedNumber
    }
}

#Preview {
    JoinView(path:LoginView(isLogin: .constant(false)).$path)
}
