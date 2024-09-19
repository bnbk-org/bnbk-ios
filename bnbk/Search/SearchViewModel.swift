//
//  SearchViewViewModel.swift
//  bnbk
//
//  Created by Heryan Djaruma on 24/05/24.
//

import Foundation
import OSLog

extension SearchView {
    @Observable
    class ViewModel {
        private let log = Logger()
        
        var searchText: String = ""
        var activeTab: TabTypeEnum = TabTypeEnum.all
        var songs: [SongSearchResult] = []
        var lastToSearch: String = ""
        var lastPage: Int = 0
        var hasMoreSongs: Bool = true
        
        private var searchTask: Task<Void, Never>? = nil
        
        func searchSongs(toSearch: String, page: Int) async {
            
            let activeTabValue = (activeTab == .all) ? "" : activeTab.rawValue.lowercased()
            
            log.debug("Searching songs collection with keyword: \(toSearch), type: \(activeTabValue)")
            
            do {
                let url = URL(string: "https://web.bnbk.org/api/song/search?search=\(toSearch)&page=\(page)&size=10&type=\(activeTabValue)")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(SongSearchArrayResult.self, from: data)
                
                if toSearch != lastToSearch {
                    if toSearch.isEmpty { return }
                    lastToSearch = toSearch
                    lastPage = 0
                    self.songs = response.data
                } else if page == lastPage + 1 {
                    lastPage = page
                    self.songs.append(contentsOf: response.data)
                }
                self.hasMoreSongs = !response.data.isEmpty
            } catch {
                log.error("From Search Model: \(error)")
                self.hasMoreSongs = false
            }
        }

        func debounceSearch(toSearch: String) {
            if toSearch.isEmpty {
                self.songs = []
                return
            }
            
            searchTask?.cancel()
            searchTask = Task {
                try? await Task.sleep(nanoseconds: 250_000_000)
                await searchSongs(toSearch: toSearch, page: 0)
            }
        }
        
        func clearSearchBar() -> Void {
            self.searchText = ""
            self.songs = []
        }

    }
}
