import SwiftUI

struct PostWriteView: View {
    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var content: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            TextField("장소명", text: $title)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 0.5))
                .frame(height: 44)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            
            TextField("One Liner", text: $subtitle)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 0.5))
                .frame(height: 44)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            
            ZStack(alignment: .topLeading) {
                if content.isEmpty {
                    Text("내용을 입력하세요")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 10)
                }
                TextEditor(text: $content)
                    .frame(minHeight: 200)
                    .padding(.horizontal, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .opacity(content.isEmpty ? 0.5 : 1.0) // 내용이 비어있을 때 투명도 조절
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            Button(action: {
                // 작성 완료 버튼 동작 구현
                print("작성 완료 버튼 클릭됨")
            }) {
                Text("작성 완료")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
                    .background(Color.theme)
                    .cornerRadius(25)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

struct PostWriteView_Previews: PreviewProvider {
    static var previews: some View {
        PostWriteView()
    }
}

