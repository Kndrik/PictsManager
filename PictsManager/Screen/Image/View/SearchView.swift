//
//  Search.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct Search: View {
    @EnvironmentObject var albumsViewModel: AlbumsViewModel
    @State var filteredPhotos: [Photo] = []
    @State var searchResults: [SearchItem] = []
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(searchResults, id: \.id) { item in
                switch item {
                case .album(let album):
                  NavigationLink(destination: AlbumPhotosView(album: album, isShared: false)) {
                    AlbumPreview(album: album, isFavorite: false, isShared: false)
                    }
                case .image(let photo):
                  NavigationLink(destination: ImageDetails(photo: photo, photos: $filteredPhotos, isShared: false, albumId: "")) {
                        Text(photo.filename)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Rechercher")
            .searchable(text: $searchText)
            .onChange(of: searchText) { _ in
                searchResults = []
                searchAlbums()
                searchImages()
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
            }.map { SearchItem.album($0) } ?? []
        } else {
            searchResults = []
        }
    }

    private func searchImages() {
        if !searchText.isEmpty {
            var results = searchResults
            
            for album in albumsViewModel.albumsData?.albums ?? [] {
                filteredPhotos = album.pictures.filter {
                    $0.filename.localizedCaseInsensitiveContains(searchText)
                }
                results.append(contentsOf: filteredPhotos.map { SearchItem.image($0) })
            }
            
            searchResults = results
        } else {
            searchResults = []
        }
    }
}

enum SearchItem {
    case album(Album)
    case image(Photo)
    
    var id: String {
        switch self {
            
        case .album(let album):
            return album.id ?? ""
            
        case .image(let photo):
            return photo.id
        }
    }
}


//#Preview {
//    Search()
//}
