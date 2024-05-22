//
//  SongListViewModel.swift
//  bnbk
//
//  Created by Heryan Djaruma on 21/05/24.
//

import Foundation

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var songIndexes = [SongIndex]()
        public var isFetching = false
        public var currentPage = 1
        private var totalPages = 9
        
        public func fetchSongs(page: Int) {
            guard !isFetching, page <= totalPages else { return }
            
            isFetching = true
            
            guard let url = URL(string: "http://localhost:8080/song/index/all?page=\(page)&size=50&sortBy=songId&sortDirection=ASC") else {
                print("Invalid URL")
                isFetching = false
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                defer { self.isFetching = false }
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(ArrayResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.songIndexes.append(contentsOf: response.data)
                        self.currentPage = page
                    }
                } catch {
                    print("From View Model:")
                    print(error)
                }
            }.resume()
        }
    }
}
