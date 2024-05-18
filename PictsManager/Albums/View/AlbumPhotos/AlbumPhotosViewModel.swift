//
//  AlbumPhotoViewModel.swift
//  PictsManager
//
//  Created by Stevens on 23/04/2024.
//

import Foundation
import SwiftUI
import OSLog

class AlbumPhotosViewModel: ObservableObject {

    @Published var errorMessage: String? = ""
    @Published var pictures = [Photo]()
    enum FetchError: Error {
      case badRequest
      case badJSON
    }

    func updatePhotoWithImage(id: String, imageData: Data)  async {
        if let index = pictures.firstIndex(where: { $0.id == id }) {
            DispatchQueue.main.async {
                self.pictures[index].imageData = imageData
            }
        }
    }

    func getLowPicturesById(pictureId: String) async -> Data? {
        guard let url = URL(string: Api.Picture.pictureList + pictureId + "/low") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL for pictures endpoint"
            }
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let token = UserSessionManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "User not authenticated"
            }
            return nil
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch pictures data"
                }
                return nil
            }

            return data
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            return nil
        }
    }
  
  func getLowPictureByAlbumId(albumId: String, pictureId: String) async -> Data? {
    guard let url = URL(string: Api.Album.albumList + albumId + "/" + pictureId + "/low") else {
      DispatchQueue.main.async {
        self.errorMessage = "Invalid URL for shared low pictures endpoint"
      }
      return nil
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    if let token = UserSessionManager.shared.getToken() {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    } else {
        DispatchQueue.main.async {
            self.errorMessage = "User not authenticated"
        }
        return nil
    }
    
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, 
        httpResponse.statusCode == 200 else {
        DispatchQueue.main.async {
          self.errorMessage = "Failed to fetch shared picture data"
        }
        return nil
      }
      
      return data
    } catch {
      await MainActor.run {
        self.errorMessage = error.localizedDescription
      }
      return nil
    }
  }
  
  func shareAlbumWithUser(albumId: String, email: String) async throws {
    guard let url = URL(string: Api.Album.albumList + albumId + "/share") else {
      Logger.album.debug("Invalid URL for /albums endpoint")
      return
    }
    
    guard let token = UserSessionManager.shared.getToken() else {
      Logger.user.error("User not authenticated")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let sharingRequest = AlbumSharing(email: email)
    
    let bodyJson = try JSONEncoder().encode(sharingRequest)
    request.httpBody = bodyJson
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
  }
}
