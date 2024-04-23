//
//  AlbumPhotoViewModel.swift
//  PictsManager
//
//  Created by Stevens on 23/04/2024.
//

import Foundation
import SwiftUI

class AlbumPhotosViewModel: ObservableObject {

    @Published var errorMessage: String? = ""
    @Published var pictures = [Photo]()

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
}
