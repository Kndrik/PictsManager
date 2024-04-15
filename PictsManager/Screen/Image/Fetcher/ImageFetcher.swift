//
//  ImageFetcher.swift
//  PictsManager
//
//  Created by Charles Lamarque on 07/04/2024.
//

import Foundation
import SwiftUI

class ImageFetcher: ObservableObject {
  @Published var imageData: Data?
  
  let urlString = Api.Picture.pictureList
  
  enum FetchError: Error {
    case badRequest
    case badJSON
  }
  
  func fetchImage(picture_id: String) async
  throws {
    guard let url = URL(string: urlString + "/\(picture_id)") else { return }
    
    var request = URLRequest(url: url)
    request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MTFhYTk0M2EwYWQ4NzNhZGU0OTJkMSJ9.ccKyeJlInJ5Rs9QzuYktxhp5V61bc0iTOifaqaVvH2A", forHTTPHeaderField: "Authorization")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }

    print(data)
    imageData = data
  }
}
