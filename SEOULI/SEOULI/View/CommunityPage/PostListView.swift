import SwiftUI
import PhotosUI
import Combine

// MARK: - PostData

class PostData: ObservableObject {
    @Published var communities: [PostModel] = []
    
    func addPost(post: PostModel) {
        communities.append(post)
    }
}

// MARK: - PostListView

struct PostListView: View {
    @StateObject var postVM = PostVM()
    @EnvironmentObject var postData: PostData
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background Color") // Set the background color
                    .edgesIgnoringSafeArea(.all) // Extend the background color to the edges
                
                List {
                    ForEach(postVM.posts) { post in
                        ZStack {
                            PostCardView(community: post)
                                .listRowInsets(EdgeInsets()) // Remove default list row insets
                            
                            NavigationLink(destination: PostDetailView(community: post).environmentObject(postData)) {
                                EmptyView()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .background(Color.clear) // Set background to clear to avoid additional coloring
                        .listRowBackground(Color("Background Color")) // Match background color
                    }
                    .onDelete { indices in
                        indices.forEach { index in
                            let postToDelete = postVM.posts[index]
                            postVM.deletePost(post: postToDelete) { error in
                                if let error = error {
                                    print("게시물 삭제 오류: \(error.localizedDescription)")
                                } else {
                                    postData.communities.removeAll(where: { $0.id == postToDelete.id })
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle()) // Use plain list style to avoid default styles
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: PostWriteView().environmentObject(postVM)) {
                            Image(systemName: "pencil")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.theme)
                                .cornerRadius(25)
                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Community", displayMode: .inline)
            .onAppear {
                postVM.fetchPosts() // Ensure the list is updated on appearance
            }
        }
    }
}

struct PostCardView: View {
    let community: PostModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(community.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text("By: \(community.username)") // Display the username
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            Text(community.subtitle)
                .font(.body)
                .foregroundColor(.primary)

            HStack {
                Spacer()
                Text("Date: \(community.date)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
        )
        .padding(.vertical, 4) // Adjust vertical padding to space out cards
    }
}
