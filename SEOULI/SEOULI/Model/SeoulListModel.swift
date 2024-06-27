//
//  SeoulListModel.swift
//  SEOULI
//
//  Created by 김수민 on 6/26/24.
//

import Foundation

struct SeoulList: Identifiable {
    var id = UUID()
    var name: String
    var imageName: String
    var description : String
    var address: String
    var inquiries : String

}


