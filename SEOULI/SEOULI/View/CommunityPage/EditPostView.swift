//
//  EditPostView.swift
//  SEOULI
//
//  Created by 김소리 on 7/2/24.
//

import SwiftUI
import PhotosUI

struct EditPostView: View {
    @Binding var editedTitle: String
    @Binding var editedSubtitle: String
    @Binding var editedContent: String
    @Binding var editedImage: String
    @Environment(\.presentationMode) var presentationMode
    var onSave: () -> Void
    
    @State private var showImagePicker = false
    @State private var image: UIImage? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("제목")) {
                    TextField("제목을 입력하세요", text: $editedTitle)
                }
                
                Section(header: Text("One Liner")) {
                    TextField("One Liner를 입력하세요", text: $editedSubtitle)
                }
                
                Section(header: Text("내용")) {
                    TextField("내용을 입력하세요", text: $editedContent)
                }
                
                Section(header: Text("이미지")) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                    }
                    
                    Button("이미지 선택") {
                        showImagePicker = true
                    }
                }
            }
            .navigationBarTitle("게시물 수정", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("저장") {
                    if let image = image {
                        // 이미지를 저장하고 파일 이름을 editedImage에 저장하는 로직 추가
                        if let imageData = image.jpegData(compressionQuality: 0.8) {
                            let filename = UUID().uuidString + ".jpg"
                            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(filename)
                            try? imageData.write(to: url)
                            editedImage = filename
                        }
                    }
                    onSave()
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .sheet(isPresented: $showImagePicker) {
                PhotoPicker(image: $image)
            }
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
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
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
