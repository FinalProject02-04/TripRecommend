//
//  ContentView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectpage = 0
    @Binding var isLogin: Bool
    
    var body: some View {
        NavigationView{
            VStack(content: {
                TabView(selection: $selectpage,
                        content:  {
                    Group{
                        MainView()
                            .tabItem {
                                Image(systemName: "house.fill")
                                Text("Main")
                            }
                            .tag(0)
                        ProductListView()
                            .tabItem {
                                Image(systemName: "airplane")
                                Text("Package")
                            }
                            .tag(1)
                        RecommendView()
                            .tabItem {
                                Image(systemName: "globe")
                                Text("Recommend")
                            }
                            .tag(2)
                        PostListView()
                            .tabItem {
                                Image(systemName: "message.fill")
                                Text("Community")
                            }
                            .tag(3)
                        ProfileView(isLogin: $isLogin)
                            .tabItem {
                                Image(systemName: "person.fill")
                                Text("Profile")
                            }
                            .tag(4)
                    }
                    .toolbarBackground(.theme, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                })
            })
        }
        
    }
}

#Preview {
    ContentView(isLogin: .constant(true))
}
