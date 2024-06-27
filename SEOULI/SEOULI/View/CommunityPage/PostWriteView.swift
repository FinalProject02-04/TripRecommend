//
//  PostWriteView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI

struct PostWriteView: View {
    @Binding var posts: [PostListView.Post]
    @State var title: String = ""
    @State var subtitle: String = ""
    @State var content: String = ""
    @State var fileName: String = ""
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""

    var body: some View {
        VStack {
            Text("작성")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            TextField("장소명", text: $title)
                .font(.system(size: 18))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .keyboardType(.default)

            TextField("One Liner", text: $subtitle)
                .font(.system(size: 18))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .keyboardType(.default)

            TextEditor(text: $content)
                .font(.system(size: 18))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .keyboardType(.default)

            HStack {
                TextField("파일명", text: $fileName)
                    .font(.system(size: 18))
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .keyboardType(.default)
                    .disabled(true)

                Button(action: {
                    // 첨부하기 버튼 동작 구현
                }) {
                    Text("첨부하기")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 100, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }

            Spacer()

            Button(action: {
                if title.isEmpty && subtitle.isEmpty {
                    showAlert = true
                    alertMessage = "장소명과 One Liner를 모두 입력해주세요"
                } else if title.isEmpty {
                    showAlert = true
                    alertMessage = "장소명을 입력하지 않았습니다."
                } else if subtitle.isEmpty {
                    showAlert = true
                    alertMessage = "One Liner를 입력하지 않았습니다."
                } else {
                    let newPost = PostListView.Post(title: title, subtitle: subtitle)
                    posts.append(newPost)
                }
            }) {
                Text("작성완료")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 100, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
        }
        .padding()
    }
}

#Preview {
    PostWriteView(posts: .constant([]))
}
