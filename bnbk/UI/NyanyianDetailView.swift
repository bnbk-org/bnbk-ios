//
//  NyanyianDetailView.swift
//  bnbk
//
//  Created by Heryan Djaruma on 18/05/24.
//

import SwiftUI

struct NyanyianDetailView: View {
    let songId: Int
    let type = "nyanyian"
    @State var song: Song?
    @State private var showingMusicAttributesPopover = false
    @State private var showingMusicNumbersPopover = false
    
    let heights = stride(from: 0.5, through: 1.0, by: 0.1).map { PresentationDetent.fraction($0) }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                if let song = song {
                    
                    ZStack {
                        Image("congregational")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(Color.black.opacity(0.2))
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Spacer()
                                Text("\(song.category.header): \(song.category.type)")
                                    .foregroundStyle(.thinMaterial)
                                    .font(.caption)
                                Text(song.title.id)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                if let enTitle = song.title.en, !enTitle.isEmpty {
                                    Text(enTitle)
                                        .font(.subheadline)
                                        .italic()
                                        .foregroundColor(.white)
                                }
                                
                                HStack(spacing: 10) {
                                    if let authors = song.authors, !authors.isEmpty {
                                        ForEach(authors, id: \.self) { author in
                                            Text(author.name)
                                                .font(.caption)
                                                .foregroundStyle(.thinMaterial)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }.padding()
                    }.frame(maxWidth: .infinity)
                    
                    Group {
                        HStack {
                            VStack(alignment: .leading) {
                                if let keyId = song.music.keyId {
                                    let keyOgText = song.music.keyOg != nil ? " (\(song.music.keyOg!))" : ""
                                    HStack() {
                                        Text("Do = \(keyId)\(keyOgText)")
                                    }
                                }
                                
                                HStack {
                                    if let tempo = song.music.tempo {
                                        Text(tempo)
                                    }
                                    if let bpm = song.music.bpm {
                                        Text("= \(bpm)")
                                    }
                                }
                                
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                if let sasb = song.music.sasb, sasb > 0 {
                                    Text("SASB \(sasb)")
                                }
                                if let btb = song.music.btb, btb > 0 {
                                    Text("BTB \(btb)")
                                }
                                if let crossBtb = song.music.crossBtb, crossBtb > 0 {
                                    Text("BTB alt. \(crossBtb)")
                                }
                                if let sf = song.music.sf, sf > 0 {
                                    Text("SF \(sf)")
                                }
                                if let ks = song.music.ks, ks > 0 {
                                    Text("KS \(ks)")
                                }
                            }
                        }
                    }.padding()
                        .font(.caption)
                    
                    Divider()
                
                    Group {
                        
                        Text(song.verse[0])
                        
                        if let choruses = song.chorus, !choruses.isEmpty, !choruses[0].isEmpty {
                            VStack(alignment: .leading) {
                                Text("KOOR")
                                    .font(.subheadline)
                                    .bold()
                                    .padding(.leading, 10)
                                HStack {
                                    Spacer()
                                        .frame(width: 10)

                                    ForEach(choruses, id: \.self) { chorus in
                                        Text(chorus)
                                    }
                                }
                            }
                        }
                        
                        ForEach(song.verse.indices.dropFirst(), id: \.self) { index in
                                Text(song.verse[index])
                        }
                        
                        Button(action: {
                            showingMusicAttributesPopover.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                            Text("Pelajari lagu Ini")
                        }.font(.caption)
                        .sheet(isPresented: $showingMusicAttributesPopover) {
                            InfoPopoverView()
                                .padding()
                                .presentationBackground(.white)
                                .presentationDetents(Set(heights))
                        }
                    }.padding()
                    
                } else {
                    ProgressView()
                        .onAppear{
                            Task {
                                do {
                                    try await fetchSongDetail()
                                } catch {
                                    print("Error happened")
                                }
                            }
                        }
                }
            }
        }.ignoresSafeArea()
    }
    
    func fetchSongDetail() async throws {
        let decoder = JSONDecoder()
        
        guard let url = URL(string: "https://web.bnbk.org/api/song/\(songId)?type=\(type)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try decoder.decode(SongResponse.self, from: data)
            song = response.data
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}

struct InfoPopoverView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Nada Dasar")
                    .font(.title)
                Text("Nada dasar merupakan nada asli dari lagu ini (berdasarkan Salvation Army Song Book).")
                    .font(.body)
                Text("Nada dasar merupakan nada yang disesuaikan.")
                    .font(.body)
                Spacer()
            }
        }
    }
}

#Preview("API View") {
    NyanyianDetailView(songId: 1)
}

// Sample Data
struct NyanyianDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSong = Song(
            id: "sample_id",
            songId: 1,
            title: Title(en: "The Wonder of His Grace", id: "Banyaklah Yang 'Ku Tak Dapat Mengerti", nl: nil, kr: nil),
            authors: [
                Author(name: "Howard Davies", uid: nil)
            ],
            type: "nyanyian",
            verse: [
                "Banyaklah yang 'ku tak dapat mengerti, semua bagaikan misteri;\nTapi karunia Allah yang 'ku t'rima sungguh mengherankan dan mulia.",
                "Bila 'ku datang membawa dosaku serta s'gala persoalanku,\nTentu Tuhan akan menerimanya, kasih Allah luar biasa!",
                "Pengertian yang sangat mengherankan, tidak dapat aku pikirkan,\nYesus, dalam kasih, datang ke dunia mau menjadi s'habat manusia!"
            ],
            chorus: [
                "Lebih tinggi dari angkasa raya, lebih luas dan tak ada batasnya,\nItu kasih Allah yang mengampuni orang berdosa ini."
            ],
            music: Music(
                keyId: "F",
                keyOg: "G",
                measure: "4/4",
                tempo: "Andante con moto",
                bpm: 84,
                btb: nil,
                crossBtb: nil,
                sasb: 873,
                sf: nil,
                ks: 52
            ),
            category: Category(header: "Puji-pujian", type: "Allah Bapa")
        )
        
        NyanyianDetailView(songId: 1, song: sampleSong)
    }
}
