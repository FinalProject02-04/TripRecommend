//
//  SeoulListVM.swift
//  SEOULI
//
//  Created by 김수민 on 7/1/24.
//

import Foundation

class SeoulListVM: ObservableObject {
    
    @Published var locations: [SeoulList] = []
    @Published var errorMessage: String?

    func fetchDataFromAPI() {
        guard let url = URL(string: "http://192.168.50.83:8000/place/list") else {
            self.errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }

            do {
                let decodedData = try JSONDecoder().decode([SeoulList].self, from: data)
                DispatchQueue.main.async {
                    self.locations = decodedData.map { SeoulList(id: $0.id, name: $0.name, address: $0.address, description: $0.description, inquiries: $0.inquiries, imageName: $0.imageName) }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }
}
