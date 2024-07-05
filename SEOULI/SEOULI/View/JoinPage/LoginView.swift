/*
 LoginView.swift
 
 Author : 이 휘
 Date : 2024.07.05 Fri
 Description : 1차 UI frame 작업
 */
import SwiftUI
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

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
                            
                            print("Firebase Query Result: \(result)")

                            if result {
                                print("로그인성공")
                                print("사용자 정보: \(userInfo)")
                                
                                print(userInfo.documentId)
                                // firebase request 성공
                                if userInfo.documentId.isEmpty{
                                    
                                    print("ID, PW 잘못 입력")
                                    // id, pw 잘못 입력
                                    self.showAlert = true
                                    self.errorMessage = "아이디와 비밀번호를 확인해주세요."
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
                        Task {
                            do {
                                try await googleOauth()
                            } catch {
                                print("Google OAuth Error: \(error.localizedDescription)")
                                self.showAlert = true
                                self.errorMessage = "Google OAuth Error: \(error.localizedDescription)"
                            }
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
    
    func googleOauth() async throws {
        
        print("googleOauth 함수까지 들어옴")
        
        // Google 로그인을 위해 Firebase의 클라이언트 ID를 가져옴
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("no firebase clientID found")
        }

        // Google Sign In 구성 객체 생성
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // rootView 가져오기
        let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = await scene?.windows.first?.rootViewController
        else {
            fatalError("There is no root view controller!")
        }
        
        // Google 로그인을 통한 인증 요청
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        )
        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
            return
        }
        
        // Firebase 인증을 위한 GoogleAuthProvider credential 생성
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken, accessToken: user.accessToken.tokenString
        )
        try await Auth.auth().signIn(with: credential)
        
        // 사용자의 이메일 가져오기
        guard let email = user.profile?.email else {
            return
        }
        
        print("이메일은 가져왔니? \(email)")
        
        // 사용자의 추가 정보 가져오기
        let currentUser = Auth.auth().currentUser
        currentUser?.reload { error in
            guard let displayName = currentUser?.displayName else {
                return
            }
            
            // 사용자 데이터베이스 확인
            self.checkUserInDatabase(email: email, name: displayName)
        }
    }

    // 데이터베이스에서 유저 체크 함수
    func checkUserInDatabase(email: String, name: String) {
        
        print("checkUserInDatabase 함수 호출됨")
        print("이메일: \(email), 이름: \(name)")
        
        // Firestore 데이터베이스 인스턴스 생성
        let db = Firestore.firestore()
        // "users" 컬렉션에서 이메일 필드가 입력된 이메일과 일치하는 문서를 찾는 쿼리 생성
        let userRef = db.collection("user").whereField("user_email", isEqualTo: email)
        
        print("Firestore 쿼리 준비됨: \(userRef)")
        
        // Firestore에서 사용자 정보 조회
        userRef.getDocuments { snapshot, error in
            // 데이터베이스 오류 처리
            if let error = error {
                // 데이터베이스 오류 메시지를 로그로 출력
                print("데이터베이스 오류: \(error.localizedDescription)")
                // 경고창 표시 여부 플래그를 true로 설정
                self.showAlert = true
                // 경고창에 표시할 오류 메시지 설정
                self.errorMessage = "데이터베이스 오류: \(error.localizedDescription)"
                return
            }
            
            guard let snapshot = snapshot else {
                print("Firestore 쿼리 결과 없음")
                return
            }
            
            if snapshot.isEmpty {
                // Firestore 쿼리 결과가 있지만, 사용자가 존재하지 않는 경우
                print("사용자가 존재하지 않음")
                
                // 사용자가 존재하지 않을 경우 회원가입을 유도하는 경고창 표시
                self.showAlert = true
                self.errorMessage = "이 이메일은 등록되지 않았습니다. 회원가입 하시겠습니까?"
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "회원가입", message: "이 계정으로 회원가입 하시겠습니까?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "예", style: .default) { _ in
                        self.path.append("JoinView")
                        UserDefaults.standard.set(email, forKey: "userEmail")
                        UserDefaults.standard.set(name, forKey: "userName")
                    })
                    
                    alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
                    
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            } else {
                // Firestore 쿼리 결과가 있고, 사용자가 존재하는 경우
                print("사용자가 존재함")
                
                // 사용자가 존재하므로 로그인 상태를 true로 설정
                self.isLogin = true
                
                // snapshot 안의 문서들을 순회하면서 email 값을 출력
                for document in snapshot.documents {
                    let userData = document.data()
                    if let email = userData["user_email"] as? String {
                        print("사용자 이메일: \(email)")
                    }
                }
            }
        }
    } //checkUserInDatabase
}

#Preview {
    LoginView(isLogin: .constant(false))
}
