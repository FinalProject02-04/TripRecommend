/*
 RegularExpressionVM.swift
 
 Author : 이 휘
 Date : 2024.07.03 Thursday
 Description : 1차 UI frame 작업
 */

import Foundation

struct RegularExpression {
    // 이메일을 검증하기 위한 정규 표현식 객체를 저장하는 상수.
    private let emailRegex: NSRegularExpression
    // 비밀번호를 검증하기 위한 정규 표현식 객체를 저장하는 상수.
    private let passwordRegex: NSRegularExpression

    init() { // 초기화 메서드를 정의합니다.
        self.emailRegex = try! NSRegularExpression(pattern: #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#) // 이메일 정규 표현식을 컴파일하고 emailRegex에 할당합니다. (이메일 형식을 확인하는 정규 표현식)
        self.passwordRegex = try! NSRegularExpression(pattern: #"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"#) // 비밀번호 정규 표현식을 컴파일하고 passwordRegex에 할당합니다. (알파벳과 숫자가 모두 포함된 최소 8자 이상의 비밀번호 형식을 확인하는 정규 표현식)
    }

    func isValidEmail(_ email: String) -> Bool { // 이메일의 유효성을 검사하는 메서드를 정의합니다.
        let range = NSRange(location: 0, length: email.utf16.count) // 이메일 문자열 전체를 범위로 설정하여 NSRange 객체를 생성합니다.
        return emailRegex.firstMatch(in: email, options: [], range: range) != nil // 이메일이 정규 표현식과 일치하는지 확인하고, 일치하는 경우 true, 일치하지 않는 경우 false를 반환합니다.
    }
    
    func isValidPassword(_ password: String) -> Bool { // 비밀번호의 유효성을 검사하는 메서드를 정의합니다.
        let range = NSRange(location: 0, length: password.utf16.count) // 비밀번호 문자열 전체를 범위로 설정하여 NSRange 객체를 생성합니다.
        return passwordRegex.firstMatch(in: password, options: [], range: range) != nil // 비밀번호가 정규 표현식과 일치하는지 확인하고, 일치하는 경우 true, 일치하지 않는 경우 false를 반환합니다.
    }
}
