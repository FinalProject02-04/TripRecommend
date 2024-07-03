//
//  SEOULIApp.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI
import UIKit
import Firebase
import GoogleSignIn
import UserNotifications


@main
struct SEOULIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}

// UIApplicationDelegate 프로토콜을 준수하는 AppDelegate 클래스 정의
class AppDelegate: NSObject, UIApplicationDelegate {
    // 앱이 시작할 때 호출되는 메서드
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Firebase 초기화
        FirebaseApp.configure()
        // 원격 알림 권한 요청
        // UNUserNotificationCenter의 현재 인스턴스를 가져와서 delegate를 self로 설정
        UNUserNotificationCenter.current().delegate = self
        // 사용자에게 원격 알림 권한을 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            // 에러가 발생하면 에러 메시지를 출력
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            // 권한이 부여되면 원격 알림을 등록
            if granted {
                // 메인 스레드에서 원격 알림을 등록하는 작업을 실행
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        // 앱이 성공적으로 실행되었음을 반환
        return true
    }
    // 원격 알림 등록에 성공하면 호출되는 메서드
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 수신한 디바이스 토큰을 Firebase Auth에 설정
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    }
    // 원격 알림을 수신했을 때 호출되는 메서드
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Firebase Auth가 알림을 처리할 수 있는지 확인
        if Auth.auth().canHandleNotification(userInfo) {
            // Firebase Auth가 알림을 처리하면 데이터가 없음을 반환
            completionHandler(.noData)
            return
        }
        // 원격 알림이 Firebase Auth와 관련이 없는 경우 처리
        completionHandler(.newData)
    }
}
// UNUserNotificationCenterDelegate 프로토콜을 준수하는 AppDelegate 확장
extension AppDelegate: UNUserNotificationCenterDelegate {
    // 앱이 실행 중일 때 알림이 도착하면 호출되는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            // iOS 14.0 이상에서 사용할 수 있는 알림 표시 옵션을 설정
            completionHandler([.banner, .list, .sound])
        } else {
            // iOS 14.0 이전에서는 알림, 소리, 배지를 사용하여 알림을 표시
            completionHandler([.alert, .sound, .badge])
        }
    }
}
