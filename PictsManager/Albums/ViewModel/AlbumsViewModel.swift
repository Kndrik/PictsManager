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
  @Published var sharedAlbumsData: AlbumCollection?
  
  let urlString = Api.Album.albumList
  let favUrlString = Api.Album.favAlbum
  let sharedUrlString = Api.Album.sharedAlbums
  
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
        Logger.album.error("Error decoding albums json: \(error)")
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
        Logger.album.error("Error decoding fav album json: \(error)")
      }
    }
  }
  
  func fetchSharedAlbums() async throws {
    guard let url = URL(string: sharedUrlString) else {
      Logger.album.debug("Invalid URL for shared albums endpoint")
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
        sharedAlbumsData = try JSONDecoder().decode(AlbumCollection.self, from: data)
      } catch {
        Logger.album.error("Error decoding shared album json: \(error)")
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
    

    func uploadImagesToAlbum(picture_id: String, album_id: String, completion: @escaping (Bool) -> Void) async {
        let uploadString = urlString + album_id

        guard let url = URL(string: uploadString) else {
            Logger.album.debug("Invalid URL for /{album_id} endpoint")
            completion(false)
            return
        }
        
        print(url)
        
        guard let token = UserSessionManager.shared.getToken() else {
            Logger.user.error("User not authenticated")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let imageIdRequest = ImageIdRequest(picture_id: picture_id)
        
        if let bodyJson = try? JSONEncoder().encode(imageIdRequest) {
            request.httpBody = bodyJson
            print(bodyJson)
        } else {
            Logger.album.error("Failed to encode data")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                Logger.user.error("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if (try? JSONDecoder().decode(ImageIdRequest.self, from: data)) != nil {
                    completion(true)
                }
            } else {
                if let errorMessage = String(data: data, encoding: .utf8) {
                    Logger.album.error("\(errorMessage)")
                } else {
                    Logger.album.error("\(error?.localizedDescription ?? "Unknown error")")
                }
                completion(false)
            }
        }.resume()
        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
    }
}
