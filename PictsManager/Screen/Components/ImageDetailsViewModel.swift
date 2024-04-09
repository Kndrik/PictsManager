//
//  PhotoListViewModel.swift
//  PictsManager
//
//  Created by Stevens on 08/04/2024.
//

import Foundation
import SwiftUI

class ImageDetailsViewModel: ObservableObject {

    @Published var errorMessage: String? = ""
    @Published var image: Image? = nil

    func getPictureById(pictureId: String) async {
        guard let url = URL(string: Api.Picture.pictureList + pictureId) else {
            await updateErrorMessage("Invalid URL for pictures endpoint")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let token = UserSessionManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            await updateErrorMessage("User not authenticated")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                await updateErrorMessage("Failed to fetch pictures data")
                return
            }

            if let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.image = Image(uiImage: uiImage)
                }
            }
        } catch {
            await updateErrorMessage(error.localizedDescription)
        }
    }

    private func updateErrorMessage(_ message: String) async {
        await MainActor.run {
            self.errorMessage = message
        }
    }

    func deletePictureById(pictureId: String) async -> Bool {
        guard let url = URL(string: Api.Picture.pictureList + pictureId) else {
            await updateErrorMessage("Invalid URL for pictures endpoint")
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        if let token = UserSessionManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            await updateErrorMessage("User not authenticated")
            return false
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                await updateErrorMessage("Failed to delete picture")
                return false
            }

            return true
        } catch {
            await updateErrorMessage(error.localizedDescription)
            return false
        }
    }
    

}
