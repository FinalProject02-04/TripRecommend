//
//  PostModel.swift
//  SEOULI
//
//  Created by 김소리 on 6/27/24.
//

import Foundation

struct PostModel: Identifiable {
    var id = UUID()
    var title: String
    var username: String
    var subtitle: String
    var content: String
    var date: String
    var image : String
}
