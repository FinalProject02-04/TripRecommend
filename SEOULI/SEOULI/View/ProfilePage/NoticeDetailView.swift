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
    var notice : NoticeModel
    var body: some View {
        ZStack {
            
            // background color
            Color("Background Color")
                .ignoresSafeArea()
            
            ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(notice.notice_title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Text Color"))
                    
                    HStack {
                        Text(notice.notice_date)
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                    }
                }
                
                Text(notice.notice_content)
                    .foregroundColor(Color("Text Color"))
                    
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
}

#Preview {
    NoticeDetailView(notice: NoticeModel(notice_seq: 1, notice_title: "공지 제목", notice_content: "공지 내용 공지 내용 공지 내용 공지 내용 공지 내용", notice_date: "2024-07-08"))
}
