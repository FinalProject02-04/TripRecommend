/*
 AuthenticationVM.swift

 Author : 이 휘
 Date : 2024.07.03
 Description : 1차 UI frame 작업
 */

import SwiftUI
import Firebase
import FirebaseFirestore
import GoogleSignIn

// UserInfo 구조체 정의
struct UserInfo {
    
    // Firestore 데이터베이스 객체 생성
    let db = Firestore.firestore()
    // 현재 날짜 객체 생성
    let date = Date()
    // 날짜 포맷터 객체 생성
    let formatter = DateFormatter()
    
    // 결과 값을 바인딩하는 변수, 외부에서 값을 변경 가능
    @Binding var result: Bool
    
    // MARK: 사용자 정보를 가져오는 비동기 함수
    func fetchUserInfo(userid: String, userpw: String) async throws -> UserModel {
        // 사용자 정보 모델 선언
        var userInfo: UserModel?
        // 초기 결과 값을 false로 설정
        result = false

        do {
            // 사용자 컬렉션 접근
            let querySnapshot = try await db.collection("user")
                // 이메일 필터링
                .whereField("user_email", isEqualTo: userid)
                // 비밀번호 필터링
                .whereField("user_pw", isEqualTo: userpw)
                // 문서 가져오기, 에러 발생 가능성 있음
                .getDocuments()
            // 데이터 가져오기 성공 시 true 설정
            result = true
            // 결과 값 출력
            print("\(result)  안되면 어ㅉㄹ")

            // 가져온 문서들 중 첫 번째 문서의 데이터를 UserModel 객체로 변환
            for document in querySnapshot.documents {
                userInfo = UserModel(
                    documentId: document.documentID,
                    userid: document.data()["user_email"] as! String, // 이메일
                    userpw: document.data()["user_pw"] as! String, // 비밀번호
                    usernickname: document.data()["user_nickname"] as! String, //닉네임
                    userjoindate: document.data()["join_date"] as! String, // 가입 날짜
                    userdeldate: document.data()["delete_date"] as! String // 삭제 날짜
                )
            }
        } catch {
            print("Error getting documents: \(error)") // 에러 발생 시 로그 출력
        }

        // 만약 userInfo가 nil이라면 기본 값으로 빈 UserModel 객체 반환
        return userInfo ?? UserModel(documentId: "", userid: "", userpw: "", usernickname: "", userjoindate: "", userdeldate: "")
    }
    
    // MARK: 이메일 중복 확인을 위한 비동기 함수
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
    
    // MARK: 전화번호 중복 확인 및 이메일 표시 함수
    func checkUserPhone(phoneNumber: String) async throws {
        let db = Firestore.firestore()
        
        do {
            // Firestore에서 해당 전화번호가 존재하는지 확인
            let querySnapshot = try await db.collection("user")
                .whereField("user_phone", isEqualTo: phoneNumber)
                .getDocuments()
            
            // 문서가 비어 있으면 동일한 전화번호가 없다는 의미
            if querySnapshot.documents.isEmpty {
                showAlert(message: "전화번호에 매치되는 이메일이 없습니다.")
            } else {
                // 동일한 전화번호가 있는 경우 이메일 정보를 가져와 알림창으로 표시
                if let document = querySnapshot.documents.first {
                    if let email = document.data()["user_email"] as? String {
                        showAlert(message: "매치되는 이메일: \(email)")
                    }
                }
            }

        } catch {
            print("Error getting documents: \(error)") // 에러 발생 시 로그 출력
            showAlert(message: "데이터베이스 오류: \(error.localizedDescription)")
        }
    }

    // MARK: 알림창 표시 함수
    func showAlert(message: String) {
        // 최상위 뷰 컨트롤러 가져오기
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let topController = window.rootViewController {
            let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            // 현재의 최상위 뷰 컨트롤러를 찾아서 알림창을 표시
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    
    // MARK: 사용자를 Firestore에 추가하는 비동기 함수
    func insertUser(email: String, password: String, name: String, nickname: String, phoneNumber:String) async throws -> Bool {
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
                "user_phone": phoneNumber, // 전화번호
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
    
    // MARK: 사용자를 Firestore에 추가하는 비동기 함수
    // 이메일을 사용하여 비밀번호와 닉네임을 업데이트하는 비동기 함수
    func updateUserByEmail(email: String, newPassword: String, newNickname: String) async throws -> Bool {
        var result = false // 결과 값 초기화
        
        do {
            // Firestore의 사용자 컬렉션에서 이메일로 문서를 검색
            let querySnapshot = try await db.collection("user").whereField("user_email", isEqualTo: email).getDocuments()
            
            // 이메일에 해당하는 문서를 찾았는지 확인
            guard let document = querySnapshot.documents.first else {
                print("No document found with the given email.")
                return false // 해당 이메일의 문서가 없으면 false 반환
            }
            
            // 문서 ID 가져오기
            let documentID = document.documentID
            
            // 문서 업데이트 (비밀번호와 닉네임 수정)
            try await db.collection("user").document(documentID).updateData([
                "user_pw": newPassword, // 비밀번호 업데이트
                "user_nickname": newNickname // 닉네임 업데이트
            ])
            
            result = true // 업데이트 성공 시 true
        } catch {
            print("Error updating document: \(error)") // 오류 로그 출력
            result = false // 실패 시 false
        }
        
        return result // 결과 값 반환
    }
}
