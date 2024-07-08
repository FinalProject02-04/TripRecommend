import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class PostVM: ObservableObject {
    @Published var posts: [PostModel] = []
    private var db = Firestore.firestore()
    
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
            }
        }
    }

    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

