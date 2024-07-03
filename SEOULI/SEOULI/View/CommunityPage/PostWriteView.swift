/*
 Author : 이 서
 
 Date : 2024.06.27 Thursday
 Description : 1차 UI frame 작업
 
 */

import SwiftUI
import PhotosUI

struct PostWriteView: View {
    @State var title: String = ""
    @State var subtitle: String = ""
    @State var content: String = ""
    @FocusState var isTextFieldFocused: Bool
    
    @State var selectedImage: UIImage?
    @State var showImagePicker = false
    
    // 첨부파일 버튼용 상태
    @State var selectedFileNameForAttachment: String = ""
    // 작성완료 버튼용 상태
    @State var selectedFileNameForCompletion: String = ""
    
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    @EnvironmentObject var postData: PostData
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                Spacer()
                
                // 장소명 TextField
                TextField("장소명", text: $title)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 0.5))
                    .frame(height: 44)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .focused($isTextFieldFocused)
                
                // One Liner TextField
                TextField("One Liner", text: $subtitle)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 0.5))
                    .frame(height: 44)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .focused($isTextFieldFocused)
                
                
                ZStack(alignment: .topLeading) {
                    // Content TextEditor
                    if content.isEmpty {
                        Text("내용을 입력하세요")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                    }
                    TextEditor(text: $content)
                        .frame(height: 300) // TextEditor 높이 수정
                        .padding(.horizontal, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .focused($isTextFieldFocused)
                        .opacity(content.isEmpty ? 0.5 : 1.0)
                } // ZStack
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                HStack(spacing: 10) {
                    // 첨부파일 TextField
                    TextField("첨부파일", text: $selectedFileNameForAttachment)
                        .disabled(true)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 0.5))
                        .frame(height: 44)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .focused($isTextFieldFocused)
                    
                    // 첨부파일 button
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
                } //HStack
                
                Button(action: {
                    if validateFields() {
                        if let savedImagePath = saveImage(selectedImage) {
                            let newPost = PostModel(
                                title: title,
                                username: "User",
                                subtitle: subtitle,
                                content: content,
                                date: getCurrentDate(),
                                image: savedImagePath, 
                                views: 0
                            )
                            postData.communities.append(newPost)
                            showAlert = true
                            alertMessage = "게시물이 성공적으로 추가되었습니다."
                        } else {
                            showAlert = true
                            alertMessage = "이미지 저장에 실패했습니다."
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
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
                
                Spacer()
            } // VStack
            .padding()
            .navigationBarTitle("")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, selectedFileName: $selectedFileNameForAttachment)
            } //sheet
        } //navigationview
    } //body
    
    func validateFields() -> Bool {
        return !title.isEmpty && !subtitle.isEmpty
    }
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    func saveImage(_ image: UIImage?) -> String? {
        guard let image = image else { return nil }
        let imageData = image.jpegData(compressionQuality: 1.0)
        let fileName = UUID().uuidString + ".jpg"
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData?.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
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

            provider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    if let uiImage = image as? UIImage {
                        self.parent.selectedImage = uiImage
                        self.parent.selectedFileName = provider.suggestedName ?? "Unknown"
                    }
                }
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


