//
//  SongDetail.swift
//  bnbk
//
//  Created by Heryan Djaruma on 18/05/24.
//

import SwiftUI

struct NyanyianDetailView: View {
    let songId: Int
    let type = "nyanyian"
    @State var song: Song?
    
    var body: some View {
        VStack {
            if let song = song {
                Text(song.title.id)
                    .font(.largeTitle)
                    .padding()
                
                Text(song.title.en ?? "")
                    .font(.title)
                    .italic()
                    .foregroundColor(.secondary)
                
                // Display other parts of the song
                ForEach(song.verse, id: \.self) { verse in
                    Text(verse)
                        .padding(.vertical, 4)
                }
                
                ForEach(song.chorus, id: \.self) { chorus in
                    Text(chorus)
                        .padding(.vertical, 4)
                        .font(.headline)
                }
                
                // Display other song details as needed
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
//                Text("Loading...")
//                    .onAppear {
//                        Task {
//                            do {
//                                try await fetchSongDetail()
//                            } catch {
//                                print("Error happened")
//                            }
//                        }
//                    }
            }
        }
        .padding()
    }
    
    func fetchSongDetail() async throws {
        let decoder = JSONDecoder()
        
        guard let url = URL(string: "http://localhost:8080/song/\(songId)?type=\(type)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try decoder.decode(Response.self, from: data)
            song = response.data
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}

#Preview {
    NyanyianDetailView(songId: 1)
}

// Sample Data
struct SongDetail_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSong = Song(
            id: "sample_id",
            songId: 1,
            title: Title(en: "The Wonder of His Grace", id: "Banyaklah Yang 'Ku Tak Dapat Mengerti", nl: nil, kr: nil),
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
                sf: nil,
                ks: 52
            ),
            category: Category(header: "Puji-pujian", type: "Allah Bapa")
        )
        
        NyanyianDetailView(songId: 1, song: sampleSong)
    }
}
