//
//  SeoulListModel.swift
//  SEOULI
//
//  Created by 김수민 on 6/26/24.
//

import Foundation

struct SeoulList: Decodable, Identifiable {
    var id: UUID?
    var name: String
    var address: String
    var description: String
    var inquiries: String
    var imageName: String


    init(id: UUID? = nil, name: String, address: String, description: String, inquiries: String, imageName: String) {
        self.id = id ?? UUID()
        self.name = name
        self.address = address
        self.description = description
        self.inquiries = inquiries
        self.imageName = imageName
    }

    // CodingKeys enum to handle custom decoding logic if needed
    private enum CodingKeys: String, CodingKey {
        case id, name, address, description, inquiries, imageName
    }
}
