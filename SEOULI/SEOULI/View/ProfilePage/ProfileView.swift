//
//  ProfileView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

/*
 Author : 김수민
 
 Date : 2024.06.27 Thursday
 Description : 1차 UI frame 작업
 */

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ZStack {
                
                // Background Color
                    Color("Background Color")
                        .edgesIgnoringSafeArea(.all)
            
                VStack(alignment: .leading, spacing: 15) {
                    
//                    // Title
//                    HStack {
//                        Spacer()
//                        Text("프로필")
//                            .font(.system(size: 33))
//                            .fontWeight(.bold)
//                            .foregroundColor(Color("Text Color"))
//                            .padding(.bottom, 3)
//                        Spacer()
//                    }
                    
                    // 마이페이지
                    Section(header: HStack {
                        Text("마이페이지")
                            .font(.title3)
                            .foregroundColor(Color("Text Color"))
                            .bold()
                    }) {
                        NavigationLink(destination: MyPostView()) {
                            HStack {
                               Text("나의 게시물")
                                   .bold()
                                   .foregroundColor(Color("Text Color"))
                               Spacer()
                               Image(systemName: "chevron.right")
                                    .foregroundColor(.gray.opacity(0.5))
                           }
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(Color.white)
                           .cornerRadius(10)
                           .shadow(radius: 3)
                       }
                        NavigationLink(destination: EditInfoView()) {
                            HStack {
                               Text("내 정보 변경")
                                   .bold()
                                   .foregroundColor(Color("Text Color"))
                               Spacer()
                               Image(systemName: "chevron.right")
                                    .foregroundColor(.gray.opacity(0.5))
                                    
                           }
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(Color.white)
                           .cornerRadius(10)
                           .shadow(radius: 3)
                       }
                        NavigationLink(destination: MyResoView()) {
                            HStack {
                               Text("패키지 결제 내역")
                                   .bold()
                                   .foregroundColor(Color("Text Color"))
                               Spacer()
                               Image(systemName: "chevron.right")
                                    .foregroundColor(.gray.opacity(0.5))
                           }
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(Color.white)
                           .cornerRadius(10)
                           .shadow(radius: 3)
                       }
                        .padding(.bottom,20)
                    }
                    
                    // 이용안내
                    Section(header: HStack {
                        Text("이용안내")
                            .font(.title3)
                            .foregroundColor(Color("Text Color"))
                            .bold()
                    }) {
                        NavigationLink(destination: NoticeView()) {
                            HStack {
                               Text("공지사항")
                                   .bold()
                                   .foregroundColor(Color("Text Color"))
                               Spacer()
                               Image(systemName: "chevron.right")
                                    .foregroundColor(.gray.opacity(0.5))
                           }
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(Color.white)
                           .cornerRadius(10)
                           .shadow(radius: 3)
                       }
                        NavigationLink(destination: AgreementView()) {
                            HStack {
                               Text("이용약관")
                                   .bold()
                                   .foregroundColor(Color("Text Color"))
                               Spacer()
                               Image(systemName: "chevron.right")
                                    .foregroundColor(.gray.opacity(0.5))
                           }
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(Color.white)
                           .cornerRadius(10)
                           .shadow(radius: 3)
                       }
                        .padding(.bottom,20)
                    }
                    
                    
                      // 계정
                      Section(header: HStack {
                          Text("계정")
                              .font(.title3)
                              .foregroundColor(Color("Text Color"))
                              .bold()
                      }) {
                          Button(action: {
                              
                             // 로그아웃 action
                              
                              
                          }) {
                              Text("로그아웃")
                                  .bold()
                                  .frame(maxWidth: .infinity)
                                  .padding()
                                  .background(Color.white)
                                  .foregroundColor(Color("Text Color"))
                                  .cornerRadius(10)
                                  .shadow(radius: 3)
                          }
                          Button(action: {
                              
                             // 회원 탈퇴 action
                              
                          }) {
                              Text("회원 탈퇴")
                                  .bold()
                                  .frame(maxWidth: .infinity)
                                  .padding()
                                  .background(Color.white)
                                  .foregroundColor(Color.red)
                                  .cornerRadius(10)
                                  .shadow(radius: 3)
                          }
                          .padding(.bottom, 30)
                      }
                      
                  }
                  .padding(28)
                  .background(Color("Background Color").edgesIgnoringSafeArea(.all))
                  .navigationBarTitleDisplayMode(.inline)
                  .bold()
              }
              
          }
          .padding(.top, 10)
          .background(Color("Background Color").edgesIgnoringSafeArea(.all))
      }
  }

#Preview {
    ProfileView()
}
