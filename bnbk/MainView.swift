//
//  MainView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 18/09/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeViewV1().tabItem {
                Label("Beranda", systemImage: "house")
            }
            SearchView().tabItem {
                Label("Cari", systemImage: "magnifyingglass")
            }
//            SavedView().tabItem {
//                Label("Favorit", systemImage: "music.note.list")
//            }
            ProfileView().tabItem {
                Label("Lainnya", systemImage: "person")
            }
        }
    }
}

#Preview {
    MainView()
}
