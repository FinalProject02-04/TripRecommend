import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject var postData: PostData
    @ObservedObject var postVM = PostVM()
    
    @State var community: PostModel
    
    @State private var editedTitle: String
    @State private var editedSubtitle: String
    @State private var editedContent: String
    @State private var editedImage: String
    
    @State private var showingActionSheet = false
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @Environment(\.presentationMode) var presentationMode // Environment variable to control navigation
    
    init(community: PostModel) {
        self._community = State(initialValue: community)
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
                        .foregroundColor(Color("Text Color")) // 사용자 지정 텍스트 색상 사용
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
                
                Text(editedSubtitle)
                    .font(.body)
                    .foregroundColor(Color("Text Color")) // 사용자 지정 텍스트 색상 사용
                    .multilineTextAlignment(.leading)
                
                Text(editedContent)
                    .font(.body)
                    .foregroundColor(Color("Text Color")) // 사용자 지정 텍스트 색상 사용
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color("Background Color")) // 배경색 설정
            .ignoresSafeArea()
            .navigationBarTitle("", displayMode: .inline)
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
                            // 사용자 권한 확인
                            if UserDefaults.standard.string(forKey: "userNickname") == community.username {
                                // 수정하기 버튼을 누른 경우의 처리
                                showingEditView = true // 수정 화면을 표시하거나 다른 처리를 수행
                            } else {
                                // 사용자에게 권한이 없음을 알리는 처리
                                // 예를 들어 경고창을 표시하거나 다른 방법으로 처리
                            }
                        },
                        .destructive(Text("삭제하기")) {
                            // 사용자 권한 확인
                            if UserDefaults.standard.string(forKey: "userNickname") == community.username {
                                showingDeleteAlert = true
                            } else {
                                // 사용자에게 권한이 없음을 알리는 처리
                                // 예를 들어 경고창을 표시하거나 다른 방법으로 처리
                            }
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
                    editedImage: $editedImage,
                    community: $community,
                    postVM: postVM
                ) {
                    if let index = postData.communities.firstIndex(where: { $0.id == community.id }) {
                        let updatedPost = PostModel(
                            id: community.id,
                            title: editedTitle,
                            username: community.username,
                            subtitle: editedSubtitle,
                            content: editedContent,
                            date: community.date,
                            image: editedImage
                        )
                        postData.communities[index] = updatedPost
                        
                        postVM.updatePost(post: updatedPost) { error in
                            if let error = error {
                                print("게시물 업데이트 오류: \(error.localizedDescription)")
                            } else {
                                print("게시물이 성공적으로 업데이트되었습니다!")
                                community = updatedPost
                            }
                        }
                    }
                } onDelete: {
                    if let index = postData.communities.firstIndex(where: { $0.id == community.id }) {
                        postData.communities.remove(at: index)
                        presentationMode.wrappedValue.dismiss() // Navigate back to list
                    }
                }
                .environmentObject(postData)
            }
            .alert("삭제 확인", isPresented: $showingDeleteAlert, actions: {
                Button("확인", role: .destructive, action: {
                    postVM.deletePost(post: community) { error in
                        if let error = error {
                            print("게시물 삭제 오류: \(error.localizedDescription)")
                        } else {
                            if let index = postData.communities.firstIndex(where: { $0.id == community.id }) {
                                postData.communities.remove(at: index)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                })
                Button("취소", role: .cancel, action: {
                    showingDeleteAlert = false
                })
            }, message: {
                Text("정말 삭제하시겠습니까?")
            })
            .onChange(of: showingDeleteAlert) { showAlert in
                if !showAlert {
                    presentationMode.wrappedValue.dismiss() // Dismiss the sheet when the alert is dismissed
                }
            }
        }
    }
    
    func loadImage(named imageName: String) -> UIImage? {
        guard !imageName.isEmpty else { return nil }
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: fileURL.path)
    }
}

