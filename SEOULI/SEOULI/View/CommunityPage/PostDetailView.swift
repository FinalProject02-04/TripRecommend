import SwiftUI

struct PostDetailView: View {
    let post: Post
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(post.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("\(post.username) | \(post.date)")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                    }
                }
                
                Text(post.subtitle)
                    .font(.body)
                
                Text("친구들과 가족과 함께 동대문문화원을 방문해서 정말 좋았어요. 전통 한국 예술, 공예, 음악, 춤 등을 감상할 수 있는 다양한 문화 행사와 전시회를 즐기며 소중한 시간을 보냈습니다. 다양한 프로그램 덕분에 모두가 재미있게 참여할 수 있었고, 지역 문화와 유산에 대해 많은 것을 배울 수 있었습니다!!!")
                    
                    Image("동대문문화원")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 300)
                    
                    Spacer()
                }
                .navigationBarTitle("커뮤니티", displayMode: .inline)
                .padding()
            }
        }
    }

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = Post(title: "동대문문화원", username: "이휘", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", date: "2024-06-25")
        return PostDetailView(post: samplePost)
    }
}

