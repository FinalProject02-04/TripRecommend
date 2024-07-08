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
    
//    let notice: [PostModel] = [
//        PostModel(title: "국내여행 후기 이벤트 종료!", username: "Seouli", subtitle: "안녕하세요! 서울리입니다.", content: "", date: "2024-06-25", image: "", views: 0),
//        PostModel(title: "서울리 2.0 버젼으로 리뉴얼 되었습니다!", username: "Seouli", subtitle: "안녕하세요! 서울리입니다.", content: "", date: "2024-06-25", image: "", views: 0),
//        PostModel(title: "서울리 1.7 버젼으로 리뉴얼 되었습니다!", username: "Seouli", subtitle: "안녕하세요! 서울리입니다.", content: "", date: "2024-06-24", image: "", views: 0),
//    ]
    @State var notice: [NoticeModel] = []
    @State var isLoaded = true
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color("Background Color")
                .edgesIgnoringSafeArea(.all)
            
                VStack(spacing: 0) {
                    if isLoaded{
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }else{
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                ForEach(notice, id: \.notice_seq) { notice in
                                    NavigationLink(destination: NoticeDetailView(notice: notice)) {
                                    NoticeCard(notice: notice)
                                    }
                                }
                            }
                            .padding()
                        } // ScrollView
                        .background(Color("Background Color"))
                        .padding(.top, 60)
                    }
                } // VStack
                .onAppear(perform: {
                    let noticeVm = NoticeVm()
                    Task{
                        notice = try await noticeVm.selectNotice()
                        print(notice)
                        isLoaded = false
                    }
                })
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
    var notice: NoticeModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(notice.notice_title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(notice.notice_content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Text(notice.notice_date)
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
