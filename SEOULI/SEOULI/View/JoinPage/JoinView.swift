/*
 JoinView.swift
 
 Author : 이 휘
 Date : 2024.07.05 Fri
 Description : 1차 UI frame 작업
 */
import SwiftUI
import Firebase

struct JoinView: View {
    @Binding var path: NavigationPath
    
    // MARK: 사용자 입력 및 상태 관련 변수들
    @State private var email = ""
    @State private var password = ""
    @State private var passwordcheck = ""
    @State private var name = ""
    @State private var nickname = ""
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var isEditing: Bool = true // 이메일 및 이름 텍스트 필드를 읽기 전용으로 설정할 변수
    
    // MARK: 유효성 검사 메시지 관련 변수들
    @State private var emailErrorMessage = ""
    @State private var passwordErrorMessage = ""
    @State private var passwordCheckMessage = ""
    
    // MARK: Firebase와의 통신 상태 관리 변수들
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // MARK: Firebase 인증 관련 변수들
    @State private var verificationID: String?
    @State private var isVerificationSent = false
    @State private var isVerificationSuccessful = false
    
    // MARK: 입력 유효성 검사를 위한 변수들
    @State private var isPhoneNumberValid = false
    @State private var isVerificationCodeValid = false
    @FocusState private var isFocused: Bool
    @State var result: Bool = false
    
    // 정규식 유효성 검사를 위한 객체
    private let regexValidator = RegularExpression()
    
    
    var body: some View {
        
            ZStack {
                
                // 배경색 설정
                Color(red: 0.9, green: 0.9843, blue: 1.0)
                    .edgesIgnoringSafeArea(.all)
                
                
                ScrollView{
                    
                    Spacer()
                
                    VStack(alignment: .leading) {

                        Spacer()
                        
                        // MARK: 이메일 입력
                        Text("이메일")
                            .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                            .bold()
                            .padding(.leading, 35)
                            .padding(.top, 30)
                        
                        TextField("이메일을 입력하세요.", text: $email)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .frame(height: 40)
                            .padding([.horizontal], 20)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                            .padding([.horizontal], 30)
                            .font(.system(size: 16))
                            .disabled(!isEditing) // 읽기 전용 설정
                            .onChange(of: email) {
                                email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                            .onAppear {
                                // UserDefaults에서 userEmail 값 가져오기
                                if let userEmail = UserDefaults.standard.string(forKey: "userEmail"), userEmail != "" {
                                    email = userEmail
                                    // userEmail 값이 있으면 읽기 전용으로 설정
                                    isEditing = false
                                }
                            }
                        
                        if regexValidator.isValidEmail(email) == false{
                            Text("이메일을 다시 입력하시오.")
                                .font(.system(size: 12))
                                .bold()
                                .foregroundColor(.red)
                                .padding(.leading, 35)
                        }
                        
                        
                        // MARK: 비밀번호 입력
                        Text("비밀번호")
                            .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                            .bold()
                            .padding(.leading, 35)
                        
                        SecureField("비밀번호를 입력하세요.", text: $password)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
                            .frame(height: 40)
                            .padding([.horizontal], 20)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                            .padding([.horizontal], 30)
                            .font(.system(size: 16))
                            .onChange(of: password) {
                                password = password.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                        
                        if regexValidator.isValidPassword(password) == false {
                            Text("알파벳과 숫자 포함 최소 8자 이상이어야 합니다.")
                                .font(.system(size: 12))
                                .bold()
                                .foregroundColor(.red)
                                .padding(.leading, 35)
                        }
                        
                        // MARK: 비밀번호 확인 입력
                        Text("비밀번호 확인")
                            .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                            .bold()
                            .padding(.leading, 35)
                        
                        SecureField("비밀번호를 다시 입력하세요.", text: $passwordcheck)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
                            .frame(height: 40)
                            .padding([.horizontal], 20)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                            .padding([.horizontal], 30)
                            .font(.system(size: 16))
                            .onChange(of: passwordcheck) {
                                passwordcheck = passwordcheck.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                        
                        if !password.isEmpty && !passwordcheck.isEmpty{
                            if password == passwordcheck {
                                Text("비밀번호가 일치합니다.")
                                    .font(.system(size: 12))
                                    .bold()
                                    .foregroundColor(.blue)
                                    .padding(.leading, 35)
                            } else{
                                Text("비밀번호가 일치하지 않습니다.")
                                    .font(.system(size: 12))
                                    .bold()
                                    .foregroundColor(.red)
                                    .padding(.leading, 35)
                            }
                        } else if password.isEmpty && !passwordcheck.isEmpty{
                            Text("비밀번호를 입력해주세요.")
                                .font(.system(size: 12))
                                .bold()
                                .foregroundColor(.red)
                                .padding(.leading, 35)
                        }
                        

                        
                        // MARK: 이름 입력
                        Text("이름")
                            .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                            .bold()
                            .padding(.leading, 35)
                        
                        TextField("이름을 입력하세요.", text: $name)
                            .frame(height: 40)
                            .padding([.horizontal], 20)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                            .padding([.horizontal], 30)
                            .font(.system(size: 16))
                            .disabled(!isEditing) // 읽기 전용 설정
                            .onChange(of: name) {
                                name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                            .onAppear {
                                // UserDefaults에서 userName 값 가져오기
                                if let userName = UserDefaults.standard.string(forKey: "userName"), userName != "" {
                                    name = userName
                                    isEditing = false // userName 값이 있으면 읽기 전용으로 설정
                                }
                            }
                        
                        
                        // MARK: 닉네임 입력
                        Text("닉네임")
                            .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                            .bold()
                            .padding(.leading, 35)
                        
                        TextField("닉네임을 입력하세요.", text: $nickname)
                            .frame(height: 40)
                            .padding([.horizontal], 20)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                            .padding([.horizontal], 30)
                            .font(.system(size: 16))
                            .onChange(of: nickname) {
                                nickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                        
                        // MARK: 휴대폰 인증 입력
                        Text("휴대폰 인증")
                            .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                            .bold()
                            .padding(.leading, 35)
                        
                        HStack {
                            TextField("휴대폰 번호를 입력하세요.", text: $phoneNumber)
                                .keyboardType(.phonePad)
                                .frame(height: 40)
                                .padding([.horizontal], 20)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                                .padding(.leading, 30)
                                .font(.system(size: 16))
                                .onChange(of: phoneNumber) {
                                    phoneNumber = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
                                    handlePhoneNumberChange(phoneNumber)
                                }
                            // MARK: 전송 버튼
                            VStack{
                                
                                Button(action: {
                                    
                                    // 로딩 시작
                                    isLoading = true
                                    
                                    // 전화번호 유효성 검사
                                    if !isPhoneNumberValid {
                                        alertMessage = "유효한 전화번호를 입력해주세요. 예: 01012345678"
                                        showAlert = true
                                    } else {
                                        sendVerificationCode()
                                    }
                                    // 로딩 종료
                                    isLoading = false
                                }) {
                                    Text("전송")
                                        .padding(10)
                                        .bold()
                                        .font(.system(size: 16))
                                        .frame(width: 70)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.trailing, 30)
                                        
                                }
                            } // VStack
                            .disabled(!isPhoneNumberValid || isVerificationSent || isVerificationSuccessful)
                        } // HStack
                        .padding(.bottom, 5)
                        
                        // MARK: 인증번호 입력
                        HStack {
                            TextField("인증번호를 입력하세요.", text: $verificationCode)
                                .keyboardType(.numberPad)
                                .frame(height: 40)
                                .padding([.horizontal], 20)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                                .padding(.leading, 30)
                                .font(.system(size: 16))
                                .onChange(of: verificationCode) {
                                    verificationCode = verificationCode.trimmingCharacters(in: .whitespacesAndNewlines)
                                    handleVerificationCodeChange(verificationCode)
                                }
                            // MARK: 확인 버튼
                            VStack{
                                
                                Button(action: {
                                    
                                    // 로딩 시작
                                    isLoading = true
                                    
                                    // 인증번호 유효성 검사
                                    if !isVerificationCodeValid {
                                        alertMessage = "유효한 인증번호를 입력해주세요. 예: 123456"
                                        showAlert = true
                                    } else {
                                        verifyCode()
                                    }
                                    // 로딩 종료
                                    isLoading = false
                                    
                                }) {
                                    Text("확인")
                                        .padding(10)
                                        .bold()
                                        .font(.system(size: 16))
                                        .frame(width: 70)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.trailing, 30)
                                        
                                }
                            } // VStack
                            .disabled(!isVerificationCodeValid || !isVerificationSent || isVerificationSuccessful)
                            

                        } // HStack
                        .padding(.bottom, 50)
                        
                        // MARK: ㅂ이 버튼
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                

                                if email.isEmpty || password.isEmpty || passwordcheck.isEmpty || name.isEmpty || nickname.isEmpty {
                                    // 경고 메시지 설정
                                    alertMessage = "입력란을 확인해주세요."
                                    showAlert = true
                                // 비밀번호 일치 여부 확인
                                } else if password != passwordcheck {
                                    alertMessage = "비밀번호가 일치하지 않습니다."
                                    showAlert = true
                                } 
//                                else if !isVerificationSuccessful {
//                                    alertMessage = "인증이 완료되지 않았습니다."
//                                    showAlert = true
//                                } 
                                else {
                                    // 로딩 시작
                                    isLoading = true
                                    Task {
                                        do {
                                            // 사용자 등록 진행
                                            let userInsert = UserInfo(result: $result)
                                            // 이메일 중복 확인
                                            if let isPhone = try await userInsert.checkJoin(phone: phoneNumber) {
                                                if isPhone {
                                                    alertMessage = "이미 가입된 회원입니다."
                                                    showAlert = true
                                                } else {

                                                    _ = try await userInsert.insertUser(email: email, password: password, name: name, nickname: nickname, phoneNumber: phoneNumber)
                                                    alertMessage = "가입 완료되었습니다."
                                                    showAlert = true
                                                    path.removeLast()
                                                }
                                            } else {
                                                // 이메일 확인 중 오류 발생
                                                alertMessage = "전화번호 확인 중 오류가 발생했습니다."
                                                showAlert = true
                                            }
                                        } catch {
                                            // 에러 처리
                                            alertMessage = "전화번호 확인 중 오류가 발생했습니다."
                                            showAlert = true
                                            print("Error checking email: \(error)")
                                        }
                                    }
                                }
                                
                                // 로딩 종료
                                isLoading = false
                            }) {
                                Text("가입하기")
                                    .bold()
                                    .padding()
                                    .font(.system(size: 16))
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.horizontal, 30)
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom, 30)
                    } // VStack
                    .onDisappear {
                        // 뷰가 사라질 때 호출되는 코드
                        UserDefaults.standard.set("", forKey: "userEmail")
                        UserDefaults.standard.set("", forKey: "userName")
                        isEditing = true
        //                self.email = ""
        //                self.name = ""
                    }
                    .padding([.leading, .trailing], 15)
                    .toolbar(content: {
                        ToolbarItem(placement: .principal) {
                            Text("회원가입")
                                .bold()
                                .font(.system(size: 24))
                        }
                    }) // toolbar
                    
                    // MARK: 로딩 창
                    if isLoading {
                        LoadingView()
                    } // isLoading
                } // ScrollView
 
            } // ZStack
            .alert(isPresented: $showAlert) {
                Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            } // alert
        
    }
    
    // MARK: 휴대폰 번호 유효성 검사 함수
    private func handlePhoneNumberChange(_ phoneNumber: String) {
        isPhoneNumberValid = validatePhoneNumber(phoneNumber)
    }
    
    // MARK: 전화번호 정규식
    private func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        // 전화번호가 "010"으로 시작하고, 총 11자리 숫자로 구성된 경우를 확인하기 위한 정규 표현식
        let phoneRegex = "^010[0-9]{8}$"
      
        // NSPredicate를 사용하여 정규 표현식과 전화번호를 비교합니다.
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneNumber)
    }
    
    // MARK: 인증 코드 유효성 검사
    private func handleVerificationCodeChange(_ verificationCode: String) {
        isVerificationCodeValid = validateVerificationCode(verificationCode)
    }
    
    // MARK: 인증번호 정규식
    private func validateVerificationCode(_ verificationCode: String) -> Bool {
        let codeRegex = "^[0-9]{6}$" // 인증번호가 6자리일 경우
        return NSPredicate(format: "SELF MATCHES %@", codeRegex).evaluate(with: verificationCode)
    }
    
    // MARK: 인증 코드 전송
    private func sendVerificationCode() {
        isLoading = true
        // 국제 전화번호 형식으로 변환
        let formattedPhoneNumber = "+82" + phoneNumber.dropFirst()
        PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { verificationID, error in
            isLoading = false
            if let error = error {
                alertMessage = "인증 코드 전송 실패: \(error.localizedDescription)"
                showAlert = true
                return
            }
            self.verificationID = verificationID
            alertMessage = "인증 코드가 전송되었습니다."
            showAlert = true
            isVerificationSent = true
        }
    }
    
    // MARK: 인증 코드 확인
    private func verifyCode() {
        guard let verificationID = verificationID else {
            alertMessage = "인증 ID를 찾을 수 없습니다."
            showAlert = true
            return
        }
        
        isLoading = true
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            isLoading = false
            if let error = error {
                alertMessage = "인증 실패: \(error.localizedDescription)"
                showAlert = true
                return
            }
            alertMessage = "인증이 완료되었습니다."
            showAlert = true
            isVerificationSuccessful = true
        }
    }
} // JoinView
//    }
//}


struct JoinView_Previews: PreviewProvider {
    static var previews: some View {
        JoinView(path: LoginView(isLogin: .constant(false)).$path)
    }
}
