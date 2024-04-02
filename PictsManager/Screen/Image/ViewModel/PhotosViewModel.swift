//
//  PhotosViewModel.swift
//  PictsManager
//
//  Created by Stevens on 02/04/2024.
//

import Foundation

class PhotosViewModel: ObservableObject {

    @Published var errorMessage: String? = ""
    @Published var pictures = [Picture]()

    func getPicturesList() async {
        print(Api.Auth.me)
        guard let url = URL(string: Api.Picture.pictureList) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL for pictures endpoint"
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let token = UserSessionManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "User not authenticated"
            }
            return
        }
        

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch pictures data"
                }
                return
            }

            let picturesResponse = try JSONDecoder().decode([String: [Picture]].self, from: data)
            DispatchQueue.main.async {
                self.pictures = picturesResponse["pictures"] ?? []
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
