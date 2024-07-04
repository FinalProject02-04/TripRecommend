import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject var postData: PostData
    let community: PostModel
    @State var showingActionSheet = false
    @State var showingEditView = false
    @State var showingDeleteAlert = false
    
    // Use State for editable fields
    @State private var editedTitle: String
    @State private var editedSubtitle: String
    @State private var editedContent: String
    @State private var editedImage: String
    
    init(community: PostModel) {
        self.community = community
        // Initialize State variables with community values
        self._editedTitle = State(initialValue: community.title)
        self._editedSubtitle = State(initialValue: community.subtitle)
        self._editedContent = State(initialValue: community.content)
        self._editedImage = State(initialValue: community.image)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(editedTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text("\(community.date)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(" \(community.username)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 4)
                }
                
                Text("조회수: \(community.views)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(editedSubtitle)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                Text(editedContent)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                if !editedImage.isEmpty {
                    loadImage(named: editedImage)
                        .map {
                            Image(uiImage: $0)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 300)
                                .clipped()
                        }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading) // 추가된 코드
            .padding() // 전체 VStack에 패딩 추가
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
                            showingEditView = true
                        },
                        .destructive(Text("삭제하기")) {
                            showingDeleteAlert = true
                        },
                        .cancel()
                    ])
                }
            )
            .sheet(isPresented: $showingEditView) {
                EditPostView(
                    editedTitle: $editedTitle,
                    editedSubtitle: $editedSubtitle,
                    editedContent: $editedContent,
                    editedImage: $editedImage
                ) {
                    if let index = postData.communities.firstIndex(where: { $0.id == community.id }) {
                        postData.communities[index].title = editedTitle
                        postData.communities[index].subtitle = editedSubtitle
                        postData.communities[index].content = editedContent
                        postData.communities[index].image = editedImage
                    }
                }
            }
            .alert("삭제 확인", isPresented: $showingDeleteAlert, actions: {
                Button("예", role: .destructive, action: {
                    if let index = postData.communities.firstIndex(where: { $0.id == community.id }) {
                        postData.communities.remove(at: index)
                        showingDeleteAlert = false
                    }
                })
                Button("아니요", role: .cancel, action: {
                    showingDeleteAlert = false
                })
            }, message: {
                Text("정말 삭제하시겠습니까?")
            })
        }
    }
    
    func loadImage(named imageName: String) -> UIImage? {
        guard !imageName.isEmpty else { return nil }
        if let uiImage = UIImage(named: imageName) {
            return uiImage
        } else {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentDirectory.appendingPathComponent(imageName)
            return UIImage(contentsOfFile: fileURL.path)
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCommunity = PostModel(id: UUID().uuidString, title: "동대문문화원", username: "이휘", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", content: "친구들과 가족과 함께 동대문문화원을 방문해서 정말 좋았어요. 전통 한국 예술, 공예, 음악, 춤 등을 감상할 수 있는 다양한 문화 행사와 전시회를 즐기며 소중한 시간을 보냈습니다. 다양한 프로그램 덕분에 모두가 재미있게 참여할 수 있었고, 지역 문화와 유산에 대해 많은 것을 배울 수 있었습니다!!!", date: "2024-06-25", image: "동대문문화원.jpg", views: 0)
        return PostDetailView(community: sampleCommunity).environmentObject(PostData())
    }
}

