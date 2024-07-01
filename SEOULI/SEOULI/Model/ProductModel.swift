//
//  ProductModel.swift
//  SEOULI
//
//  Created by 김소리 on 6/26/24.
//

import Foundation

struct ProductModel : Decodable{
    var id : Int
    var name: String
    var price: Int
    var startdate : String
    var enddate : String
    var trans : String
    var tourlist : String
    var stay : String
}

extension ProductModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
