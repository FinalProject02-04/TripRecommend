import SwiftUI
import PhotosUI

// ObservableObject를 사용하여 데이터 관리
class PostData: ObservableObject {
    @Published var communities: [PostModel] = []
}

struct PostListView: View {
    @StateObject var postData = PostData() // 데이터 객체 초기화
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        ForEach(postData.communities) { post in
                            NavigationLink(destination: PostDetailView(community: post)) {
                                PostCardView(community: post)
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
                    NavigationLink(destination: PostWriteView().environmentObject(postData)) { // 환경 객체로 전달
                        Text("작성하기")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                    .padding()
                }
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
            
            Text("작성자: \(community.username)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text(community.subtitle)
                .font(.body)
                .foregroundColor(.primary)
            
            HStack {
                Spacer()
                Text(community.date)
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
