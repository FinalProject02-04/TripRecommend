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
}

// MARK: - PostListView

struct PostListView: View {
    // 데이터 객체 초기화
    @StateObject var postData = PostData()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        ForEach(postData.communities) { post in
                            NavigationLink(destination: PostDetailView(community: post).environmentObject(postData)) {
                                PostCardView(community: post)
                                    .padding(.horizontal)
                                    .onAppear {
                                        increaseViews(for: post)
                                    }
                            }
                        }
                    } // ScrollView
                    
                    Spacer()
                } // VStack
                .padding()
                // 내비게이션 바 타이틀 설정
                .navigationBarTitle("커뮤니티", displayMode: .inline)
                
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                                        
                        NavigationLink(destination: PostWriteView().environmentObject(postData)) {
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
                                } // VStack
                            } // ZStack
                        } // NavigationView
                    }
    
    // 게시물의 조회수를 증가시키는 함수
    func increaseViews(for post: PostModel) {
        if let index = postData.communities.firstIndex(where: { $0.id == post.id }) {
            postData.communities[index].views += 1
        }
    }
}

// MARK: - PostCardView

struct PostCardView: View {
    let community: PostModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 게시물 제목
            Text(community.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // 작성자 정보
            Text("작성자: \(community.username)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            // 게시물 부제목
            Text(community.subtitle)
                .font(.body)
                .foregroundColor(.primary)
            
            HStack {
                Spacer()
                // 게시물 날짜
                Text(community.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            } //HStack
            
            HStack {
                Spacer()
                Text("조회수: \(community.views)")
                    .font(.caption)
                    .foregroundColor(.gray)
            } //HStack
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

#Preview {
    PostListView()
}
