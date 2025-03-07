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
  var isShared: Bool
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
      } else {
        Rectangle()
          .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
          .frame(width: 170, height: 170)
          .cornerRadius(3)
          .overlay(alignment: .center) {
            Image(systemName: "photo")
          }
      }
      Text(album.title)
        .padding(.bottom, -8)
      Text(String(album.pictures.count))
        .foregroundStyle(Color.gray)
    }
    .task {
      do {
        if (isShared && album.cover_id != nil) {
          try await imageFetcher.fetchSharedImage(album_id: album.id ?? "", picture_id: album.cover_id ?? "")
        } else if (album.cover_id != nil) {
          try await imageFetcher.fetchImage(picture_id: album.cover_id ?? "", lowRes: true)
        }
      } catch {
        print("Error fetching image: \(error)")
      }
    }
  }
}

/*

#Preview {

    var photo = [Photo(date: "2024-04-09T12:21:41.145720", filename: "test", id: "66129b60fea686857a14f12b", location: nil, owner_id: "660038c19431446698d6d4b6", viewers_ids: [], imageData: nil)]
        
  AlbumPreview(album: Album(id: "1234", cover_id: "66129b60fea686857a14f12b", owner_id: "6611aa943a0ad873ade492d1", pictures: photo, title: "Parfums", viewers_ids: []), isFavorite: true)
}
*/
