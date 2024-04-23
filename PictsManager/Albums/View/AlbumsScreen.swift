//
//  AlbumsView.swift
//  PictsManager
//
//  Created by Charles Lamarque on 17/03/2024.
//

import SwiftUI

struct AlbumsScreen: View {
  @EnvironmentObject var albumsViewModel: AlbumsViewModel
  @State private var addingAlbum = false
  @State private var addingFolder = false;
  @State private var title = ""
  @State private var folderName = ""
  
  var body: some View {
    NavigationSplitView {
      VStack {
        List {
          if let albumsData = albumsViewModel.albumsData{
            MyAlbumsRow(rowTitle: "Mes albums", albums: albumsData.albums, favAlbum: albumsData.albums[0], afficherToutButton: true)
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
              addingAlbum.toggle()
            } label: {
              Text("Annuler")
            }
            Button {
//                albumsViewModel.createAlbum(name: title)
            } label: {
              Text("Enregistrer")
            }
            .disabled(title.isEmpty)
          } message: {
            Text("Saisissez un nom pour cet album.")
          }
          .alert("Nouveau dossier", isPresented: $addingFolder) {
            TextField("Titre", text: $folderName)
            Button {
              folderName = ""
              addingFolder.toggle()
            } label: {
              Text("Annuler")
            }
            Button {
//                albumsViewModel.createFolder(name: folderName)
            } label: {
              Text("Enregistrer")
            }
            .disabled(folderName.isEmpty)
          } message: {
            Text("Saisissez un nom pour ce dossier.")
          }
        }
      }
      .navigationTitle("Albums")
    } detail: {
      Text("Album list")
    }
    .task {
      do {
        //try await albumsViewModel.fetchFavAlbum()
        try await albumsViewModel.fetchAlbums()
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
  }
}
