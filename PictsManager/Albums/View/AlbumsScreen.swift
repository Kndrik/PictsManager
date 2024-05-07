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
    NavigationSplitView {
      VStack {
        List {
          if let albumsData = albumsViewModel.albumsData,
             let favAlbum = albumsViewModel.favAlbumData,
             photosViewModel.pictures.count > 0 {
            let recentAlbum = Album(cover_id: photosViewModel.pictures[0].id, owner_id: favAlbum.owner_id, pictures: photosViewModel.pictures, title: "Récentes")
            MyAlbumsRow(rowTitle: "Mes albums", albums: albumsData.albums, favAlbum: favAlbum, recentAlbum: recentAlbum, afficherToutButton: true)
          } else {
            Text("Loading albums")
          }
        }
        .listStyle(.inset)
      }
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
      .navigationTitle("Albums")
    } detail: {
      Text("Album list")
    }
    .task {
      do {
        try await albumsViewModel.fetchFavAlbum()
        try await albumsViewModel.fetchAlbums()
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
