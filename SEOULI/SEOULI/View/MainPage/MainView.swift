//
//  MainView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.

/*
 Author : Diana
 Date : 2024.06.26 Wednesday
 Description : 1차 UI frame 작업 (2024.06.08 Saturday 10:30)
 */

import SwiftUI


struct Location: Identifiable {
    var id = UUID()
    var name: String
    var imageName: String
}

struct Packages : Identifiable {
    var id = UUID()
    var name: String
    var imageName : String
}


struct MainView: View {
    // test locations
    let locations: [Location] = [
        Location(name: "Location 1", imageName: "background"),
        Location(name: "Location 2", imageName: "background2"),
        Location(name: "Location 3", imageName: "background"),
        Location(name: "Location 4", imageName: "background2"),
        Location(name: "Location 5", imageName: "background")
    ]
    
    // test packages
    let packages: [Packages] = [
        Packages(name: "Package 1", imageName: "background2"),
        Packages(name: "Package 2", imageName: "background"),
        Packages(name: "Package 3", imageName: "background2"),
    ]
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                // Image (background)
                Image("background")
                    .resizable()
                    .frame(width: 395, height: 300)
                    .padding(.bottom, 580)
                
                Image("logo")
                    .resizable()
                    .frame(width: 200, height: 45)
                    .padding(.bottom, 700)
                // Rounded Rectangular View (
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white)
                    .frame(width: 400, height: 760)
                    .padding(.top,200)
                    .shadow(radius: 10)
                    .overlay(
                        VStack {
                            Text("우리가 추천하는 여행지")
                                .font(.title)
                                .bold()
                                .foregroundColor(.black)
                                .padding(.trailing, 130)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            // our recommended locations (test)
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack(){
                                    ForEach(locations) { location in
                                        VStack{
                                            Image(location.imageName)
                                                .resizable()
                                                .frame(width: 140,height: 200)
                                                .cornerRadius(20)
                                                .overlay(
                                                    Text(location.name)
                                                        .bold()
                                                        .foregroundColor(.white)
                                                        .padding(.top,150)
                                                        .padding(.trailing,10)
                                                        .font(.title2)
                                                )
                                        }
                                    }
                                }
                                .padding(.leading,10)
                            }
                            .padding(.bottom)
                            Text("여행 패키지")
                                .font(.title)
                                .bold()
                                .foregroundColor(.black)
                                .padding(.trailing, 258)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            // our recommended packages (test)
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack(){
                                    ForEach(packages) { packages in
                                        VStack{
                                            Image(packages.imageName)
                                                .resizable()
                                                .frame(width: 220 ,height: 130 )
                                                .cornerRadius(20)
                                                .overlay(
                                                    Text(packages.name)
                                                        .bold()
                                                        .foregroundColor(.white)
                                                        .padding(.top,80)
                                                        .padding(.trailing,80)
                                                        .font(.title2)
                                            )
                                        }
                                    }
                                }
                            }
                            .padding(.leading,10)
                            // Button
                            NavigationLink(destination: SeoulListView()) {
                                Text("서울 목록 리스트")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 250, height: 50)
                                    .background(Color.theme)
                                    .cornerRadius(25)
                            }
                            .padding(.top,30)
                        } // VStack
                            .padding(.top, 35)
                ) // overlay
            } // ZStack
        } // NavigationStack
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
    } // body
} // MainView

#Preview {
    MainView()
}
