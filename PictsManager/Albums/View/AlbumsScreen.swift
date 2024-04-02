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
          if let albumsData = albumsViewModel.albumsData {
            ForEach(albumsData.albums) { album in
              Text("Album \(album.title)")
            }
          } else {
            Text("Loading albums")
          }
          
          MyAlbumsRow(
            rowTitle: "Mes albums",
            albums: [
              Album(id: 12, name: "Vacances", pictureNames: ["turtlerock", "02"]),
              Album(id: 13, name: "Montagne", pictureNames: ["silversalmoncreek", "02"]),
              Album(id: 15, name: "Canada 2023", pictureNames: ["twinlake", "02", "03"]),
              Album(id: 20, name: "Canada 2023", pictureNames: ["twinlake", "02", "03"]),
              Album(id: 21, name: "Canada 2023", pictureNames: ["twinlake", "02", "03"]),
              Album(id: 22, name: "Canada 2023", pictureNames: ["twinlake", "02", "03"]),
              Album(id: 23, name: "Canada 2023", pictureNames: ["twinlake", "02", "03"]),
              Album(id: 24, name: "Canada 2023", pictureNames: ["twinlake", "02", "03"]),
              Album(id: 25, name: "Canada 2023", pictureNames: ["twinlake", "02", "03"]),
              Album(id: 26, name: "Canada 2023", pictureNames: ["twinlake", "02", "03"])],
            afficherToutButton: true)
          
          AlbumRow(rowTitle: "Albums partagés", albums: [Album(id: 14, name: "Friends", pictureNames: ["turtlerock", "02"])], afficherToutButton: true)
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
