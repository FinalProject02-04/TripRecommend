import SwiftUI
import PhotosUI

struct PostWriteView: View {
    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var content: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var selectedFileNameForAttachment: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var postVM: PostVM

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()

                TextField("장소명", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 44)
                    .padding(.horizontal)

                TextField("One Liner", text: $subtitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 44)
                    .padding(.horizontal)

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
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)

                HStack(spacing: 10) {
                    TextField("첨부파일", text: $selectedFileNameForAttachment)
                        .disabled(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 44)
                        .padding(.horizontal)

                    Button(action: {
                        self.showImagePicker.toggle()
                    }) {
                        Text("첨부파일 선택")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.theme)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $selectedImage, selectedFileName: $selectedFileNameForAttachment)
                    }
                }

                HStack {
                    Spacer()
                    Button(action: {
                        if validateFields() {
                            // Get the username from UserDefaults
                            let username = UserDefaults.standard.string(forKey: "userNickname") ?? "Unknown User"
                            postVM.addPost(title: title, subtitle: subtitle, content: content, image: selectedFileNameForAttachment, username: username) { error in
                                if let error = error {
                                    showAlert = true
                                    alertMessage = "게시물 저장 중 오류가 발생했습니다: \(error.localizedDescription)"
                                } else {
                                    showAlert = true
                                    alertMessage = "게시물이 성공적으로 추가되었습니다."
                                    presentationMode.wrappedValue.dismiss()
                                }
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
                            .background(Color.theme)
                            .cornerRadius(20)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인"))
                    )
                }

                Spacer()
            }
            .padding()
        }
    }

    private func validateFields() -> Bool {
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
                        if let image = image as? UIImage {
                            self.parent.selectedImage = image
                            // 이미지 파일명을 생성하고 저장
                            self.parent.selectedFileName = UUID().uuidString + ".jpg"
                            self.saveImage(image: image, fileName: self.parent.selectedFileName)
                        }
                    }
                }
            }
        }
        
        private func saveImage(image: UIImage, fileName: String) {
            if let data = image.jpegData(compressionQuality: 0.8) {
                let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = directory.appendingPathComponent(fileName)
                try? data.write(to: fileURL)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}

