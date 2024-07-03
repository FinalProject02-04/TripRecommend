//
//  PurchaseModel.swift
//  SEOULI
//
//  Created by 김소리 on 7/3/24.
//

import Foundation

struct PurchaseModel : Decodable{
    var package_info : ProductModel
    var purchase_date : String
    var pur_id : Int
}

extension PurchaseModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(pur_id)
    }
}
