//
//  ImageFetcher.swift
//  PictsManager
//
//  Created by Charles Lamarque on 07/04/2024.
//

import Foundation
import SwiftUI
import OSLog

class ImageFetcher: ObservableObject {
    @Published var imageData: Data?
    
    let urlString = Api.Picture.pictureList
    
    enum FetchError: Error {
        case badRequest
        case badJSON
    }
    
    func fetchImage(picture_id: String, lowRes: Bool = false) async
    throws {
        guard let url = URL(string: urlString + "\(picture_id)" + (lowRes ? "/low" : "")) else {
            Logger.imageFetcher.debug("Invalid URL for low picture endpoint")
            return
        }
        
        guard let token = UserSessionManager.shared.getToken() else {
            Logger.imageFetcher.error("User not authenticated")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
        
        DispatchQueue.main.async {
            self.imageData = data
        }
    }
  
  func fetchSharedImage(album_id: String, picture_id: String, lowRes: Bool = false) async throws {
    guard let url = URL(string: Api.Album.albumList + album_id + "/" + picture_id + (lowRes ? "/low" : "")) else {
      Logger.imageFetcher.debug("Invalid URL for low shared picture endpoint")
      return
    }
    
    guard let token = UserSessionManager.shared.getToken() else {
      Logger.imageFetcher.error("User not authenticated")
      return
    }
    
    var request = URLRequest(url: url)
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
    
    DispatchQueue.main.async {
      self.imageData = data
    }
  }
}
