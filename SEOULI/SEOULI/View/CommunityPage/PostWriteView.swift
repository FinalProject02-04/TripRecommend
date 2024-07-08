import SwiftUI
import FirebaseStorage

struct PostWriteView: View {
    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var content: String = ""
    @State private var selectedImage: UIImage?
    @State private var selectedImageURL: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var postVM: PostVM
    @FocusState private var isInputActive: Bool
    @State private var showImagePicker: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Spacer()

                        TextField("Title", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 44)
                            .padding(.horizontal)
                            .focused($isInputActive)

                        TextField("Subtitle", text: $subtitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 44)
                            .padding(.horizontal)
                            .focused($isInputActive)

                        ZStack(alignment: .topLeading) {
                            if content.isEmpty {
                                Text("Enter content here")
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
                                .focused($isInputActive)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)

                        HStack(spacing: 10) {
                            TextField("Attachment", text: $selectedImageURL)
                                .disabled(true)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 44)
                                .padding(.horizontal)

                            Button(action: {
                                self.showImagePicker.toggle()
                            }) {
                                Text("Select Image")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.theme)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(selectedImage: $selectedImage, selectedImageURL: $selectedImageURL)
                            }
                        }

                        HStack {
                            Spacer()
                            Button(action: {
                                if validateFields() {
                                    uploadImageAndSavePost()
                                } else {
                                    showAlert(message: "Please fill in Title and Subtitle.")
                                }
                            }) {
                                Text("Post")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 200)
                                    .background(Color.theme)
                                    .cornerRadius(20)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)

                        Spacer()
                    }
                    .padding()
                }
                .background(Color("Background Color").ignoresSafeArea())
                .onTapGesture {
                    self.isInputActive = false
                }
                .navigationBarTitle("", displayMode: .inline)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Alert"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    func validateFields() -> Bool {
        return !title.isEmpty && !subtitle.isEmpty
    }

    func uploadImageAndSavePost() {
        guard let selectedImage = selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            self.showAlert(message: "Selected image is nil or cannot be converted to JPEG data.")
            return
        }

        let fileName = UUID().uuidString + ".jpg"

        // Firebase Storage에 이미지 업로드
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(fileName)")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                self.showAlert(message: "Image upload error: \(error.localizedDescription)")
            } else {
                // 이미지 업로드 성공 후 다운로드 URL 가져오기
                imageRef.downloadURL { url, error in
                    if let error = error {
                        self.showAlert(message: "Failed to retrieve download URL: \(error.localizedDescription)")
                    } else if let url = url {
                        self.selectedImageURL = url.absoluteString
                        self.savePostToFirestore()
                    } else {
                        self.showAlert(message: "Unknown error occurred while retrieving download URL.")
                    }
                }
            }
        }
    }

    func savePostToFirestore() {
        // UserDefaults에서 닉네임 가져오기
        let username = UserDefaults.standard.string(forKey: "userNickname") ?? "Unknown User"

        postVM.addPost(title: title, subtitle: subtitle, content: content, image: selectedImageURL, username: username) { error in
            if let error = error {
                self.showAlert(message: "Error saving post: \(error.localizedDescription)")
            } else {
                self.alertMessage = "Post successfully added."
                self.showAlert = true
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func showAlert(message: String) {
        self.alertMessage = message
        self.showAlert = true
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var selectedImageURL: String

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
                parent.selectedImageURL = "Finish" // 업로드 중일 때의 임시 텍스트
            }

            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct PostWriteView_Previews: PreviewProvider {
    static var previews: some View {
        PostWriteView()
    }
}

