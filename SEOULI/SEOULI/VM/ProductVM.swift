//
//  ProductVM.swift
//  SEOULI
//
//  Created by 김소리 on 7/1/24.
//

import Foundation

struct ProductVM{
    func selectProduct() async throws -> [ProductModel] {
        print("productList Start")
        let url = "http://192.168.50.83:8000/package/select"
        print("1")
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        print("2")
        let product = try JSONDecoder().decode([ProductModel].self, from: data)
        print("3")
        return product
        print(product)
    }
}

