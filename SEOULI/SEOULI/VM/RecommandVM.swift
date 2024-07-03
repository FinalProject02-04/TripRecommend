//
//  RecommandVM.swift
//  SEOULI
//
//  Created by 김수민 on 7/3/24.
//

import Foundation

class NetworkManager: ObservableObject {
    @Published var recommendations: [String] = []
    
    func fetchRecommendations(for input: String, completion: @escaping (Result<[String], Error>) -> Void) {
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
                    var recommendations: [String] = []
                    
                    for item in json.prefix(3) {  // Limit to the first 3 recommendations
                        if let name = item["name"] as? String, let address = item["address"] as? String {
                            let recommendation = """
                                장소명:   \(name)
                                주소📍  \(address)
                                
                                """
                            recommendations.append(recommendation)
                        }
                    }
                    
                    if recommendations.isEmpty {
                        recommendations.append("추천해드릴 장소가 없어요 😢 \n다른 키워드를 입력해보세요!")
                    } else {
                        // Placeholder text that does not change
                        let introText = "제가 추천해드리는 장소는.. \n"
                        recommendations.insert(introText, at: 0)
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
