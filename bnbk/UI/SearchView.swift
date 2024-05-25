//
//  SearchView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 23/05/24.
//

import SwiftUI

struct SearchView: View {
    @State private var model = Model()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(model.songs.enumerated()), id: \.offset) { index, song in
                    VStack(alignment: .leading) {
                        Text("\(song.type.capitalized) \(song.songId)")
                            .font(.footnote)
                        VStack(alignment: .leading) {
                            Text(song.title.id)
                                .font(.headline)

                            if let en = song.title.en, !en.isEmpty {
                                Text(en)
                                    .font(.footnote)
                                    .italic()
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Text("Search highlights")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }.onAppear {
                        if index == model.songs.count - 1 && model.hasMoreSongs {
                            Task {
                                await model.searchSongs(toSearch: model.searchText, page: model.lastPage + 1)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $model.searchText, prompt: "Judul, pengarang, lirik")
            .onChange(of: model.searchText) { oldValue, newValue in
                Task {
                    model.debounceSearch(toSearch: newValue)
                }
            }
        }
        .onAppear {
            Task {
                await model.searchSongs(toSearch: "Yesus", page: 0)
            }
        }
    }
}

#Preview {
    SearchView()
}
