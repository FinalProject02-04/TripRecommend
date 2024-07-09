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
    
    @Binding var isLogin: Bool
    @State private var showAlert = false
    @State private var deletionCompleted = false
    @State var result: Bool = false
    @Environment(\.dismiss) var dismiss
    
    
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
                              // 이메일, 이름, 닉네임 초기화
                              UserDefaults.standard.set("", forKey: "userEmail")
                              UserDefaults.standard.set("", forKey: "userName")
                              UserDefaults.standard.set("", forKey: "userNickname")
                              // 로그아웃 action
                              withAnimation {
                                isLogin.toggle()
                              }
                              
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
                                  // 알림 창을 표시
                                  showAlert = true
                                  
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
                          .alert(isPresented: $showAlert) {
                                  Alert(
                                      title: Text("정말 삭제하시겠습니까?"),
                                      message: Text("계정을 삭제하면 복구할 수 없습니다."),
                                      primaryButton: .default(Text("예")) {
                                          Task {
                                              deleteAccount()
                                              // 로그아웃 action
                                              // 이메일, 이름, 닉네임 초기화
                                              UserDefaults.standard.set("", forKey: "userEmail")
                                              UserDefaults.standard.set("", forKey: "userName")
                                              UserDefaults.standard.set("", forKey: "userNickname")
                                              withAnimation {
                                                isLogin.toggle()
                                              }
                                          }
                                      },
                                      secondaryButton: .cancel(Text("아니오")){
                                          showAlert = false // 경고창 닫기
                                      }
                                      
                                  )
                              
                          } // alert
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
      } // body
    
    // MARK: 계정 삭제 알림
    private func deleteAccount() {
        let email = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        let userInfo = UserInfo(result: $result)
        
        Task {
            let success = try await userInfo.deleteUser(email: email)
            if success {
                print("계정이 성공적으로 삭제되었습니다.")
                // 선택적으로 성공 시 UI 업데이트나 네비게이션 처리
                showAlert = false // 경고창 닫기
               
            } else {
                print("계정 삭제 실패")
                // 필요 시 실패 시나리오 처리
            }
        }
    }
  }



#Preview {
    ProfileView(isLogin: .constant(true))
}
