//
//  AlbumsView.swift
//  PictsManager
//
//  Created by Charles Lamarque on 17/03/2024.
//

import SwiftUI

struct AlbumsScreen: View {
  @EnvironmentObject var albumsViewModel: AlbumsViewModel
  @EnvironmentObject var photosViewModel: PhotosViewModel
  @State private var addingAlbum = false
  @State private var addingFolder = false;
  @State private var title = ""
  @State private var folderName = ""
  @State private var isEmpty = true
  
  var body: some View {
    NavigationView {
      VStack {
        List {
          if let albumsData = albumsViewModel.albumsData,
             let favAlbum = albumsViewModel.favAlbumData,
             let sharedAlbumsData = albumsViewModel.sharedAlbumsData,
             photosViewModel.pictures.count > 0 {
            let recentAlbum = Album(cover_id: photosViewModel.pictures[0].id, owner_id: favAlbum.owner_id, pictures: photosViewModel.pictures, title: "Récentes")
            MyAlbumsRow(rowTitle: "Mes albums", albums: albumsData.albums, favAlbum: favAlbum, recentAlbum: recentAlbum, afficherToutButton: true)
            AlbumRow(rowTitle: "Partagés", albums: sharedAlbumsData.albums, afficherToutButton: false)
          } else {
            Text("Loading albums")
          }
        }
        .listStyle(.inset)
      }
      .navigationTitle("Albums")
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Menu("AddAlbumMenu", systemImage: "plus") {
            Button("Nouvel album", systemImage: "rectangle.stack.badge.plus") { addingAlbum.toggle() }
          }
          .alert("Nouvel album", isPresented: $addingAlbum) {
            TextField("Titre", text: $title)
            
            Button {
              title = ""
            } label: {
              Text("Annuler")
            }
            
            Button {
              Task {
                try await albumsViewModel.createAlbum(name: title)
                try await albumsViewModel.fetchAlbums()
                title = ""
              }
            } label: {
              Text("Enregistrer")
            }
//            .disabled(title.isEmpty)
            
          } message: {
            Text("Saisissez un nom pour cet album.")
          }
        }
      }
    }
    .task {
      do {
        try await albumsViewModel.fetchFavAlbum()
        try await albumsViewModel.fetchAlbums()
        try await albumsViewModel.fetchSharedAlbums()
        await photosViewModel.getPicturesList()
      } catch {
        print("Error fetching albums: \(error)")
      }
    }
  }
}


struct AlbumsScreen_Previews: PreviewProvider {
  static var previews: some View {
    AlbumsScreen()
      .environmentObject(AlbumsViewModel())
      .environmentObject(PhotosViewModel())
  }
}
