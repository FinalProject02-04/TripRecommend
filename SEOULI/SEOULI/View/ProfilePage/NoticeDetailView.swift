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
    var notice: NoticeModel
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
                        
                    NoticeImg(notice: notice)
                    
                    Spacer()
                }
                .padding()

            }
        }
    }
}

struct NoticeImg: View {
    
    var notice: NoticeModel

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "http://192.168.50.83:8000/notice/image?img_name=\(notice.notice_img)")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
        }
        .padding()
    }
}

#Preview {
    NoticeDetailView(notice: NoticeModel(notice_seq: 1, notice_title: "공지 제목", notice_content: "공지 내용 공지 내용 공지 내용 공지 내용 공지 내용", notice_date: "2024-07-08", notice_img: "w9.jpg"))
}
