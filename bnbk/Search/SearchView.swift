//
//  SearchView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 23/05/24.
//

import SwiftUI
import OSLog

struct SearchView: View {
    @State private var viewModel = ViewModel()
    @Namespace private var animation
    var log = Logger()
    
    var body: some View {
        NavigationStack {
            VStack {
                ExpandableNavigationBar()
                
                if viewModel.searchText.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "text.magnifyingglass")
                            .font(.system(size: 60))
                        Text("Cari kata kunci")
                    }
                    .foregroundStyle(Color.gray)
                    .font(.headline)
                    Spacer()
                } else if viewModel.songs.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 60))
                        Text("Tidak dapat menemukan apapun")
                    }
                    .foregroundStyle(Color.gray)
                    .font(.headline)
                    Spacer()
                } else {
                    List {
                        SearchResultList()
                    }
                    .listStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color("BG"))
            .onChange(of: viewModel.searchText) { oldValue, newValue in
                Task {
                    viewModel.debounceSearch(toSearch: newValue)
                }
            }
            .onChange(of: viewModel.activeTab) { oldValue, newValue in
                Task {
                    viewModel.debounceSearch(toSearch: viewModel.searchText)
                }
            }
            .onAppear {
                // Optionally adjust or remove this if not needed
            }
        }
    }
    
    @ViewBuilder
    func ExpandableNavigationBar(_ title: String = "Cari Lagu") -> some View {
        VStack(spacing: 10) {
            /// Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                TextField("Judul, pengarang, lirik", text: $viewModel.searchText)
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.clearSearchBar()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                    .foregroundStyle(Color.black)
                }

            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .frame(height: 45)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
            }
            
            /// Custom Segmented Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(TabTypeEnum.allCases, id: \.rawValue) { tab in
                        Button(action: {
                            withAnimation(.snappy) {
                                viewModel.activeTab = tab
                            }
                        }) {
                            Text(tab.rawValue)
                                .font(Font.custom("Helvetica Neue", size: 14))
                                .foregroundStyle(viewModel.activeTab == tab ? Color.black : Color.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 15)
                                .background {
                                    if viewModel.activeTab == tab {
                                        Capsule()
                                            .fill(Color.white)
                                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                    } else {
                                        Capsule()
                                            .fill(Color("Primary"))
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }

    /// SearchResult List View
    @ViewBuilder
    func SearchResultList() -> some View {

        ForEach(Array(viewModel.songs.enumerated()), id: \.offset) { index, song in
            NavigationLink(destination: NyanyianDetailView(songId: song.songId)) {
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
                }
                .background(Color("BG"))
                .onAppear {
                    if index == viewModel.songs.count - 1 && viewModel.hasMoreSongs {
                        Task {
                            await viewModel.searchSongs(toSearch: viewModel.searchText, page: viewModel.lastPage + 1)
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    SearchView()
}
