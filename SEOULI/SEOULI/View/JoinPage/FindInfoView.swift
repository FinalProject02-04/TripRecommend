import SwiftUI
import Firebase

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
    
    
    // MARK: 사용자 입력 및 상태 관련 변수들
    @State private var email = ""
    @State private var password = ""
    @State private var passwordcheck = ""
    @State private var name = ""
    @State private var nickname = ""
    @State private var phoneNumber = ""
    @State private var isEditing: Bool = true // 이메일 및 이름 텍스트 필드를 읽기 전용으로 설정할 변수

    
    // MARK: Firebase와의 통신 상태 관리 변수들
    // 로딩 중인지를 나타내는 상태 변수
    @State private var isLoading = false
    // 알림창을 띄울지 여부를 나타내는 상태 변수
    @State private var showAlert = false
    // 알림창에 표시할 메시지
    @State private var alertMessage = ""
    
    // MARK: Firebase 인증 관련 변수들
    @State private var verificationID: String?
    // 인증 코드가 전송되었는지 여부를 나타내는 상태 변수
    @State private var isVerificationSent = false
    // 인증이 성공적으로 완료되었는지 여부를 나타내는 상태 변수
    @State private var isVerificationSuccessful = false
    
    // MARK: 입력 유효성 검사를 위한 변수들
    @State private var isPhoneNumberValid = false
    @State private var isVerificationCodeValid = false
    // 키보드 포커싱 관련 변수
    @FocusState private var isFocused: Bool
    // Firebase Query Request가 완료 됬는지 확인하는 상태 변수
    @State var result: Bool = false
    
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
                        
                        // MARK: 휴대폰 인증 입력
                        
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
                                    handlePhoneNumberChange(phoneNumber)
                                }
                            
                            // MARK: 전송 버튼
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
                                    handleVerificationCodeChange(verificationCode)
                                }
                            
                            // MARK: 확인 버튼
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
                        
                        Spacer()
                        
                        // MARK: 아이디 찾기 버튼
                        Button{
                            
                            Task{
                                let userQuery = UserInfo(result: $result)
                                // Firebase에서 정보 가져오기(비동기)
                                let _: () = try await userQuery.checkUserPhone(phoneNumber: phoneNumber)
                            }
                            

                            
                        } label: {
                            Text("아이디 찾기")
                                .padding()
                                .frame(width: 200)
                                .bold()
                                .background(.theme)
                                .foregroundStyle(.white)
                                .clipShape(.buttonBorder)
                        }
//                        .alert("아이디 확인", isPresented: $resultIdAlert, actions: {
//                            Button("OK", role: .none, action: {
//                                path.removeLast()
//                                print("성공")
//                            })
//                        },
//                        message: {
//                            Text("hwicoding0625@gmail.com")
//                        })
                        
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
                                // 전화번호 유효성 검사
                                if !isPhoneNumberValid {
                                    alertMessage = "유효한 전화번호를 입력해주세요. 예: 01012345678"
                                    showAlert = true
                                } else {
                                    sendVerificationCode()
                                }
                                
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
                                    .disabled(!isPhoneNumberValid || isVerificationSent)
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
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.alertMessage = "인증 코드 전송 실패: \(error.localizedDescription)"
                    self.showAlert = true
                    return
                }
                self.verificationID = verificationID
                self.alertMessage = "인증 코드가 전송되었습니다."
                self.showAlert = true
                self.isVerificationSent = true
            }
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
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.alertMessage = "인증 실패: \(error.localizedDescription)"
                    self.showAlert = true
                    return
                }
                self.alertMessage = "인증이 완료되었습니다."
                self.showAlert = true
                self.isVerificationSuccessful = true
            }
        }
    }
} // FindInfoView

#Preview {
    FindInfoView(selectedFindInfo: 0, path:LoginView( isLogin: .constant(false)).$path)
}
