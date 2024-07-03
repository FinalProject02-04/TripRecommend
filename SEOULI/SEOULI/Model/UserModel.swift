/*
 UserModel.swift
 
 Author : 이 휘
 Date : 2024.07.03 Thursday
 Description : 1차 UI frame 작업
 */

import Foundation

struct UserModel{
    var documentId: String
    var userid: String
    var userpw: String
    var userjoindate: String
    var userdeldate: String
    
    init(documentId: String, userid: String, userpw: String, userjoindate: String, userdeldate: String) {
        self.documentId = documentId
        self.userid = userid
        self.userpw = userpw
        self.userjoindate = userjoindate
        self.userdeldate = userdeldate
    }
}

//
//
//struct User {
//    var email: String
//    var password: String
//    var name: String
//    var nickname: String
//    var registrationDate: Date
//    var deletionDate: Date?
//    var isDeleted: Bool
//    
//    init(email: String, password: String, name: String, nickname: String, registrationDate: Date, deletionDate: Date? = nil, isDeleted: Bool) {
//        self.email = email
//        self.password = password
//        self.name = name
//        self.nickname = nickname
//        self.registrationDate = registrationDate
//        self.deletionDate = deletionDate
//        self.isDeleted = isDeleted
//    }
//}
