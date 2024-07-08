import SwiftUI
import PhotosUI

struct EditPostView: View {
    @Binding var editedTitle: String
    @Binding var editedSubtitle: String
    @Binding var editedContent: String
    @Binding var editedImage: String

    @Binding var community: PostModel

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var postData: PostData
    @ObservedObject var postVM: PostVM

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var showingDeleteAlert = false

    var onSave: () -> Void
    var onDelete: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("제목")) {
                    TextField("제목 입력", text: $editedTitle)
                }

                Section(header: Text("부제목")) {
                    TextField("부제목 입력", text: $editedSubtitle)
                }

                Section(header: Text("내용")) {
                    TextEditor(text: $editedContent)
                }

                Section(header: Text("이미지")) {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("갤러리에서 이미지 선택")
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                    if let data = selectedImageData, let uiImage = UIImage(data: data) {
                                        saveImageToDocumentsDirectory(uiImage)
                                        editedImage = "selectedImage.jpg"
                                    }
                                }
                            }
                        }
                    if let data = selectedImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else if !editedImage.isEmpty {
                        loadImage(named: editedImage)
                            .map {
                                Image(uiImage: $0)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            }
                    }
                }
            }
            .navigationBarTitle("게시물 수정", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss() // 취소 버튼 추가 및 닫기 기능
            }) {
                Text("취소")
                    .foregroundColor(.blue) // 원하는 색상으로 수정 가능
            }, trailing: Button(action: {
                community.title = editedTitle
                community.subtitle = editedSubtitle
                community.content = editedContent
                community.image = editedImage
                postVM.updatePost(post: community) { error in
                    if let error = error {
                        print("게시물 업데이트 오류: \(error.localizedDescription)")
                    } else {
                        onSave()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Text("저장")
            })
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("삭제 확인"),
                    message: Text("정말 삭제하시겠습니까?"),
                    primaryButton: .destructive(Text("삭제")) {
                        postVM.deletePost(post: community) { error in
                            if let error = error {
                                print("게시물 삭제 오류: \(error.localizedDescription)")
                            } else {
                                onDelete()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    func saveImageToDocumentsDirectory(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        let filename = getDocumentsDirectory().appendingPathComponent("selectedImage.jpg")
        try? data.write(to: filename)
    }

    func loadImage(named imageName: String) -> UIImage? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: fileURL.path)
    }

    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

