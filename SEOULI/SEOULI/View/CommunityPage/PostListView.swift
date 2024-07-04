/*
 Author : 이 서
 
 Date : 2024.06.27 Thursday
 Description : 1차 UI frame 작업
 
 */


import SwiftUI
import PhotosUI


// MARK: - PostData

// ObservableObject를 사용하여 데이터 관리
class PostData: ObservableObject {
    @Published var communities: [PostModel] = []
    
    func addPost(post: PostModel) {
        communities.append(post)
    }
}

// MARK: - PostListView

struct PostListView: View {
    @StateObject var postVM = PostVM()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        ForEach(postVM.posts) { post in
                            NavigationLink(destination: PostDetailView(community: post)) {
                                PostCardView(community: post)
                                    .padding(.horizontal)
                                    .onAppear {
                                        increaseViews(for: post)
                                    }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle("Community", displayMode: .inline)
                
                VStack {
                    Spacer()
                    
                    NavigationLink(destination: PostWriteView().environmentObject(postVM)) {
                        Image(systemName: "pencil")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(25)
                            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    }
                    .padding()
                }
            }
        }
    }
    
    private func increaseViews(for post: PostModel) {
        // This function needs implementation if views need to be updated in Firestore as well.
        if let index = postVM.posts.firstIndex(where: { $0.id == post.id }) {
            postVM.posts[index].views += 1
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
            
            Text("By: \(community.username)")
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
            
            HStack {
                Spacer()
                Text("Views: \(community.views)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
        .padding(.bottom)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.clear, lineWidth: 1)
                .padding(.horizontal, -10)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}
