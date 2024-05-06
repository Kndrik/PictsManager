//
//  Search.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct Search: View {
    @EnvironmentObject var albumsViewModel: AlbumsViewModel
    @State var searchResults: [SearchResult] = []
    @State var filteredPhotos: [Photo] = []
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.id) { result in
                    switch result {
                    case .album(let album):
                        NavigationLink(destination: AlbumPhotosView(album: album)) {
                            AlbumPreview(album: album, isFavorite: false)
                        }
                    case .photo(let photo):
                        Text(photo.filename)
//                        NavigationLink(destination: ImageDetails(photo: photo, photos: filter)) {
//                            Text(photo.filename)
//                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Rechercher")
            .searchable(text: $searchText)
            .onChange(of: searchText) { _ in
                searchResults = []
                searchAlbums()
                searchPhotos()
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
            if let albumsData = albumsViewModel.albumsData {
                let filteredAlbums = albumsData.albums.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
                searchResults.append(contentsOf: filteredAlbums.map { .album($0) })
            }
        }
    }
    
    private func searchPhotos() {
        if !searchText.isEmpty {
            var results = [SearchResult]()
            for album in albumsViewModel.albumsData?.albums ?? [] {
                let filteredPhotos = album.pictures.filter { $0.filename.localizedCaseInsensitiveContains(searchText) }
                results.append(contentsOf: filteredPhotos.map { .photo($0) })
            }
            searchResults.append(contentsOf: results)
        }
    }
}


enum SearchResult: Identifiable {
    case album(Album)
    case photo(Photo)
    
    var id: String {
        switch self {
        case .album(let album):
            return album.id ?? UUID().uuidString
        case .photo(let photo):
            return photo.id
        }
    }
}

#Preview {
    Search()
}
