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
        ZStack {
            Color("Background Color") // 배경색 설정
                .ignoresSafeArea() // Safe Area를 무시하고 배경색이 전체 화면에 적용되도록 함
            
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
                    
                    if !editedImage.isEmpty, let url = URL(string: editedImage) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 350, height: 300)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 350, height: 300)
                            case .failure:
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 350, height: 300)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 300)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.clear) // 배경색 설정
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing:
            Group {
                if UserDefaults.standard.string(forKey: "userNickname") == community.username {
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
                                showingEditView = true // 수정 화면을 표시하거나 다른 처리를 수행
                            },
                            .destructive(Text("삭제하기")) {
                                showingDeleteAlert = true
                            },
                            .cancel()
                        ])
                    }
                }
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

