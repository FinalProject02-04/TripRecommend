import SwiftUI
import Firebase

struct JoinView: View {
    @Binding var path: NavigationPath
    
    // 사용자 입력 및 상태 관련 변수들
    @State private var email = ""
    @State private var password = ""
    @State private var passwordcheck = ""
    @State private var name = ""
    @State private var nickname = ""
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    
    // Firebase와의 통신 상태 관리 변수들
    @State private var isLoading = false // 로딩 중인지를 나타내는 상태 변수
    @State private var showAlert = false // 알림창을 띄울지 여부를 나타내는 상태 변수
    @State private var alertMessage = "" // 알림창에 표시할 메시지
    
    // Firebase 인증 관련 변수들
    @State private var verificationID: String?
    @State private var isVerificationSent = false // 인증 코드가 전송되었는지 여부를 나타내는 상태 변수
    @State private var isVerificationSuccessful = false // 인증이 성공적으로 완료되었는지 여부를 나타내는 상태 변수
    
    // 입력 유효성 검사를 위한 변수들
    @State private var isPhoneNumberValid = false
    @State private var isVerificationCodeValid = false
    
    // 키보드 포커싱 관련 변수
    @FocusState private var isFocused: Bool
    
    // Firebase Query Request가 완료 됬는지 확인하는 상태 변수
    @State var result: Bool = false
    
    var body: some View {
        ZStack {
            // 배경색 설정
            Color(red: 0.9, green: 0.9843, blue: 1.0)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Spacer()
                
                // MARK: 이메일 입력
                Text("이메일")
                    .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                    .bold()
                    .padding(.leading, 35)
                
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
                
                // MARK: 비밀번호 입력
                Text("비밀번호")
                    .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                    .bold()
                    .padding(.leading, 35)
                
                SecureField("비밀번호를 입력하세요.", text: $password)
                    .frame(height: 40)
                    .padding([.horizontal], 20)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    .padding([.horizontal], 30)
                    .font(.system(size: 16))
                
                // MARK: 비밀번호 확인 입력
                Text("비밀번호 확인")
                    .foregroundColor(Color(red: 0.259, green: 0.345, blue: 0.518))
                    .bold()
                    .padding(.leading, 35)
                
                SecureField("비밀번호를 다시 입력하세요.", text: $passwordcheck)
                    .frame(height: 40)
                    .padding([.horizontal], 20)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    .padding([.horizontal], 30)
                    .font(.system(size: 16))
                
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
                        .onChange(of: phoneNumber, perform: handlePhoneNumberChange)
                    
                    // 전송 버튼
                    Button(action: {
                        // 전화번호 유효성 검사
                        if !isPhoneNumberValid {
                            alertMessage = "유효한 전화번호를 입력해주세요. 예: 01012345678"
                            showAlert = true
                        } else {
                            sendVerificationCode()
                        }
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
                            .disabled(!isPhoneNumberValid || isVerificationSent)
                    }
                }
                .padding(.bottom, 5)
                
                // 인증번호 입력
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
                        .onChange(of: verificationCode, perform: handleVerificationCodeChange)
                    
                    // 확인 버튼
                    Button(action: {
                        // 인증번호 유효성 검사
                        if !isVerificationCodeValid {
                            alertMessage = "유효한 인증번호를 입력해주세요. 예: 123456"
                            showAlert = true
                        } else {
                            verifyCode()
                        }
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
                            .disabled(!isVerificationCodeValid || !isVerificationSent || isVerificationSuccessful)
                    }
                }
                .padding(.bottom, 50)
                
                // 가입하기 버튼
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // 비밀번호 일치 여부 확인
                        if password != passwordcheck {
                            alertMessage = "비밀번호가 일치하지 않습니다."
                            showAlert = true
                        } else if !isVerificationSuccessful {
                            alertMessage = "인증이 완료되지 않았습니다."
                            showAlert = true
                        } else {
                            Task{
                                let userInsert = UserInfo(result: $result)
                                let result = try await userInsert.insertUser(email: email, password: password, name: name, nickname: nickname)
                                 print(result)
                                registerUser()
                            }
                        }
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
            .padding([.leading, .trailing], 15)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("회원가입")
                        .bold()
                        .font(.system(size: 24))
                }
            }) // toolbar
            
            
            if isLoading {
                VStack {
                    Text("가입 진행 중...")
                        .font(.system(size: 24))
                        .padding()
                    ProgressView()
                }
                .frame(width: 250, height: 150)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
            }
        }
//        .navigationBarTitle("회원가입")
//        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
        }
    }
    
    // 휴대폰 번호 유효성 검사
    private func handlePhoneNumberChange(_ phoneNumber: String) {
        isPhoneNumberValid = validatePhoneNumber(phoneNumber)
    }
    
    private func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        // 전화번호가 "010"으로 시작하고, 총 11자리 숫자로 구성된 경우를 확인하기 위한 정규 표현식
        let phoneRegex = "^010[0-9]{8}$"
      
        // NSPredicate를 사용하여 정규 표현식과 전화번호를 비교합니다.
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneNumber)
    }
    
    // 인증 코드 유효성 검사
    private func handleVerificationCodeChange(_ verificationCode: String) {
        isVerificationCodeValid = validateVerificationCode(verificationCode)
    }
    
    private func validateVerificationCode(_ verificationCode: String) -> Bool {
        let codeRegex = "^[0-9]{6}$" // 인증번호가 6자리일 경우
        return NSPredicate(format: "SELF MATCHES %@", codeRegex).evaluate(with: verificationCode)
    }
    
    // 인증 코드 전송
    private func sendVerificationCode() {
        isLoading = true
        let formattedPhoneNumber = "+82" + phoneNumber.dropFirst() // 국제 전화번호 형식으로 변환
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
    
    // 인증 코드 확인
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
    
    // 사용자 등록
    private func registerUser() {
        isLoading = true
        
        alertMessage = "사용자 등록이 완료되었습니다."
        showAlert = true
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            isLoading = false
//            if let error = error {
//                alertMessage = "사용자 등록 실패: \(error.localizedDescription)"
//                showAlert = true
//                return
//            }
//            alertMessage = "사용자 등록이 완료되었습니다."
//            showAlert = true
            
//            // 사용자 정보를 Firebase에 저장
//            guard let userID = Auth.auth().currentUser?.uid else { return }
//            let userData: [String: Any] = [
//                "email": email,
//                "name": name,
//                "nickname": nickname,
//                "phoneNumber": phoneNumber
//            ]
//            Firestore.firestore().collection("users").document(userID).setData(userData) { error in
//                if let error = error {
//                    alertMessage = "사용자 정보 저장 실패: \(error.localizedDescription)"
//                    showAlert = true
//                    return
//                }
//                alertMessage = "사용자 정보가 성공적으로 저장되었습니다."
//                showAlert = true
                
                // 로그인 화면으로 이동
        path.removeLast()
    }
}
//    }
//}


struct JoinView_Previews: PreviewProvider {
    static var previews: some View {
        JoinView(path: LoginView(isLogin: .constant(false)).$path)
    }
}
