//
//  SeoulListView.swift
//  SEOULI
//
//  Created by 김수민 on 6/25/24.

/*
 Author : 김수민
 
 Date : 2024.06.26 Wednesday
 Description : 1차 UI frame 작업
 
 Date : 2024.06.27 Thursday
 Description : 2차 UI frame 작업
 */

import SwiftUI


// Test data
let testLocations: [SeoulList] = [
    SeoulList(name: "서울스카이", imageName: "seoul", description: "동대문문화원은 서울 동대문구에 위치한 주요 문화 기관입니다. 이 기관은 지역 문화와 유산을 보존하고 홍보하는 중심지 역할을 합니다. 동대문문화원은 전통 한국 예술, 공예, 음악, 춤 등을 선보이는 다양한 문화 행사, 교육 프로그램, 전시회를 개최합니다. 또한 지역 주민과 방문객들에게 문화적 정체성과 공동체 의식을 함양할 수 있는 자원과 공간을 제공합니다. Very nice, very good.", address: "위례대로 6길 20", inquiries: "010-1111-1111"),
    SeoulList(name: "한옥마을", imageName: "seoul3", description: "동대문문화원은 서울 동대문구에 위치한 주요 문화 기관입니다. 이 기관은 지역 문화와 유산을 보존하고 홍보하는 중심지 역할을 합니다. 동대문문화원은 전통 한국 예술, 공예, 음악, 춤 등을 선보이는 다양한 문화 행사, 교육 프로그램, 전시회를 개최합니다. 또한 지역 주민과 방문객들에게 문화적 정체성과 공동체 의식을 함양할 수 있는 자원과 공간을 제공합니다. ",address: "위례대로 6길 20",inquiries: "010-1111-1111"),
  
]

struct SeoulListView: View {
    @State var searchText = ""
    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                    Color("Background Color")
                        .edgesIgnoringSafeArea(.all)
            
                VStack{
                    HStack{
                        Image(systemName: "magnifyingglass")
                        TextField("검색하기", text: $searchText)
                    }
                    .padding()
                    ScrollView {
                        ForEach(testLocations.filter{
                            searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText)
                        }){ location in
                            NavigationLink(destination: SeoulListDetailView(location : location)){
                                HStack{
                                    Image(location.imageName)
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(10)
                                        .padding(.trailing, 15)
                                    VStack(alignment: .leading) {
                                        Text(location.name)
                                            .font(.title3)
                                            .bold()
                                            .foregroundColor(Color("Text Color"))
                                        Text("위례대로 6길 20")
                                          .font(.subheadline)
                                          .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 30)
                                } // HStack
                                .padding(.leading, 10)
                            }
                        }
                    } // Scroll View
                    
                }
            } // VStack
         
        } // Navigation view
//        .navigationTitle("서울 목록 리스트")
        .background(Color("Background Color").edgesIgnoringSafeArea(.all))
    }
}



#Preview {
    SeoulListView()
}
