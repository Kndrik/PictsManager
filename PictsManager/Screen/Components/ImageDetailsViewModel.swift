//
//  PhotoListViewModel.swift
//  PictsManager
//
//  Created by Stevens on 08/04/2024.
//

import Foundation
import SwiftUI
import OSLog

class ImageDetailsViewModel: ObservableObject {

    @Published var errorMessage: String? = ""
    @Published var image: Image? = nil

    func getPictureById(pictureId: String) async {
        guard let url = URL(string: Api.Picture.pictureList + pictureId) else {
            Logger.imageDetails.error("Invalid URL for pictures endpoint")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let token = UserSessionManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            Logger.imageDetails.error("User not authenticated")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                Logger.imageDetails.error("Failed to fetch pictures data")
                return
            }

            if let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.image = Image(uiImage: uiImage)
                }
            }
        } catch {
            Logger.imageDetails.error("\(error.localizedDescription)")
        }
    }
}
