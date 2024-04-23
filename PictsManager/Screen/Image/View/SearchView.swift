//
//  Search.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct Search: View {
    @EnvironmentObject var albumsViewModel: AlbumsViewModel
    @State var album: Album?
    @State var searchResults: [Album] = []
    @State private var searchText = ""
    
//    private let countries = ["France", "England", "USA", "Vietnam", "Japan", "Korea"]
//    private var searchResults : [String] {
//        searchText.isEmpty ? countries : countries.filter { $0.contains(searchText) }
//    }
    
    var body: some View {
        NavigationView {
            VStack {
//                Text("Hello")
                List(searchResults, id: \.self) { album in
                    Text(album.title)
                }
                
//                Text($albumsViewModel.object)
            }
            .navigationTitle("Rechercher")
            .searchable(text: $searchText)
            .onChange(of: searchText) { _ in
                searchAlbums()
            }
        }
    }
    
    private func searchAlbums() {
        if !searchText.isEmpty {
            searchResults = albumsViewModel.albumsData?.albums.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            } ?? []
        } else {
            searchResults = []
        }
    }
}

#Preview {
    Search()
}
