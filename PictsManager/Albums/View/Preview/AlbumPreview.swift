//
//  AlbumPreview.swift
//  PictsManager
//
//  Created by Charles Lamarque on 18/03/2024.
//

import SwiftUI

struct AlbumPreview: View {
  var album: Album
  
  var body: some View {
    VStack(alignment: .leading) {
      album.pictures[0]
        .renderingMode(.original)
        .resizable()
        .frame(width: 170, height: 170)
        .cornerRadius(3)
      Text(album.name)
        .padding(.bottom, -8)
      Text(String(album.pictureNames.count))
        .foregroundStyle(Color.gray)
    }
  }
}

#Preview {
  AlbumPreview(album: Album(id: 12, name: "Vacances", pictureNames: ["twinlake", "02", "03", "04", "05", "06", "07", "07","07","07","07","07","07","07","07","07","07","07","07"]))
}
