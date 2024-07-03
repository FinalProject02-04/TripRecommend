import SwiftUI
import PhotosUI

struct PostWriteView: View {
    @State var title: String = ""
    @State var subtitle: String = ""
    @State var content: String = ""
    @FocusState var isTextFieldFocused: Bool
    
    @State var selectedImage: UIImage?
    @State var showImagePicker = false
    
    @State var selectedFileNameForAttachment: String = ""
    
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var postData: PostData // PostData 객체 가져오기
    
    let postVM = PostVM()
    @State private var navigateToPostList = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                TextField("장소명", text: $title)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 0.5))
                    .frame(height: 44)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .focused($isTextFieldFocused)
                
                TextField("One Liner", text: $subtitle)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 0.5))
                    .frame(height: 44)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .focused($isTextFieldFocused)
                
                ZStack(alignment: .topLeading) {
                    if content.isEmpty {
                        Text("내용을 입력하세요")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                    }
                    TextEditor(text: $content)
                        .frame(height: 300)
                        .padding(.horizontal, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .focused($isTextFieldFocused)
                        .opacity(content.isEmpty ? 0.5 : 1.0)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                HStack(spacing: 10) {
                    TextField("첨부파일", text: $selectedFileNameForAttachment)
                        .disabled(true)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 0.5))
                        .frame(height: 44)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .focused($isTextFieldFocused)
                    
                    Button(action: {
                        self.showImagePicker.toggle()
                    }) {
                        Text("첨부파일")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                Button(action: {
                    if validateFields() {
                        if let selectedFileName = URL(string: selectedFileNameForAttachment)?.lastPathComponent {
                            postVM.addPostWithFileName(title: title, subtitle: subtitle, content: content, fileName: selectedFileName) { error in
                                if let error = error {
                                    showAlert = true
                                    alertMessage = "게시물 저장 중 오류가 발생했습니다: \(error.localizedDescription)"
                                } else {
                                    showAlert = true
                                    alertMessage = "게시물이 성공적으로 추가되었습니다."
                                    title = ""
                                    subtitle = ""
                                    content = ""
                                    selectedFileNameForAttachment = ""
                                    navigateToPostList = true  // Set to true to trigger navigation
                                }
                            }
                        } else {
                            showAlert = true
                            alertMessage = "첨부 파일명을 가져오지 못했습니다."
                        }
                    } else {
                        showAlert = true
                        alertMessage = "장소명과 One Liner를 모두 입력해주세요."
                    }
                }) {
                    Text("작성완료")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인")) {
                        }
                    )
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("")
            .navigationBarItems(trailing: NavigationLink(destination: PostListView(), isActive: $navigateToPostList) {
                EmptyView()
            })
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, selectedFileName: $selectedFileNameForAttachment)
            }
        }
    }
    
    func validateFields() -> Bool {
        return !title.isEmpty && !subtitle.isEmpty
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var selectedFileName: String

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        if let uiImage = image as? UIImage {
                            self.parent.selectedImage = uiImage
                            self.parent.selectedFileName = provider.suggestedName ?? "Unknown"
                        } else {
                            print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
            } else {
                print("Provider cannot load image")
            }
        }

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}

