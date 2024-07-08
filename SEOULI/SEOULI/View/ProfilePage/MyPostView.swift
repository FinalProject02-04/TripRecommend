import SwiftUI

struct MyPostView: View {
    
    @StateObject private var postVM = PostVM()
    @State private var userNickname: String = ""
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color("Background Color")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(filteredPosts()) { post in
                            NavigationLink(destination: PostDetailView(community: post)) {
                                MyPostCard(post: post)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color("Background Color"))
                .padding(.top, 60)
            }
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("나의 게시물")
                        .bold()
                        .foregroundColor(Color("Text Color"))
                        .font(.title)
                }
            })
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // 사용자의 닉네임을 UserDefaults에서 가져옴
            if let nickname = UserDefaults.standard.string(forKey: "userNickname") {
                self.userNickname = nickname
            }
            
            // 게시물 데이터를 가져옴
            postVM.fetchPosts()
        }
    }
    
    // 사용자가 작성한 게시물만 필터링하여 반환
    private func filteredPosts() -> [PostModel] {
        return postVM.posts.filter { $0.username == userNickname }
    }
}

struct MyPostCard: View {
    var post: PostModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("By: \(post.username)") // Display the username
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text(post.subtitle)
                .font(.body)
                .foregroundColor(.primary)
            
            HStack {
                Spacer()
                Text("Date: \(post.date)")
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
        .padding(.horizontal) // 추가: 수평 패딩
    }
}

struct MyPostView_Previews: PreviewProvider {
    static var previews: some View {
        MyPostView()
    }
}

