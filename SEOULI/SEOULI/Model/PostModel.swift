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
    var views: Int = 0
    
    init(id: UUID = UUID(), title: String, username: String, subtitle: String, content: String, date: String, image: String, views: Int) {
        self.id = id
        self.title = title
        self.username = username
        self.subtitle = subtitle
        self.content = content
        self.date = date
        self.image = image
        self.views = 0
    }
}
