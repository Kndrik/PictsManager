//
//  AlbumRow.swift
//  PictsManager
//
//  Created by Charles Lamarque on 18/03/2024.
//

import SwiftUI

struct AlbumRow: View {
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
        VStack {
          HStack(alignment: .top, spacing: 10) {
            ForEach(albums) { album in
              NavigationLink {
                AlbumPhotosView(album: album, isShared: true)
              } label: {
                AlbumPreview(album: album, isFavorite: false, isShared: true)
              }
              .buttonStyle(PlainButtonStyle())
            }
          }
          .padding(.horizontal)
         // .scrollTargetLayout()
        }
      }
     // .scrollTargetBehavior(.viewAligned)
        
    }
    .padding(.bottom, 30)
    .listRowInsets(EdgeInsets())
  }
}
/*
#Preview {
  AlbumRow(rowTitle: "Mes Albums", albums: [
    Album(id: "6611aef73a0ad873ade492d2", owner_id: "6611aa943a0ad873ade492d1", pictures: [Photo(date: String("2024-04-09T12:21:41.145720"), filename: "test", id: "66129b60fea686857a14f12b", location: nil, owner_id: "660038c19431446698d6d4b6", viewers_ids: [], imageData: nil)], title: "Parfums", viewers_ids: [])
  ], afficherToutButton: true)
}*/

