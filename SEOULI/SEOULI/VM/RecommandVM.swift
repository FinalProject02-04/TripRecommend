//
//  RecommandVM.swift
//  SEOULI
//
//  Created by 김수민 on 7/3/24.
//

import SwiftUI

class NetworkManager: ObservableObject {
    @Published var recommendations: [SeoulList] = []
    
    func fetchRecommendations(for input: String, completion: @escaping (Result<[SeoulList], Error>) -> Void) {
        guard let encodedInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://192.168.50.83:8000/place/recommend?input=\(encodedInput)") else {
            print("Failed to create URL for input: \(input)")
            completion(.failure(URLError(.badURL)))
            return
        }
        
        print("Fetch URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                if let json = json {
                    var recommendations: [SeoulList] = []
                    
                    for item in json.prefix(3) {  // Limit to the first 3 recommendations
                        if let name = item["name"] as? String,
                           let address = item["address"] as? String,
                           let description = item["description"] as? String,
                           let inquiries = item["inquiries"] as? String,
                           let imageName = item["imageName"] as? String {
                            
                            let recommendation = SeoulList(name: name, address: address, description: description, inquiries: inquiries, imageName: imageName)
                            recommendations.append(recommendation)
                        }
                    }
                    
                    if recommendations.isEmpty {
                        let noRecommendation = SeoulList(name: "추천해드릴 장소가 없어요 😢 \n다른 키워드를 입력해보세요!", address: "", description: "", inquiries: "", imageName: "")
                        recommendations.append(noRecommendation)
                    }
                    
                    DispatchQueue.main.async {
                        self.recommendations = recommendations
                    }
                    completion(.success(recommendations))
                } else {
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
