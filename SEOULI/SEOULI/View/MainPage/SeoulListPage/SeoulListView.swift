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
 
 Date : 2024.07.02 Tuesday
 Description : DB 연결
 */

import SwiftUI

struct SeoulListView: View {
    @ObservedObject var seoulListVM = SeoulListVM()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color("Background Color")
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("검색하기", text: $searchText)
                    }
                    .padding()

                    ScrollView {
                        ForEach(seoulListVM.locations.filter {
                            searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText)
                        }) { location in
                            NavigationLink(destination: SeoulListDetailView(location: location)) {
                                LocationRow(location: location)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear {
                seoulListVM.fetchDataFromAPI()
            }
        }
    }		
}

struct LocationRow: View {
    let location: SeoulList

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: location.imageName)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            case .empty:
                ProgressView()
                    .frame(width: 80, height: 80)
            @unknown default:
                EmptyView()
            }
        }

            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color("Text Color"))
                Text(location.address)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing, 10)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
    }
}

struct SeoulListView_Previews: PreviewProvider {
    static var previews: some View {
        SeoulListView()
            .environmentObject(SeoulListVM())
    }
}




#Preview {
    SeoulListView()
}
