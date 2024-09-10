//
//  ContentView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 17/05/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            HomeViewV1().tabItem {
                Label("Beranda", systemImage: "house")
            }
            SearchView().tabItem {
                Label("Cari", systemImage: "magnifyingglass")
            }
            SavedView().tabItem {
                Label("Favorit", systemImage: "music.note.list")
            }
            ProfileView().tabItem {
                Label("Lainnya", systemImage: "person")
            }
        }
    }
}

#Preview {
    ContentView()
}
