import SwiftUI

struct PostDetailView: View {
    let community: PostModel
    
    @State private var showingActionSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(community.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading, 10) // Add padding to align with navigation bar items
                    
                    Spacer()
                }
                
                HStack {
                    Text("\(community.username) | \(community.date)")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                        .padding(.leading, 10) // Add padding to align with navigation bar items
                    
                    Spacer()
                }
                
                Text(community.subtitle)
                    .font(.body)
                
                Text(community.content)
                    .font(.body)
                
                if let uiImage = loadImage(named: community.image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 300)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("커뮤니티", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                showingActionSheet = true
            }) {
                Image(systemName: "ellipsis.circle")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("게시물 관리"), message: nil, buttons: [
                    .default(Text("수정하기")) {
                        editPost()
                    },
                    .destructive(Text("삭제하기")) {
                        deletePost()
                    },
                    .cancel()
                ])
            }
        )
    }
    
    // 이미지 로드 함수
    func loadImage(named imageName: String) -> UIImage? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    // 게시물 수정 함수 (예시)
    func editPost() {
        // 수정 로직을 구현합니다.
        print("수정하기")
    }
    
    // 게시물 삭제 함수 (예시)
    func deletePost() {
        // 삭제 로직을 구현합니다.
        print("삭제하기")
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCommunity = PostModel(title: "동대문문화원", username: "이휘", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", content: "친구들과 가족과 함께 동대문문화원을 방문해서 정말 좋았어요. 전통 한국 예술, 공예, 음악, 춤 등을 감상할 수 있는 다양한 문화 행사와 전시회를 즐기며 소중한 시간을 보냈습니다. 다양한 프로그램 덕분에 모두가 재미있게 참여할 수 있었고, 지역 문화와 유산에 대해 많은 것을 배울 수 있었습니다!!!", date: "2024-06-25", image: "동대문문화원.jpg")
        return PostDetailView(community: sampleCommunity)
    }
}

