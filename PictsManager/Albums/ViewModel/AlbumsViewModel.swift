//
//  AlbumsFetcher.swift
//  PictsManager
//
//  Created by Charles Lamarque on 02/04/2024.
//

import SwiftUI
import OSLog

class AlbumsViewModel: ObservableObject {
  @Published var albumsData: AlbumCollection?
  @Published var favAlbumData: Album?
  
  let urlString = Api.Album.albumList
  let favUrlString = Api.Album.favAlbum
  
  enum FetchError: Error {
    case badRequest
    case badJSON
  }
  
  func fetchAlbums() async throws {
    guard let url = URL(string: urlString) else {
      Logger.album.debug("Invalid URL for /albums endpoint")
      return
    }
    
    guard let token = UserSessionManager.shared.getToken() else {
      Logger.user.error("User not authenticated")
      return
    }
    
    var request = URLRequest(url: url)
      
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
    
    Task { @MainActor in
      do {
        albumsData = try JSONDecoder().decode(AlbumCollection.self, from: data)
      } catch {
        Logger.album.error("Error decoding json: \(error)")
      }
    }
  }
  
  func fetchFavAlbum() async throws {
    guard let url = URL(string: favUrlString) else {
      Logger.album.debug("Invalid URL for favorite albums endpoint")
      return
    }
    
    guard let token = UserSessionManager.shared.getToken() else {
      Logger.user.error("User not authenticated")
      return
    }
    
    var request = URLRequest(url: url)
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
    
    Task { @MainActor in
      do {
        favAlbumData = try JSONDecoder().decode(Album.self, from: data)
      } catch {
        Logger.album.error("Error decoding json: \(error)")
      }
    }
  }
  
  func createAlbum(name: String) async throws {
    guard let url = URL(string: urlString) else {
      Logger.album.debug("Invalid URL for /albums endpoint")
      return
    }
    
    guard let token = UserSessionManager.shared.getToken() else {
      Logger.user.error("User not authenticated")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
      
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let albumRequest = AlbumCreation(name: name)
    
    let bodyJson = try JSONEncoder().encode(albumRequest)
    request.httpBody = bodyJson
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
  }
  
  func deleteAlbum(albumId: String) async throws {
    guard let url = URL(string: (urlString+albumId)) else {
      Logger.album.debug("Invalid URL for /albums/album_id endpoint")
      return
    }
    
    guard let token = UserSessionManager.shared.getToken() else {
      Logger.user.error("User not authenticated")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
  }
}
