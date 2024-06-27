import SwiftUI

// Model for Post
struct Post: Identifiable {
    let id = UUID()
    let title: String
    let username: String
    let subtitle: String
    let date: String
}

struct PostListView: View {
    let posts: [Post] = [
        Post(title: "동대문문화원", username: "이휘", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", date: "2024-06-25"),
        Post(title: "동대문문화원", username: "이천영", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", date: "2024-06-25"),
        Post(title: "동대문문화원", username: "리턴영", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", date: "2024-06-24"),
        Post(title: "동대문문화원", username: "그린플럼", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", date: "2024-06-21"),
        Post(title: "동대문문화원", username: "이휘의남자원도현", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", date: "2024-06-19"),
        Post(title: "동대문문화원", username: "이휘", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", date: "2024-06-18")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        ForEach(posts) { post in
                            NavigationLink(destination: PostDetailView(post: post)) {
                                PostCardView(post: post)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle("커뮤니티", displayMode: .inline)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: PostWriteView()) {
                            Text("작성하기")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 100)
                                .frame(height: 50)
                                .background(Color.theme)
                                .cornerRadius(20)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct PostCardView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("작성자: \(post.username)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text(post.subtitle)
                .font(.body)
                .foregroundColor(.primary)
            
            HStack {
                Spacer()
                Text(post.date)
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

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}

