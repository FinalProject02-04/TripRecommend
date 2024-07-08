import SwiftUI
import FirebaseFirestore

// Firestore 인스턴스 생성
let db = Firestore.firestore()

struct EditInfoView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var passwordCheck = ""
    @State private var nickname = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isProcessing = false
    @State private var showSuccessAlert = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // 배경 색상
            Color("Background Color")
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 40) {
                Spacer()

                // 비밀번호 섹션
                VStack {
                    Text("비밀번호")
                        .font(.system(size: 18))
                        .foregroundColor(Color("Text Color"))
                        .bold()
                        .padding(.leading, 30)
                    
                    SecureField("비밀번호", text: $password)
                        .frame(height: 40)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                        .padding(.horizontal, 30)
                        .font(.system(size: 16))
                }

                // 비밀번호 확인 섹션
                VStack {
                    Text("비밀번호 확인")
                        .font(.system(size: 18))
                        .foregroundColor(Color("Text Color"))
                        .bold()
                        .padding(.leading, 30)
                    
                    SecureField("비밀번호 확인", text: $passwordCheck)
                        .frame(height: 40)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                        .padding(.horizontal, 30)
                        .font(.system(size: 16))
                }

                // 닉네임 섹션
                VStack {
                    Text("닉네임")
                        .font(.system(size: 18))
                        .foregroundColor(Color("Text Color"))
                        .bold()
                        .padding(.leading, 30)
                    
                    TextField("닉네임", text: $nickname)
                        .frame(height: 40)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                        .padding(.horizontal, 30)
                        .font(.system(size: 16))
                }

                HStack {
                    Spacer()
                    Button(action: {
                        handleUpdate()
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
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인"), action: {
                            if showSuccessAlert {
                                dismiss()
                            }
                        })
                    )
                }

                Spacer(minLength: 40)
            }
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("내 정보")
                        .bold()
                        .foregroundColor(Color("Text Color"))
                        .font(.title)
                }
            })

            if isProcessing {
                ProgressView("Processing...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5, anchor: .center)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
            }
        }
    }

    private func handleUpdate() {
        guard validateInputs() else { return }

        isProcessing = true
        Task {
            let email = UserDefaults.standard.string(forKey: "userEmail") ?? ""
            let success = await updateUserByEmail(email: email, newPassword: password, newNickname: nickname)

            isProcessing = false
            if success {
                alertMessage = "정보가 성공적으로 업데이트되었습니다."
                showSuccessAlert = true
            } else {
                alertMessage = "정보 업데이트에 실패했습니다."
                showSuccessAlert = false
            }
            showAlert = true
        }
    }

    private func validateInputs() -> Bool {
        guard !password.isEmpty, !passwordCheck.isEmpty, !nickname.isEmpty else {
            alertMessage = "모든 필드를 채워주세요."
            showAlert = true
            return false
        }
        
        guard password == passwordCheck else {
            alertMessage = "비밀번호가 일치하지 않습니다."
            showAlert = true
            return false
        }

        // 필요한 경우 추가 비밀번호 검증을 여기에 추가합니다.
        return true
    }

    private func updateUserByEmail(email: String, newPassword: String, newNickname: String) async -> Bool {
        do {
            let querySnapshot = try await db.collection("user").whereField("user_email", isEqualTo: email).getDocuments()
            guard let document = querySnapshot.documents.first else {
                alertMessage = "해당 이메일의 문서를 찾을 수 없습니다."
                return false
            }

            let documentID = document.documentID
            try await db.collection("user").document(documentID).updateData([
                "user_pw": newPassword,
                "user_nickname": newNickname
            ])
            return true
        } catch {
            print("Error updating document: \(error)")
            return false
        }
    }
}

#Preview {
    EditInfoView()
}
