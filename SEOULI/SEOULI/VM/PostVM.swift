import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class PostVM: ObservableObject {
    @Published var posts: [PostModel] = []
    private var db = Firestore.firestore()
    private let storage = Storage.storage()
    
    init() {
        fetchPosts()
    }
    
    func addPost(title: String, subtitle: String, content: String, image: String, username: String, completion: @escaping (Error?) -> Void) {
        let newPost = PostModel(title: title, username: username, subtitle: subtitle, content: content, date: getCurrentDate(), image: image)
        
        do {
            try db.collection("posts").document(newPost.id).setData(from: newPost) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                    completion(error)
                } else {
                    self.posts.append(newPost)
                    completion(nil)
                }
            }
        } catch let error {
            print("Error writing post to Firestore: \(error)")
            completion(error)
        }
    }
    
    func updatePost(post: PostModel, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection("posts").document(post.id).setData(from: post) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                    completion(error)
                } else {
                    if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                        self.posts[index] = post
                    }
                    print("Post updated in Firestore successfully!")
                    completion(nil)
                }
            }
        } catch let error {
            print("Error writing post to Firestore: \(error)")
            completion(error)
        }
    }

    func deletePost(post: PostModel, completion: @escaping (Error?) -> Void) {
        db.collection("posts").document(post.id).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
                completion(error)
            } else {
                if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                    self.posts.remove(at: index)
                }
                print("Post deleted from Firestore successfully!")
                completion(nil)
            }
        }
    }
    
    func fetchPosts() {
        db.collection("posts").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.posts = documents.compactMap { queryDocumentSnapshot -> PostModel? in
                return try? queryDocumentSnapshot.data(as: PostModel.self)
            }.sorted(by: { $0.dateValue ?? Date.distantPast > $1.dateValue ?? Date.distantPast })
        }
    }
    
    // 이미지를 Firebase Storage에 업로드하고 URL을 반환하는 함수
    func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(PostError.invalidImageData))
            return
        }
        
        let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }

    // 게시물 이미지 URL을 업데이트하는 함수
    func updatePostImage(post: PostModel, imageUrl: String, completion: @escaping (Error?) -> Void) {
        var updatedPost = post
        updatedPost.image = imageUrl
        
        do {
            try db.collection("posts").document(post.id).setData(from: updatedPost) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                    completion(error)
                } else {
                    if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                        self.posts[index] = updatedPost
                    }
                    print("Post updated with image URL successfully!")
                    completion(nil)
                }
            }
        } catch let error {
            print("Error writing post to Firestore: \(error)")
            completion(error)
        }
    }
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

enum PostError: Error {
    case invalidImageData
}

