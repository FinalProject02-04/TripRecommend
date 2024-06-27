//
//  NoticeView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.

/*
 Author : 김수민
 
 Date : 2024.06.27 Thursday
 Description : 1차 UI frame 작업
 
 */

import SwiftUI

struct NoticeView: View {
    
    let notice: [Post] = [
        Post(title: "국내여행 후기 이벤트 종료!", username: "이휘", subtitle: "안녕하세요! 서울리입니다.", date: "2024-06-25"),
        Post(title: "다님이 2.0 버젼으로 리뉴얼 되었습니다!", username: "이천영", subtitle: "안녕하세요! 서울리입니다.", date: "2024-06-25"),
        Post(title: "다님이 1.7 버젼으로 리뉴얼 되었습니다!", username: "리턴영", subtitle: "안녕하세요! 서울리입니다.", date: "2024-06-24"),
    ]
    
    var body: some View {

        ZStack(alignment: .top) {
            Color("Background Color")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) { // scrollbar 숨기기
                    VStack(spacing: 20) {
                        ForEach(notice) { post in
                            NoticeCard(post: post)
                        }
                    }
                    .padding()
                } // ScrollView
                .background(Color("Background Color"))
                .padding(.top, 60)
            } // VStack
            .toolbar(content: {
                ToolbarItem(placement: .principal){
                    Text("공지사항")
                        .bold()
                        .foregroundColor(Color("Text Color"))
                        .font(.title)
                }
            })
        } // ZStack
        .edgesIgnoringSafeArea(.all)
    } // body
}

struct NoticeCard: View {
    var post: Post
    
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
    NoticeView()
}
