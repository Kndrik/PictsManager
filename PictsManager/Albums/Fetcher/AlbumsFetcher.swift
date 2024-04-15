//
//  AlbumsFetcher.swift
//  PictsManager
//
//  Created by Charles Lamarque on 02/04/2024.
//

import SwiftUI

class AlbumsFetcher: ObservableObject {
  @Published var albumsData: AlbumCollection?
  
  let urlString = Api.Album.albumList
  
  enum FetchError: Error {
    case badRequest
    case badJSON
  }
  
  func fetchAlbums() async
  throws {
    guard let url = URL(string: urlString) else { return }
    
    var request = URLRequest(url: url)
    request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MTFhYTk0M2EwYWQ4NzNhZGU0OTJkMSJ9.ccKyeJlInJ5Rs9QzuYktxhp5V61bc0iTOifaqaVvH2A", forHTTPHeaderField: "Authorization")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
    
    Task { @MainActor in
      do {
        albumsData = try JSONDecoder().decode(AlbumCollection.self, from: data)
        print(albumsData?.albums)
      } catch {
        print("Error decoding json: \(error)")
      }
    }
  }
}