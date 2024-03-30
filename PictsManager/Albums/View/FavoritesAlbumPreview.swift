//
//  FavoritesAlbumPreview.swift
//  PictsManager
//
//  Created by Charles Lamarque on 19/03/2024.
//

import SwiftUI

struct FavoritesAlbumPreview: View {
  var album: Album
  
  var body: some View {
    VStack(alignment: .leading) {
      album.pictures[0]
        .renderingMode(.original)
        .resizable()
        .frame(width: 170, height: 170)
        .cornerRadius(3)
        .overlay(alignment: .bottomLeading) {
          Image(systemName: "heart.fill")
            .foregroundStyle(Color.white)
            .padding(5)
        }
      Text(album.name)
        .padding(.bottom, -8)
      Text(String(album.pictureNames.count))
        .foregroundStyle(Color.gray)
    }
  }
}

#Preview {
  FavoritesAlbumPreview(album: Album(id: 12, name: "Vacances", pictureNames: ["twinlake", "02", "03", "04", "05", "06", "07", "07","07","07","07","07","07","07","07","07","07","07","07"]))
}
