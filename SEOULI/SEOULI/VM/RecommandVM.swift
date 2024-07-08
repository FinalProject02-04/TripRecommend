//
//  RecommandVM.swift
//  SEOULI
//
//  Created by 김수민 on 7/3/24.
//

import SwiftUI


class NetworkManager: ObservableObject {
    // Allows the UI to update when recommendations change
    @Published var recommendations: [SeoulList] = []
    // Message to display when no recommendations are found
    @Published var norecmessage: String = ""
    
    // fetch recommendation function when the user sends a message
    func fetchRecommendations(for input: String, completion: @escaping (Result<[SeoulList], Error>) -> Void) {
        // Encoding the input to be URL safe
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
            
            // Ensuring data is not nil
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                // Attempting to serialize JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    
                    // Array to hold recommendation results**
                    var recommendations: [SeoulList] = []
                    
                    // Iterating over the first 3 items in the JSON response
                    for item in json.prefix(3) {
                        
                        // Extracting values from the JSON object
                        if let name = item["name"] as? String,
                           let address = item["address"] as? String,
                           let description = item["description"] as? String,
                           let inquiries = item["inquiries"] as? String,
                           let imageName = item["imageName"] as? String {
                            
                            // Creating a SeoulList object and appending to the recommendations array
                            let recommendation = SeoulList(name: name, address: address, description: description, inquiries: inquiries, imageName: imageName)
                            recommendations.append(recommendation)
                        }
                    }
                    
                    // If no recommendations are found, update norecmessage and clear recommendations
                    if recommendations.isEmpty {
                        let noRecommendation = "추천해드릴 장소가 없어요 😢 \n다른 키워드를 입력해보세요!"
                        self.norecmessage = noRecommendation
                        
                        // Updating the published properties on the main thread
                        DispatchQueue.main.async {
                            self.recommendations = []
                            self.norecmessage = noRecommendation
                        }
                    } else {
                        
                        // Updating the recommendations and clearing norecmessage on the main thread
                        DispatchQueue.main.async {
                            self.recommendations = recommendations
                            self.norecmessage = ""
                        }
                    }
                    
                    // Returning the recommendations via the completion handler
                    completion(.success(recommendations))
                } else {
                    // Returning a parsing error if JSON structure is not as expected
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
