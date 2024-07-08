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
                Color("Background Color") // 배경 색상 설정
                    .edgesIgnoringSafeArea(.all) // 배경 색상을 화면 끝까지 확장
                
                List {
                    ForEach(postVM.posts) { post in
                        ZStack {
                            PostCardView(community: post)
                                .listRowInsets(EdgeInsets()) // 기본 리스트 행의 인세트 제거
                                .background(NavigationLink(destination: PostDetailView(community: post).environmentObject(postData)) {
                                    EmptyView()
                                }
                                .buttonStyle(PlainButtonStyle())
                                .opacity(0)) // 링크의 불투명도를 0으로 설정
                        }
                        .background(Color.clear) // 추가 색상을 피하기 위해 배경을 투명으로 설정
                        .listRowBackground(Color("Background Color")) // 배경 색상과 맞춤
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
                .listStyle(PlainListStyle()) // 기본 스타일을 피하기 위해 평범한 리스트 스타일 사용
                
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
            .navigationBarTitle("", displayMode: .inline)
            .onAppear {
                postVM.fetchPosts() // 리스트가 나타날 때 업데이트 되도록 설정
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
                .foregroundColor(Color("Text Color"))

            Text("By: \(community.username)") // 사용자 이름 표시
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color("Text Color"))

            Text(community.subtitle)
                .font(.body)
                .foregroundColor(Color("Text Color"))

            HStack {
                Spacer()
                Text("Date: \(community.date)")
                    .font(.caption)
                    .foregroundColor(Color("Text Color")) 
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
        )
        .padding(.vertical, 4) // 카드 간격 조정을 위한 세로 여백 조정
    }
}


