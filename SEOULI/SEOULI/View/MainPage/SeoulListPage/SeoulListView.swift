//
//  SeoulListView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.

/*
 Author : Diana
 Date : 2024.06.26 Wednesday
 Description : 1차 UI frame 작업 (2024.06.08 Saturday 10:30)
 */

import SwiftUI


// Model for Location
struct SeoulList: Identifiable {
    var id = UUID()
    var name: String
    var imageName: String
    var description : String
    var address: String
    var inquiries : String
}

// Test data
let testLocations: [SeoulList] = [
    SeoulList(name: "위례신도시 1", imageName: "background", description: "Very nice, very good.", address: "위례대로 6길 20", inquiries: "010-1111-1111"),
    SeoulList(name: "위례신도시 2", imageName: "background2", description: "verynice, very good.",address: "위례대로 6길 20",inquiries: "010-1111-1111"),
    SeoulList(name: "위례신도시 3", imageName: "background3", description: "very nice, very good.",address: "위례대로 6길 20",inquiries: "010-1111-1111"),
  
]

struct SeoulListView: View {
    @State var searchText = ""
    var body: some View {
        NavigationView {
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
                }
                
            }
         
        }
        .navigationTitle("서울 목록 리스트")
    }
}



#Preview {
    SeoulListView()
}
