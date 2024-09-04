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
                                    .font(.title3)

                                if let en = song.title.en, !en.isEmpty {
                                    Text(en)
                                        .font(.footnote)
                                        .italic()
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            let limitedText = song.highlights.reduce((Text(""), 0, false)) { (result, highlight) -> (Text, Int, Bool) in
                                var (text, charCount, hasMoreText) = result
                                
                                // Calculate remaining characters allowed
                                let remaining = 40 - charCount
                                
                                // If no remaining characters, return the current result
                                guard remaining > 0 else {
                                    return (text, charCount, true) // Mark that there's more text not shown
                                }
                                
                                // Limit the highlight value to the remaining characters
                                let highlightValue = String(highlight.value.prefix(remaining))
                                
                                // Append the text and update the character count
                                let newText = highlight.type == "hit" ? text + Text(highlightValue).bold() : text + Text(highlightValue)
                                let newCharCount = charCount + highlightValue.count
                                
                                // Check if the highlight was fully consumed or if there's more text
                                let isTruncated = highlight.value.count > highlightValue.count
                                
                                return (newText, newCharCount, hasMoreText || isTruncated)
                            }.0 // Extracting the Text component

                            let finalText = limitedText + (song.highlights.reduce(0) { $0 + $1.value.count } > 40 ? Text("...") : Text(""))

                            finalText.padding(.top, 1).font(.callout)
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
    

}


#Preview {
    SearchView()
}
