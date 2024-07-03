//
//  AuthenticationVM.swift
//  SEOULI
//
//  Created by 김소리 on 7/1/24.
//

import Foundation
import Firebase
import GoogleSignIn

struct Authentication {
    
    func googleOauth() async throws {
        // Google Sign In을 위한 구성 정보 가져오기
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("Firebase 클라이언트 ID를 찾을 수 없습니다.")
        }

        // Google Sign In 구성 객체 생성
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // rootViewController 가져오기
        let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = await scene?.windows.first?.rootViewController
        else {
            fatalError("루트 뷰 컨트롤러를 찾을 수 없습니다!")
        }
        
        // Google Sign In을 통한 인증 요청
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        )
        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
            throw "예기치 않은 오류가 발생했습니다. 다시 시도해 주세요."
        }
        
        // Firebase 인증 처리
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken, accessToken: user.accessToken.tokenString
        )
        try await Auth.auth().signIn(with: credential)
    }
    
    func logout() async throws {
        // Google Sign Out
        GIDSignIn.sharedInstance.signOut()
        
        // Firebase Sign Out
        try Auth.auth().signOut()
    }
}

// Error 처리를 위해 String을 Error로 확장
extension String: Error {}

