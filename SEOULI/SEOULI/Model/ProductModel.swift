//
//  ProductModel.swift
//  SEOULI
//
//  Created by 김소리 on 6/26/24.
//

import Foundation

struct ProductModel : Identifiable{
    var id = UUID()
    var name: String
    var image: String
    var price : Int
}
