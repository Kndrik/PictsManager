//
//  AlbumRow.swift
//  PictsManager
//
//  Created by Charles Lamarque on 18/03/2024.
//

import SwiftUI

struct MyAlbumsRow: View {
  @State private var show = false
  var rowTitle: String
  var albums: [Album]
  var afficherToutButton: Bool
    
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(rowTitle)
          .font(.system(size: 23)).fontWeight(.bold)
          .frame(alignment: .leading)
        Spacer()
        if (afficherToutButton) {
          NavigationLink {
            AlbumsListView(title: rowTitle, albums: albums)
          } label: {
            Text("Tout afficher")
              .foregroundStyle(Color.blue)
          }
        }
      }
      .padding(.horizontal)
      .padding(.top, 10)
      .buttonStyle(PlainButtonStyle())
      
        
      ScrollView(.horizontal, showsIndicators: false) {
        VStack(alignment: .leading, spacing: 20) {
          HStack(alignment: .top, spacing: 10) {
              
            NavigationLink {
                AlbumsScreen()
//              PhotosList()
            } label: {
              AlbumPreview(album: Album(id: 17, name: "Récentes", pictureNames: [""]), isFavorite: false)
            }
            .buttonStyle(PlainButtonStyle())
              
            ForEach(Array(albums.enumerated()), id: \.element) { index, album in
              if (index % 2 == 0) {
                NavigationLink {
                    AlbumsScreen()
//                    PhotosList()
                } label: {
                  AlbumPreview(album: album, isFavorite: false)
                }
                .buttonStyle(PlainButtonStyle())
              }
            }
          }
          .padding(.horizontal)
          
            
          HStack(alignment: .top, spacing: 10) {
            NavigationLink {
                AlbumsScreen()
//              PhotosList()
            } label: {
                AlbumPreview(album: Album(id: 17, name: "Favorites", pictureNames: ["turtlerock"]), isFavorite: true)
            }
            .buttonStyle(PlainButtonStyle())
              
            ForEach(Array(albums.enumerated()), id: \.element) { index, album in
              if (index % 2 != 0) {
                NavigationLink {
                    AlbumsScreen()
//                  PhotosList()
                } label: {
                  AlbumPreview(album: album, isFavorite: false)
                }
                .buttonStyle(PlainButtonStyle())
              }
            }
          }
          .padding(.horizontal)
          .scrollTargetLayout()
            
        }
      }
      .scrollTargetBehavior(.viewAligned)
    }
    .padding(.bottom, 30)
    .listRowInsets(EdgeInsets())
  }
}

#Preview {
  AlbumRow(rowTitle: "Mes Albums", albums: [
    Album(id: 01, name: "Vacances", pictureNames: ["turtlerock", "truc", "03"]),
    Album(id: 02, name: "Soirée", pictureNames: ["turtlerock", "02"]),
  ], afficherToutButton: true)
}
