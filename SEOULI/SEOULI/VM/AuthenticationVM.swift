/*
 AuthenticationVM.swift
 
 Author : 이 휘
 Date : 2024.07.03
 Description : 1차 UI frame 작업
 */

import SwiftUI
import Firebase
import FirebaseFirestore
//import GoogleSignIn

struct UserInfo{
    
    let db = Firestore.firestore()
    let date = Date()
    let formatter = DateFormatter()
    
    @Binding var result: Bool
    
    func fetchUserInfo(userid : String, userpw: String) async throws -> UserModel { // async throws 추가
        var userInfo: UserModel?
        result = false

        do {
            let db = Firestore.firestore()
            let querySnapshot = try await db.collection("user") // await 추가
                .whereField("user_email", isEqualTo: userid)
                .whereField("user_pw", isEqualTo: userpw)
                .getDocuments() // 에러 발생 가능성 추가 (throws)

            result = true // 데이터 가져오기 성공 시 true 설정
            print("\(result)  안되면 어ㅉㄹ")

            for document in querySnapshot.documents {
                
                userInfo = UserModel(
                    documentId: document.documentID,
                    userid: document.data()["user_email"] as! String,
                    userpw: document.data()["user_pw"] as! String,
                    userjoindate: document.data()["join_date"] as! String,
                    userdeldate: document.data()["delete_date"] as! String
                )
            }
        } catch {
            print("Error getting documents: \(error)") // 에러 처리
        }

        return userInfo ?? UserModel(documentId: "", userid: "", userpw: "", userjoindate: "", userdeldate: "")
    }
    
    func checkUserEmail(userid : String) async throws -> Bool {
        var isSameEmail: Bool = true
        result = false
        
        do {
            let db = Firestore.firestore()
            let querySnapshot = try await db.collection("user") // await 추가
                .whereField("userid", isEqualTo: userid)
                .getDocuments() // 에러 발생 가능성 추가 (throws)
            
            if querySnapshot.documents.isEmpty{
                isSameEmail = false  // 같은 이메일이 없음
            }else{
                isSameEmail = true // 같은 이메일이 있음
            }

        } catch {
            print("Error getting documents: \(error)") // 에러 처리
        }

        return isSameEmail
    }
    
    
    func insertUser(email: String, password: String, name: String, nickname: String) async throws -> Bool{
        formatter.dateFormat = "yyyy-MM-dd" // 원하는 형식 설정
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 및 한국 시간대 설정
        
        result = false

        let formattedDate = formatter.string(from: date)
        
        do{
            try await db.collection("user")
                .addDocument(data: [
                "user_email" : email,
                "user_pw" : password,
                "user_name" : name,
                "user_nickname" : nickname,
                "join_date" : formattedDate,
                "delete_date" : Date(),
                "isDeleted" : false
            ])
                .getDocument()
            
            result = true
            
        }catch{
            result = false
        }
        return result
        
    } // func insertUser
    
}
    
    
    
//    func insertItems(email: String, password: String, name: String, nickname: String) async throws -> Bool{
//        
//        // 원하는 형식 설정
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        // 한국어 및 한국 시간대 설정
//        formatter.locale = Locale(identifier: "ko_KR")
//        
//        
//        print("여기는 insert VM")
//        
//        db.collection("user").addDocument(data: [
//            "user_id" : email,
//            "user_pw" : password,
//            "user_name" : name,
//            "user_nick" : nickname,
//            "join_date" : registrationDate,
//            "delete_date" : deletionDate,
//            "isDeleted" : isDeleted
//        ]){error in
//            if error != nil{
//                status = false
//            }else{
//                status = true
//            }
//        }
//        return status
//    }
//    
//}

//struct Authentication {
//    
//    func googleOauth() async throws {
//        // Google Sign In을 위한 구성 정보 가져오기
//        guard let clientID = FirebaseApp.app()?.options.clientID else {
//            fatalError("Firebase 클라이언트 ID를 찾을 수 없습니다.")
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
//            fatalError("루트 뷰 컨트롤러를 찾을 수 없습니다!")
//        }
//        
//        // Google Sign In을 통한 인증 요청
//        let result = try await GIDSignIn.sharedInstance.signIn(
//            withPresenting: rootViewController
//        )
//        let user = result.user
//        guard let idToken = user.idToken?.tokenString else {
//            throw "예기치 않은 오류가 발생했습니다. 다시 시도해 주세요."
//        }
//        
//        // Firebase 인증 처리
//        let credential = GoogleAuthProvider.credential(
//            withIDToken: idToken, accessToken: user.accessToken.tokenString
//        )
//        try await Auth.auth().signIn(with: credential)
//    }
//    
//    func logout() async throws {
//        // Google Sign Out
//        GIDSignIn.sharedInstance.signOut()
//        
//        // Firebase Sign Out
//        try Auth.auth().signOut()
//    }
//}
//
//// Error 처리를 위해 String을 Error로 확장
//extension String: Error {}
//
