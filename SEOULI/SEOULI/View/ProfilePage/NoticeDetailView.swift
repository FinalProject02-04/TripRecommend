//
//  NoticeDetailView.swift
//  SEOULI
//
//  Created by 김소리 on 6/27/24.
//


/*
 Author : 김수민
 
 Date : 2024.06.27 Thursday
 Description : 1차 UI frame 작업
 
 */


import SwiftUI

struct NoticeDetailView: View {
    var post : PostModel
    var body: some View {
    ScrollView {
        
    
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text(post.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack {
                    Text("\(post.username) | \(post.date)")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                }
            }
            
            Text(post.subtitle)
                .font(.body)
            
            Text("저희 앱이 새롭게 업데이트되었습니다. 앞으로도 더 나은 서비스를 제공하기 위해 최선을 다하겠습니다!")
                
                Image("동대문문화원")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 300)
                
                Spacer()
            }
        .padding()

        }
    }
}

#Preview {
    NoticeDetailView(post: PostModel(title: "Seouli Update", username: "Seouli Team", subtitle: "새롭게 업데이트된 서울리!", content: "" ,date: "2024/06/32", image: "", views: 0))
}
