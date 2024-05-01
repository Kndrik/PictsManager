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
    
    var body: some View {
        NavigationView {
            ZStack {
                List(searchResults, id: \.self) { album in
                    NavigationLink(destination: AlbumPhotosView(album: album)) {
                        AlbumPreview(album: album, isFavorite: false)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Rechercher")
            .searchable(text: $searchText)
            .onChange(of: searchText) { _ in
                searchAlbums()
            }
        }
        .task {
            do {
                try await albumsViewModel.fetchAlbums()
            } catch {
              print("Error fetching albums: \(error)")
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
