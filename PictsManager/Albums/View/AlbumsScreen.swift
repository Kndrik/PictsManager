//
//  AlbumsView.swift
//  PictsManager
//
//  Created by Charles Lamarque on 17/03/2024.
//

import SwiftUI

struct AlbumsScreen: View {
  @EnvironmentObject var albumsFetcher: AlbumsFetcher
  @State private var addingAlbum = false
  @State private var addingFolder = false;
  @State private var title = ""
  @State private var folderName = ""
  
  var body: some View {
    NavigationSplitView {
      VStack {
        List {
          if let albumsData = albumsFetcher.albumsData {
            MyAlbumsRow(rowTitle: "Mes albums", albums: albumsData.albums, afficherToutButton: true)
          } else {
            Text("Loading albums")
          }
          
//          AlbumRow(rowTitle: "Albums partagés", albums: [Album(id: 14, name: "Friends", pictureNames: ["turtlerock", "02"])], afficherToutButton: true)
          //          AlbumRow(rowTitle: "Personnes, animaux et lieux", albums: [Album(id: 16, name: "Friends", pictureNames: ["icybay", "02"])], afficherToutButton: false)
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
              createAlbum(name: title)
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
              createFolder(name: folderName)
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
        try await albumsFetcher.fetchAlbums()
      } catch {
        print("Error fetching albums: \(error)")
      } 
    }
  }
  
  func createAlbum(name: String) {
    // Call API to create the album
    print("\(name)")
  }
  
  func createFolder(name: String) {
    print("Create folder \(name)")
  }
}


struct AlbumsScreen_Previews: PreviewProvider {
  static var previews: some View {
    AlbumsScreen()
      .environmentObject(AlbumsFetcher())
  }
}
