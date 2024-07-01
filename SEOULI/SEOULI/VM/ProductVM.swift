//
//  ProductVM.swift
//  SEOULI
//
//  Created by 김소리 on 7/1/24.
//

import Foundation

struct ProductVM{
    func selectProduct() async throws -> [ProductModel] {
        let url = "http://192.168.50.83:8000/package/select"
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let product = try JSONDecoder().decode([ProductModel].self, from: data)
        return product
    }
}

