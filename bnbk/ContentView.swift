//
//  ContentView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 17/05/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    let songIndexes: [SongIndex] = Bundle.main.decode("songIndex.json")

    var body: some View {
        NavigationStack {
            List(songIndexes) { idx in
                NavigationLink {
                    NyanyianDetailView(songId: idx.songId)
                } label: {
                    Text("\(idx.songId)")
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text(idx.title.id)
                            .font(.body)
                        
                        if let en = idx.title.en, !en.isEmpty {
                            Text(en)
                                .font(.footnote)
                                .italic()
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Nyanyian")
        }
    }
}

#Preview {
    ContentView()
}
