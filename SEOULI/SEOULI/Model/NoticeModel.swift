//
//  NoticeModel.swift
//  SEOULI
//
//  Created by 원도현 on 7/8/24.
//

import Foundation

struct NoticeModel : Decodable{
    var notice_seq : Int
    var notice_title: String
    var notice_content: String
    var notice_date : String
}

extension NoticeModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(notice_seq)
    }
}
