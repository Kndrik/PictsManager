//
//  UserViewModel.swift
//  PictsManager
//
//  Created by Minh Duc on 16/03/2024.
//

import Foundation
import OSLog

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var userRepsonse: UserResponse?

    func fetchUser() async {
        guard let url = URL(string: Api.User.me) else {
            Logger.user.debug("Invalid URL for users/me endpoint")
            return
        }
         
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserSessionManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            Logger.user.error("User not authenticated")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decodedUser = try JSONDecoder().decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    self.user = User(_id: decodedUser.id, email: decodedUser.email, username: decodedUser.username, token: UserSessionManager.shared.getToken() ?? "")
                }
            } else {
                Logger.user.error("Failed to fetch user data")
            }
        } catch {
            Logger.user.error("Error fetching user data: \(error.localizedDescription)")
        }
    }
    
    func patchUser() {
        // TODO: PATCH method
        guard let url = URL(string: Api.User.me) else {
            Logger.user.debug("Invalid URL for users/me endpoint")
            return
        }
        
        var request =  URLRequest(url: url)
        request.httpMethod = "PATCH"
    }
}
        
