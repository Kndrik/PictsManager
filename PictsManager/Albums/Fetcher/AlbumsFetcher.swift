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
    request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MDAzOGMxOTQzMTQ0NjY5OGQ2ZDRiNiJ9.T8PYxixmkz7VFt5n395dF66DeeaRu2xjX4TSn6_xEcQ", forHTTPHeaderField: "Authorization")
  
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
    
    print(String(data: data, encoding: .utf8))
    
    Task { @MainActor in
      do {
        albumsData = try JSONDecoder().decode(AlbumCollection.self, from: data)
        print("Decoded json: \(albumsData)")
      } catch {
        print("Error decoding json: \(error)")
      }
    }
  }
}
