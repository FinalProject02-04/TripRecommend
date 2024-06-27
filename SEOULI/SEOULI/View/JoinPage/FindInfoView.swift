//
//  FindInfoView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI

// MARK: FindInfoView
struct FindInfoView: View {
    
    @State var selectedFindInfo = 0
    
    var body: some View {
        
            // MARK: ZStack
            ZStack(content: {
                
                // MARK: 배경색
                Color(red: 0.9, green: 0.9843, blue: 1.0)
                    // 가장자리까지 확장되도록 설정
                    .edgesIgnoringSafeArea(.all)
                
                Picker(selection: $selectedFindInfo, label: Text("Map Type")){
                    Text("아이디 찾기").tag(0)
                    Text("비밀번호 찾기").tag(1)
                } // Picker
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // MARK: tag 별 상황 나누기
                
                
                VStack(alignment:.leading, content: {
                    
//                    CustomNavigationBar(titleName: "아이디 찾기", backButton: true)
                    
                }) // VStack
                
            }) // ZStack

    }
} // FindInfoView

#Preview {
    FindInfoView()
}
