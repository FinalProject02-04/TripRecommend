//
//  ContentView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectpage = 0
    var body: some View {
        TabView(selection: $selectpage,
                content:  {
            Group{
                MainView()
                    .tabItem {
                        Image(systemName: "eraser.fill")
                        Text("Main")
                    }
                    .tag(0)
                ProductListView()
                    .tabItem {
                        Image(systemName: "eraser.fill")
                        Text("Package")
                    }
                    .tag(1)
                PostListView()
                    .tabItem {
                        Image(systemName: "eraser.fill")
                        Text("Community")
                    }
                    .tag(2)
                ProfileView()
                    .tabItem {
                        Image(systemName: "eraser.fill")
                        Text("Profile")
                    }
                    .tag(3)
            }
            .toolbarBackground(.theme, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        })
    }
}

#Preview {
    ContentView()
}
