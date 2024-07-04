/*
 AuthenticationVM.swift

 Author : 이 휘
 Date : 2024.07.03
 Description : 1차 UI frame 작업
 */

import SwiftUI // SwiftUI 프레임워크를 사용
import Firebase // Firebase 프레임워크를 사용
import FirebaseFirestore // Firestore 데이터베이스 사용

// UserInfo 구조체 정의
struct UserInfo {
    
    let db = Firestore.firestore() // Firestore 데이터베이스 객체 생성
    let date = Date() // 현재 날짜 객체 생성
    let formatter = DateFormatter() // 날짜 포맷터 객체 생성
    
    @Binding var result: Bool // 결과 값을 바인딩하는 변수, 외부에서 값을 변경 가능
    
    // Firebase Firestore에서 사용자 정보를 가져오는 비동기 함수
    func fetchUserInfo(userid: String, userpw: String) async throws -> UserModel {
        var userInfo: UserModel? // 사용자 정보 모델 선언
        result = false // 초기 결과 값을 false로 설정

        do {
            // Firestore에서 사용자가 입력한 이메일과 비밀번호에 해당하는 문서를 가져옴
            let db = Firestore.firestore()
            let querySnapshot = try await db.collection("user") // 사용자 컬렉션 접근
                .whereField("user_email", isEqualTo: userid) // 이메일 필터링
                .whereField("user_pw", isEqualTo: userpw) // 비밀번호 필터링
                .getDocuments() // 문서 가져오기, 에러 발생 가능성 있음

            result = true // 데이터 가져오기 성공 시 true 설정
            print("\(result)  안되면 어ㅉㄹ") // 결과 값 출력

            // 가져온 문서들 중 첫 번째 문서의 데이터를 UserModel 객체로 변환
            for document in querySnapshot.documents {
                userInfo = UserModel(
                    documentId: document.documentID,
                    userid: document.data()["user_email"] as! String, // 이메일
                    userpw: document.data()["user_pw"] as! String, // 비밀번호
                    userjoindate: document.data()["join_date"] as! String, // 가입 날짜
                    userdeldate: document.data()["delete_date"] as! String // 삭제 날짜
                )
            }
        } catch {
            print("Error getting documents: \(error)") // 에러 발생 시 로그 출력
        }

        // 만약 userInfo가 nil이라면 기본 값으로 빈 UserModel 객체 반환
        return userInfo ?? UserModel(documentId: "", userid: "", userpw: "", userjoindate: "", userdeldate: "")
    }
    
    // 이메일 중복 확인을 위한 비동기 함수
    func checkUserEmail(userid: String) async throws -> Bool {
        var isSameEmail: Bool = true // 초기 값 true
        result = false // 결과 값 초기화
        
        do {
            // Firestore에서 해당 이메일이 존재하는지 확인
            let db = Firestore.firestore()
            let querySnapshot = try await db.collection("user") // 사용자 컬렉션 접근
                .whereField("userid", isEqualTo: userid) // 이메일 필터링
                .getDocuments() // 문서 가져오기, 에러 발생 가능성 있음
            
            // 문서가 비어 있으면 동일한 이메일이 없다는 의미
            if querySnapshot.documents.isEmpty {
                isSameEmail = false // 같은 이메일이 없음
            } else {
                isSameEmail = true // 같은 이메일이 있음
            }

        } catch {
            print("Error getting documents: \(error)") // 에러 발생 시 로그 출력
        }

        return isSameEmail // 이메일 중복 여부 반환
    }
    
    // 사용자를 Firestore에 추가하는 비동기 함수
    func insertUser(email: String, password: String, name: String, nickname: String) async throws -> Bool {
        formatter.dateFormat = "yyyy-MM-dd" // 날짜 형식 지정
        formatter.locale = Locale(identifier: "ko_KR") // 한국 시간대 설정
        
        result = false // 결과 값 초기화

        let formattedDate = formatter.string(from: date) // 현재 날짜를 포맷에 맞게 변환
        
        do {
            // Firestore의 사용자 컬렉션에 새로운 사용자 데이터를 추가
            try await db.collection("user")
                .addDocument(data: [
                "user_email": email, // 이메일
                "user_pw": password, // 비밀번호
                "user_name": name, // 이름
                "user_nickname": nickname, // 닉네임
                "join_date": formattedDate, // 가입 날짜
                "delete_date": "", // 삭제 날짜
                "isDeleted": false // 삭제 여부
            ])
            .getDocument() // 문서 가져오기
            
            result = true // 데이터 추가 성공 시 true
        } catch {
            result = false // 실패 시 false
        }
        return result // 결과 값 반환
    }
}

// 주석 처리된 코드, 이후 사용될 수 있음
// 사용자 데이터를 Firestore에 추가하는 비동기 함수
//func insertItems(email: String, password: String, name: String, nickname: String) async throws -> Bool {
//    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 날짜 형식 지정
//    formatter.locale = Locale(identifier: "ko_KR") // 한국 시간대 설정
//
//    db.collection("user").addDocument(data: [
//        "user_id": email, // 이메일
//        "user_pw": password, // 비밀번호
//        "user_name": name, // 이름
//        "user_nick": nickname, // 닉네임
//        "join_date": registrationDate, // 가입 날짜
//        "delete_date": deletionDate, // 삭제 날짜
//        "isDeleted": isDeleted // 삭제 여부
//    ]) { error in
//        if error != nil {
//            status = false // 에러 발생 시 false
//        } else {
//            status = true // 성공 시 true
//        }
//    }
//    return status // 결과 값 반환
//}

// 주석 처리된 Google 인증 및 로그아웃 함수
// Google 인증을 위한 비동기 함수
//struct Authentication {
//    func googleOauth() async throws {
//        // Google Sign In을 위한 구성 정보 가져오기
//        guard let clientID = FirebaseApp.app()?.options.clientID else {
//            fatalError("Firebase 클라이언트 ID를 찾을 수 없습니다.") // 클라이언트 ID가 없을 경우 오류 발생
//        }
//
//        // Google Sign In 구성 객체 생성
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//
//        // rootViewController 가져오기
//        let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
//        guard let rootViewController = await scene?.windows.first?.rootViewController
//        else {
//            fatalError("루트 뷰 컨트롤러를 찾을 수 없습니다!") // 루트 뷰 컨트롤러가 없을 경우 오류 발생
//        }
//
//        // Google Sign In을 통한 인증 요청
//        let result = try await GIDSignIn.sharedInstance.signIn(
//            withPresenting: rootViewController
//        )
//        let user = result.user
//        guard let idToken = user.idToken?.tokenString else {
//            throw "예기치 않은 오류가 발생했습니다. 다시 시도해 주세요." // 토큰이 없을 경우 예외 발생
//        }
//
//        // Firebase 인증 처리
//        let credential = GoogleAuthProvider.credential(
//            withIDToken: idToken, accessToken: user.accessToken.tokenString
//        )
//        try await Auth.auth().signIn(with: credential)
//    }
//
//    // 로그아웃을 위한 비동기 함수
//    func logout() async throws {
//        GIDSignIn.sharedInstance.signOut() // Google 로그아웃
//        try Auth.auth().signOut() // Firebase 로그아웃
//    }
//}

// Error 처리를 위해 String을 Error로 확장
//extension String: Error {}
