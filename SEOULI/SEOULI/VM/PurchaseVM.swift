//
//  testVM.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import Foundation

struct PurchaseVM{
    func insertPurchase(pack_id:String,user_id:String) async throws{
        let url = "http://192.168.50.83:8000/purchase/insert?pack_id=\(pack_id)&user_id=\(user_id)"
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
    }
}
