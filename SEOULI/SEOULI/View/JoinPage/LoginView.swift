/*
 LoginView.swift
 
 Author : 이 휘
 Date : 2024.07.05 Fri
 Description : 1차 UI frame 작업
 */
import SwiftUI
import GoogleSignIn // <<<<<
import FirebaseAuth // <<<<<
import FirebaseFirestore // <<<<<
import FirebaseCore // <<<<<

struct LoginView: View {
    
    // MARK: 변수 지정
    @State var email = ""
    @State var password = ""
    @FocusState var isTextFieldFocused: Bool
    @State var path = NavigationPath()
    @State private var showAlert = false
    @State private var errorMessage: String = ""
    @Binding var isLogin: Bool
    @State var result: Bool = false
    // 로딩 상태를 추적하는 변수
    @State private var isLoading = false


    var body: some View {
        
        NavigationStack(path: $path){
            ZStack {
                VStack {
                    
                    Spacer(minLength: 300)
                    
                    // MARK: 배경색 설정
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.theme]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    // 전체화면에 적용
                    .edgesIgnoringSafeArea(.all)
                } // VStack (배경색)
                
                Spacer()
                
                ScrollView{
                    
                    VStack(content: {
                        
                        Spacer() // 빈 공간을 추가합니다.
                        
                        // MARK: LOGO
                        Image("logo")
                            .resizable()
                            .frame(width: 230, height: 50)
                            .padding(.top, 100)
                        
                        Spacer().frame(height: 50)
                        
                        // MARK: 아이디
                        TextField("이메일을 입력하세요.", text: $email)
                            .focused($isTextFieldFocused)
                            .textInputAutocapitalization(.never)
                            .frame(height: 54)
                            .padding([.horizontal], 20)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                            .padding([.horizontal], 30)
                            .font(.system(size: 20))
                            .onChange(of: email) {
                                email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                        
                        Spacer().frame(height: 20)
                        
                        // MARK: 비밀번호
                        SecureField("비밀번호를 입력하세요.", text: $password)
                            .focused($isTextFieldFocused)
                            .textInputAutocapitalization(.never)
                            .frame(height: 54)
                            .padding([.horizontal], 20)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                            .padding([.horizontal], 30)
                            .font(.system(size: 20))
                            .onChange(of: password) {
                                password = password.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                        
                        Spacer().frame(height: 20)
                        
                        HStack {
                            // MARK: ID 찾기 버튼
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
                            
                            // MARK: Password 찾기 버튼
                            Button {
                                path.append("FindInfoView_Pw")
                            } label: {
                                Text("비밀번호 찾기")
                                    .foregroundStyle(.black)
                            }
                        } // HStack
                        .padding(.top, 30)
                        
                        Spacer().frame(height: 30)
                        
                        Button(action: {
                            Task {
                                
                                // 로딩 시작
                                isLoading = true
                                
                                do {
                                    let userQuery = UserInfo(result: $result)
                                    let userInfo = try await userQuery.fetchUserInfo(userid: email, userpw: password)
                                    
                                    if result {
                                        if userInfo.documentId.isEmpty {
                                            self.showAlert = true
                                            self.errorMessage = "아이디와 비밀번호를 확인해주세요."
                                        } else {
                                            self.isLogin = true
                                            UserDefaults.standard.set(email, forKey: "userEmail")
                                            UserDefaults.standard.set(userInfo.usernickname, forKey: "userNickname")
                                        }
                                    } else {
                                        self.showAlert = true
                                        self.errorMessage = "서버에 연결에 실패했습니다."
                                    }
                                } catch {
                                    print("Error fetching user info: \(error)")
                                    self.showAlert = true
                                    self.errorMessage = "사용자 정보를 가져오는데 실패했습니다."
                                }
                                // 로딩 종료
                                isLoading = false
                            }
                        }) {
                            Text("로그인")
                                .padding()
                                .frame(width: 200)
                                .background(.theme)
                                .foregroundStyle(.white)
                                .clipShape(.buttonBorder)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("알림"),
                                message: Text(errorMessage),
                                dismissButton: .default(Text("확인"))
                            )
                        }

                        
                        // MARK: 개인 회원 로그인
                        HStack(content: {
                            VStack {
                                Divider()
                                    .overlay(Rectangle().frame(height: 1))
                                    .padding(.leading, 30)
                            }
                            
                            Text("개인회원 SNS 로그인")
                                .frame(width: 160)
                                .bold()
                            
                            VStack {
                                Divider()
                                    .overlay(Rectangle().frame(height: 1))
                                    .padding(.trailing, 30)
                            }
                        }) // HStack
                        .padding([.top, .bottom], 30)
                        
                        // MARK: 소셜 로그인 버튼
                        Button(action: {
                            
                            // 로딩 시작
                            isLoading = true
                            
                            // 비동기 작업을 실행.
                            Task {
                                // 실행
                                do {
                                    // VM 구글 로그인 실행(비동기)
                                    try await googleOauth()
                                // 오류 잡기
                                } catch {
                                    print("구글 로그인 에러 : \(error.localizedDescription)")
                                    
                                    DispatchQueue.main.async {
                                        // 알림창을 표시.
                                        self.showAlert = true
                                        // 알림창 메세지
                                        self.errorMessage = "구글 로그인 시 문제가 발생했습니다."
                                    }
                                }
                                // 로딩 종료
                                isLoading = false
                            }
                        }, label: {
                            Image("google_icon")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .scaledToFit()
                        })
                        
                        // MARK: 회원 가입
                        HStack {
                            
                            Text("계정이 없으세요?")
                            
                            // MARK: 가입하기 번튼
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
                    
                } // ScrollView
                
                
                // 로딩 상태에 따라 ProgressView 표시
                if isLoading {
                    LoadingView()
                }
                                
            } // ZStack
            // Navigation 경로 설정
            .navigationDestination(for: String.self) { value in
                
                // 경로 이름별 설정
                switch value {
                // 아이디 찾기 화면
                case "FindInfoView_Id":
                    FindInfoView(selectedFindInfo: 0, path: $path)
                // 비밀번호 찾기 화면.
                case "FindInfoView_Pw":
                    FindInfoView(selectedFindInfo: 1, path: $path)
                // 회원가입 화면.
                case "JoinView":
                    JoinView(path: $path)
                // 비밀번호 변경 화면.
                case "ChangePwView":
                    ChangePwView(path: $path)
                // 메인 콘텐츠 화면.
                case "ContentView":
                    ContentView(isLogin: $isLogin)
                // 알 수 없는 화면.
                default:
                    Text("알 수 없는 화면입니다.")
                }
            }
        } // NavigationStack
    } // body
    
    // MARK: 구글 OAuth 인증 함수
    func googleOauth() async throws {
        print("googleOauth 함수 호출")
        
        // Firebase의 클라이언트 ID를 가져옴
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            // Client ID가 없으면 오류를 발생.
            fatalError("no firebase clientID found")
        }

        // Google Sign-In 설정을 구성.
        let config = GIDConfiguration(clientID: clientID)
        // 설정을 Google Sign-In 인스턴스에 적용.
        GIDSignIn.sharedInstance.configuration = config
        
        // 현재 활성화된 장면을 가져옴.
        let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
        // rootViewController가 없으면 오류를 발생.
        guard let rootViewController = await scene?.windows.first?.rootViewController else {
            fatalError("There is no root view controller!")
        }
        
        // 비동기로 Google 로그인 진행
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        // 로그인된 사용자를 가져옴.
        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
            return // ID 토큰이 없으면 반환.
        }
        
        // Google 자격 증명을 생성.
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken, accessToken: user.accessToken.tokenString
        )
        // Firebase에 자격 증명을 사용해 로그인.
        try await Auth.auth().signIn(with: credential)
        
        // 사용자의 이메일 가져오기
        guard let email = user.profile?.email else {
            return // 이메일이 없으면 반환.
        }
        // 가져온 이메일 확인
        print("가져온 이메일 : \(email)")
        
        // 현재 사용자 정보를 가져옴.
        let currentUser = Auth.auth().currentUser
        // 사용자 정보를 비동기로 갱신.
        try await currentUser?.reload()
        
        guard let displayName = currentUser?.displayName else {
            return // 사용자 이름이 없으면 반환.
        }
        
        // Firebase DB에서 사용자 정보를 확인.
        checkUserInDatabase(email: email, name: displayName)
    } // googleOauth


    // MARK: Firebase DB에서 User check 함수
    func checkUserInDatabase(email: String, name: String) {
        
        print("checkUserInDatabase 함수 호출")
        // 비교할 이메일과 이름 가져오기
        print("비교할 이메일과 이름 가져오기\n이메일: \(email), 이름: \(name)")
        
        // Firestore 데이터베이스 인스턴스 생성
        let db = Firestore.firestore() // Firestore 인스턴스를 가져옵니다.
        // "users" 컬렉션에서 이메일 필드가 입력된 이메일과 일치하는 문서를 찾는 쿼리 생성
        // 이메일이 일치하는 사용자를 쿼리합니다.
        let userRef = db.collection("user").whereField("user_email", isEqualTo: email)
        
        print("Firestore 쿼리 준비됨: \(userRef)")
        
        // Firestore에서 사용자 정보 조회
        userRef.getDocuments { snapshot, error in
            // 데이터베이스 오류인 경우
            if let error = error {
                // 오류 메세지 출력
                print("데이터베이스 오류: \(error.localizedDescription)")
                
                // Main Thread 사용하여 비동기 작업
                DispatchQueue.main.async {
                    // 알림창 표시 여부
                    self.showAlert = true
                    // 알림창 메세지
                    self.errorMessage = "데이터베이스 오류입니다."
                }
                return
            }
            
            // Query 결과가 없는 경우
            guard let snapshot = snapshot else {
                // 결과 출력
                print("Firestore Query 결과 없음")
                return
            }
            // Query 결과가 비어 있는 경우
            if snapshot.isEmpty {

                print("사용자가 존재하지 않음")
                
                // Main Thread 사용하여 비동기 작업
                DispatchQueue.main.async {
//                    // 알림창 표시 여부
//                    self.showAlert = true
//                    // 알림창 메세지
//                    self.errorMessage = "
                    
                    // 경고창을 생성.
                    let alert = UIAlertController(
                        // 경고창의 제목
                        title: "회원가입",
                        // 경고창의 메시지
                        message: "이 이메일은 등록되지 않았습니다. 회원가입 하시겠습니까?",
                        // 경고창의 스타일을 설정.
                        preferredStyle: .alert
                    )
                    // "예" 버튼을 추가.
                    alert.addAction(UIAlertAction(title: "예", style: .default) { _ in
                        // JoinView로 이동.
                        self.path.append("JoinView")
                        // 이메일을 저장.
                        UserDefaults.standard.set(email, forKey: "userEmail")
                        // 이름을 저장.
                        UserDefaults.standard.set(name, forKey: "userName")
                    })
                    // "아니오" 버튼을 추가.
                    alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
                    
                    // UIWindowScene을 가져와서 타입 캐스팅을 시도
                    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let rootVC = scene.windows.first?.rootViewController else {
                        // rootViewController가 없으면 fatalError를 발생.
                        fatalError("There is no root view controller!")
                    }

                    // rootViewController에서 present 메서드를 호출하여 alert를 화면에 표시.
                    rootVC.present(alert, animated: true, completion: nil)
                } // DispatchQueue
                
            // 쿼리 결과가 있는 경우
            } else {
                print("사용자가 존재함")
                // 로그인 상태를 true로 설정.
                self.isLogin = true
                
                for document in snapshot.documents {
                    // 사용자 데이터를 가져옴.
                    let userData = document.data()
                    
                    // user_email 가져오기
                    if let userEmail = userData["user_email"] as? String {
                        print("사용자 이메일: \(userEmail)")
                        UserDefaults.standard.set(userEmail, forKey: "userEmail")
                    } else {
                        print("사용자 이메일이 존재하지 않습니다.")
                    }
                    
                    // user_nickname 가져오기
                    if let userNickname = userData["user_nickname"] as? String {
                        print("사용자 닉네임: \(userNickname)")
                        UserDefaults.standard.set(userNickname, forKey: "userNickname")
                    } else {
                        print("사용자 닉네임이 존재하지 않습니다.")
                    }
                    
                    // UserDefaults에 변경된 값들을 바로 저장
                    UserDefaults.standard.synchronize()
                }
            }
        }
    } // checkUserInDatabase
}

#Preview {
    LoginView(isLogin: .constant(false))
}
