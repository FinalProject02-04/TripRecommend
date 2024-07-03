import Foundation
import Firebase
import FirebaseFirestore

struct PostVM {
    let db = Firestore.firestore()
    
    func addPostWithFileName(title: String, subtitle: String, content: String, fileName: String, completion: @escaping (Error?) -> Void) {
        var newPostData: [String: Any] = [
            "title": title,
            "subtitle": subtitle,
            "content": content,
            "imageFileName": fileName, // Change this to the appropriate field name in your Firestore schema
            "ins_date": getCurrentDate()
        ]
        
        savePostData(newPostData, completion: completion)
    }

    func savePostData(_ data: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("posts").addDocument(data: data) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

