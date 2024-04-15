//
//  AlbumPreview.swift
//  PictsManager
//
//  Created by Charles Lamarque on 18/03/2024.
//

import SwiftUI

struct AlbumPreview: View {
  var album: Album
  var isFavorite: Bool
  @StateObject private var imageFetcher = ImageFetcher()
  
  var body: some View {
    VStack(alignment: .leading) {
      if let data = imageFetcher.imageData, let uiImage = UIImage(data: data) {
          Image(uiImage: uiImage)
          .renderingMode(.original)
          .resizable()
          .frame(width: 170, height: 170)
          .cornerRadius(3)
          .overlay(alignment: .bottomLeading) {
            isFavorite ?
                Image(systemName: "heart.fill")
                  .foregroundStyle(Color.white)
                  .padding(5)
            : nil
          }
        Text(album.title)
          .padding(.bottom, -8)
        Text(String(album.pictures_ids.count))
          .foregroundStyle(Color.gray)
      } else {
          Image(systemName: "photo")
      }
    }
    .task {
      do {
        try await imageFetcher.fetchImage(picture_id: album.cover_id ?? "66129b60fea686857a14f12b")
        
      } catch {
        print("Error fetching image: \(error)")
      }
    }
  }
}

#Preview {
  AlbumPreview(album: Album(id: "1234", cover_id: "66129b60fea686857a14f12b", owner_id: "6611aa943a0ad873ade492d1", pictures_ids: [
    "66129b60fea686857a14f12b",
    "66129b67fea686857a14f12c",
    "6611b3b53a0ad873ade492d6",
    "6611b3b83a0ad873ade492d7"
  ], title: "Parfums", viewers_ids: []), isFavorite: true)
}
