//
//  PostListView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI

struct PostListView: View {
    @State var posts: [Post] = []
    
struct Post: Identifiable {
        let id = UUID()
        var title: String
        var subtitle: String
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("커뮤니티")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    List(posts) { post in
                        VStack(alignment: .leading) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.subtitle)
                                .font(.subheadline)
                                }
                            }
                            .listStyle(PlainListStyle())
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        // Button
                        NavigationLink(destination: PostWriteView(posts: $posts)) {
                            Text("작성하기")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("Theme Color"))
                                .cornerRadius(30)
                        }
                    }
                    .padding()
                }
            }
            //            VStack {
            //                Spacer()
            //                HStack {
            //                    Spacer()
            //                    Button(action: {
            //                    // 작성하기 버튼 클릭 시 수행할 작업
            //                                }) {
            //                    Image(systemName: "pencil")
            //                        .font(.system(size: 24))
            //                        .foregroundColor(.white)
            //                        .padding()
            //                        .background(Color("Theme Color"))
            //                        .cornerRadius(30)
            //                        }
            //                                .padding()
            //                }
            //            }
        }
    }
}

#Preview {
    PostListView()
}
