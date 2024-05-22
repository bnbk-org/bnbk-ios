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
        
        public func fetchSongs(page: Int) {
            guard let url = URL(string: "http://localhost:8080/song/index/all?page=\(page)&size=10&sortBy=songId&sortDirection=ASC") else {
                print("Invalid URL")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
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
                        self.songIndexes = response.data
                    }
                } catch {
                    print("From View Model:")
                    print(error)
                }
            }.resume()
        }
    }
}
