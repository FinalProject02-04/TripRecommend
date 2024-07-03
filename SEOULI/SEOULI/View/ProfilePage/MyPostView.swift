//
//  MyPostView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.

/*
 Author : 김수민
 
 Date : 2024.06.27 Thursday
 Description : 1차 UI frame 작업
 
 */

import SwiftUI

struct MyPostView: View {
    
    let posts: [PostModel] = [
        PostModel(title: "동대문문화원", username: "이휘", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", content: "" ,date: "2024-06-25", image: "", views: 0),
        PostModel(title: "동대문문화원", username: "이휘", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", content: "" ,date: "2024-06-25", image: "", views: 0),
        PostModel(title: "동대문문화원", username: "이휘", subtitle: "연인과 가도 가족과 같이 가도 좋은 곳", content: "" ,date: "2024-06-25", image: "", views: 0),
    ]
    
    var body: some View {
        
            ZStack(alignment: .top) {
                Color("Background Color")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) { // scrollbar 숨기기
                        VStack(spacing: 20) {
                            ForEach(posts) { post in
                                NavigationLink(destination: PostDetailView(community: post)) {
                                    MyPostCard(post: post)
                                }
                            }
                        }
                        .padding()
                    } // ScrollView
                    .background(Color("Background Color"))
                    .padding(.top, 60)
                } // VStack
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        Text("나의 게시물")
                            .bold()
                            .foregroundColor(Color("Text Color"))
                            .font(.title)
                    }
                })
            } // ZStack
            .edgesIgnoringSafeArea(.all)
    } // body
}

struct MyPostCard: View {
    var post: PostModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(post.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(post.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
    }
}


#Preview {
    MyPostView()
}
