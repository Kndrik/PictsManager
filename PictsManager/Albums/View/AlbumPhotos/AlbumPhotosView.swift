//
//  AlbumPhotosView.swift
//  PictsManager
//
//  Created by Stevens on 23/04/2024.
//

import SwiftUI

struct AlbumPhotosView: View {
  @StateObject var albumPhotosViewModel = AlbumPhotosViewModel()
  @StateObject var albumsViewModel = AlbumsViewModel()
  @State var album: Album
  @State private var selectedPeriodIndex = 3
  @State private var deletingAlbum = false
  @Environment(\.presentationMode) var presentationMode
  
  let periodTitles = [PeriodConstants.years, PeriodConstants.months, PeriodConstants.days, PeriodConstants.all]
  
  var body: some View {
    ZStack {
      VStack {
        HStack {
          Text(album.title)
            .bold()
            .font(.title2)
          Spacer()
          
          HStack {
            Button(action: {
              print("tapped")
            }) {
              Text("Sélectionner")
                .bold()
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(.gray)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
            
            Menu {
              Button("Supprimer l'album", systemImage: "trash", role: .destructive) {
                deletingAlbum.toggle()
              }
            } label: {
              Button {
                print("tapped")
              } label: {
                Image(systemName: "ellipsis.circle.fill")
                  .resizable()
                  .frame(width: 25, height: 25)
              }
              .background(.white)
              .foregroundColor(.gray)
              .cornerRadius(25)
            }
            .alert("Supprimer « \(album.title) »", isPresented: $deletingAlbum) {
              Button(role:.destructive) {
                Task {
                  try await albumsViewModel.deleteAlbum(albumId: album.id ?? "")
                  presentationMode.wrappedValue.dismiss()
                }
              } label: {
                Text("Oui")
              }
            } message: {
              Text("Voulez-vous vraiment supprimer l'album « \(album.title) » ?")
            }
          }
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
        
        Spacer()
        
        PhotosList(photos: $album.pictures)
        
      }
    }
    .onAppear {
      Task {
        for picture in album.pictures {
          if let data = await albumPhotosViewModel.getLowPicturesById(pictureId: picture.id) {
            await updatePhotoWithImage(id: picture.id, imageData: data)
          }
        }
      }
    }
  }
  
  func updatePhotoWithImage(id: String, imageData: Data)  async {
    if let index = album.pictures.firstIndex(where: { $0.id == id }) {
      DispatchQueue.main.async {
        album.pictures[index].imageData = imageData
      }
    }
  }
}

#Preview {
  AlbumPhotosView(album: Album(owner_id: "12345", pictures: [], title: "Test album"))
}
