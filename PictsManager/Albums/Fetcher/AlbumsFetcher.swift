//
//  AlbumsFetcher.swift
//  PictsManager
//
//  Created by Charles Lamarque on 02/04/2024.
//

import SwiftUI
import OSLog

class AlbumsFetcher: ObservableObject {
  @Published var albumsData: AlbumCollection?
  
  let urlString = Api.Album.albumList
  
  enum FetchError: Error {
    case badRequest
    case badJSON
  }
  
<<<<<<< Updated upstream
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
=======
  func fetchAlbums() async {
      guard let url = URL(string: Api.Album.albumList) else {
          Logger.album.debug("Invalid URL for /album endpoint")
          return
      }
      
      guard let token = UserSessionManager.shared.getToken() else {
          Logger.user.error("User not authenticated")
          return
      }
      
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      
      do {
          let (data, response) = try await URLSession.shared.data(for: request)
          if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
              let decodedAlbum = try JSONDecoder().decode(AlbumCollection.self, from: data)
              DispatchQueue.main.async {
                  self.albumsData = AlbumCollection(albums: decodedAlbum.albums)
                  Logger.album.info("flkaznflkaznflanfa")
              }
          } else {
              Logger.user.error("Failed to fetch album data")
          }
      } catch {
          Logger.user.error("Error fetching album data: \(error.localizedDescription)")
>>>>>>> Stashed changes
      }
  }
}
