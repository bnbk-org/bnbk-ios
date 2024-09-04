//
//  SearchView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 23/05/24.
//

import SwiftUI
import OSLog

struct SearchView: View {
    @State private var model = Model()
    
    var log = Logger()
    
    var body: some View {
            NavigationStack {
                List {
                    
                    ForEach(Array(model.songs.enumerated()), id: \.offset) { index, song in
                        
                        VStack(alignment: .leading) {
                            if let type = song.type {
                                Text("\(type.capitalized) \(song.songId)")
                                    .font(.footnote)
                            }
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

                            // Process highlights and display complete texts
//                            if let highlights = song.highlights { // Make sure highlights is optional
//                                let completeTexts = processHighlights(highlights: highlights)
//                                ForEach(completeTexts, id: \.self) { text in
//                                    Text(text)
//                                        .font(.caption)
//                                        .foregroundStyle(.secondary)
//                                }
//                            }
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
                    await model.searchSongs(toSearch: "", page: 0)
                }
            }
        }

        func processHighlights(highlights: [[String: String]]) -> [String] {
            var completeTexts: [String] = []
            var currentText = ""

            for highlight in highlights {
                if let type = highlight["type"], let value = highlight["value"] {
                    if type == "text" {
                        currentText.append(value)
                    } else if type == "hit" {
                        if !currentText.isEmpty {
                            completeTexts.append(currentText)
                            currentText = ""
                        }
                        currentText.append(value)
                    }
                }
            }

            if !currentText.isEmpty {
                completeTexts.append(currentText)
            }

            return completeTexts
        }
}

#Preview {
    SearchView()
}
