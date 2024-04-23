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
    
    func patchUser(username: String? = nil, email: String? = nil) {
        // TODO: PATCH method
        guard let url = URL(string: Api.User.me) else {
            Logger.user.debug("Invalid URL for users/me endpoint")
            return
        }
        
        guard let token = UserSessionManager.shared.getToken() else {
            Logger.user.error("User not authenticated")
            return
        }
        
        var requestBody = [String: String]()
        if let username = username {
            requestBody["username"] = username
        }
        if let email = email {
            requestBody["email"] = email
        }
        
        guard let encodedRequestBody = try? JSONEncoder().encode(requestBody) else {
            return
        }
        
        var request =  URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = /*requestBody*/ encodedRequestBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                Logger.auth.error("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if httpResponse.statusCode == 200 {
                print("User: ", requestBody)
                // TODO: success
//                if let responseData = try? JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
            } else {
                Logger.user.error("error")
            }
        }.resume()
        
        
    }
}
        
