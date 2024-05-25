//
//  SearchViewViewModel.swift
//  bnbk
///Users/heryandjaruma/Documents/BnbkProject/bnbk/bnbk/UI/SearchView.swift
//  Created by Heryan Djaruma on 24/05/24.
//

import Foundation

extension SearchView {
    @Observable
    class Model {
        var searchText: String = "Yesus"
        var songs: [Song] = []
        var lastToSearch: String = ""
        var lastPage: Int = 0
        var hasMoreSongs: Bool = true
        
        private var searchTask: Task<Void, Never>? = nil
        
        func searchSongs(toSearch: String, page: Int) async {
            print("[DEBUG] Searching songs collection with keyword: \(toSearch.uppercased())")
            do {
                let url = URL(string: "https://bnbkapi.live/song/search?search=\(toSearch)&page=\(page)&size=20")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(ArraySongResponse.self, from: data)

                if toSearch != lastToSearch {
                    if toSearch.isEmpty {return}
                    lastToSearch = toSearch
                    lastPage = 0
                    self.songs = response.data
                    self.hasMoreSongs = !response.data.isEmpty
                } else if toSearch == lastToSearch && page == lastPage + 1 {
                    lastPage = page
                    self.songs.append(contentsOf: response.data)
                    self.hasMoreSongs = !response.data.isEmpty
                }
            } catch {
                print("[ERROR] From Search Model: \(error)")
                self.hasMoreSongs = false
            }
        }
        
        func debounceSearch(toSearch: String) {
            if toSearch.isEmpty {return}
            
            searchTask?.cancel()
            searchTask = Task {
                try? await Task.sleep(nanoseconds: 500_000_000) // 500ms delay
                await searchSongs(toSearch: toSearch, page: 0)
            }
        }
    }
}
