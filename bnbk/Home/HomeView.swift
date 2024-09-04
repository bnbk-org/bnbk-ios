//
//  HomeView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 24/05/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            NavigationStack {
                List(viewModel.songIndexes.indices, id: \.self) { index in
                    let idx = viewModel.songIndexes[index]
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
                    .onAppear {
                        if index == viewModel.songIndexes.count - 1 {
                            viewModel.fetchSongs(page: viewModel.currentPage + 1)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Nyanyian")
                .onAppear {
                    viewModel.fetchSongs(page: 0)
                }
            }
        }

    }
}

#Preview("Basic Home Preview") {
    HomeView()
}
