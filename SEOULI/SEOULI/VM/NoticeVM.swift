//
//  NoticeVM.swift
//  SEOULI
//
//  Created by 김소리 on 7/8/24.
//

import Foundation

import SwiftUI

struct NoticeVm{
    func selectNotice() async throws -> [NoticeModel] {
        let url = "http://192.168.50.83:8000/notice/select"
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let notice = try JSONDecoder().decode([NoticeModel].self, from: data)
        return notice
    }
}
