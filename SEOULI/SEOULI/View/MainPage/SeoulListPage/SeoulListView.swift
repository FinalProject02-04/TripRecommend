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
 
 Date : 2024.07.03 Wednesday
 Description : List 마무리작업 + lazy loading 추가
 
 Date : 2024.07.08 Monday
 Description : 주석달기, 마무리작업 
 
 */

import SwiftUI

struct SeoulListView: View {
    @ObservedObject var seoulListVM = SeoulListVM()
    @State private var searchText = ""
    @State private var displayedLocations = [SeoulList]()
    @State private var isLoading = false
    @State private var currentPage = 0
    let pageSize = 10

    var body: some View {
        NavigationView {
            ZStack {
                Color("Background Color")
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("검색하기", text: $searchText, onCommit: {
                            // Reset the displayed locations when search text changes
                            currentPage = 0
                            displayedLocations = []
                            loadMoreLocations()
                        })
                    }
                    .padding()

                    ScrollView {
                        LazyVStack {
                            ForEach(displayedLocations.filter {
                                // search bar functions
                                searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText)
                            }) { location in
                                // navigation links to detail page
                                NavigationLink(destination: SeoulListDetailView(location: location)) {
                                    LocationRow(location: location)
                                }
                            }
                            // lazy loading progress view
                            if isLoading {
                                ProgressView()
                                    .padding()
                            } else {
                                Color.clear
                                    .frame(height: 1)
                                    .onAppear {
                                        loadMoreLocations()
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear {
                seoulListVM.fetchDataFromAPI()
                loadMoreLocations()
            }
        }
    }
    
    // lazy scroll (10 items per scroll)
    private func loadMoreLocations() {
        guard !isLoading else { return }
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // network delay
            let newLocations = Array(seoulListVM.locations.prefix((currentPage + 1) * pageSize))
            displayedLocations = newLocations
            isLoading = false
            currentPage += 1
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
