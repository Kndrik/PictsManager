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
    
    /// Update username & email. This will send the whole User object since this is a PUT
    func putUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) async {
        guard let url = URL(string: Api.User.me) else {
            Logger.user.debug("Invalid URL for updateUser endpoint")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        
        if let token = UserSessionManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            Logger.user.error("User not authenticated")
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var requestBody: Encodable
                
        if (username != user?.username || email != user?.email){
            request.httpMethod = "PUT"
            requestBody = UpdateUserForm(email: email, username: username, password: password)
        } else {
            return
        }
        
        if let jsonData = try? JSONEncoder().encode(requestBody) {
            request.httpBody = jsonData
        } else {
            Logger.user.error("Failed to encode user data")
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
                if (try? JSONDecoder().decode(UpdateUserForm.self, from: data)) != nil {
                    completion(true)
                }
            } else {
                if let errorMessage = String(data: data, encoding: .utf8) {
                    Logger.auth.error("\(errorMessage)")
                } else {
                    Logger.auth.error("\(error?.localizedDescription ?? "Unknown error")")
                }
                completion(false)
            }
        }.resume()
    }
    
    /// Update password. This method requires only a password since this is a PATCH
    func patchUser(oldpassword: String, newpassword: String, completion: @escaping (Bool) -> Void) async {
        guard let url = URL(string: Api.User.me) else {
            Logger.user.debug("Invalid URL for updateUser endpoint")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        
        if let token = UserSessionManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            Logger.user.error("User not authenticated")
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var requestBody: Encodable
        
        if (!oldpassword.isEmpty && !newpassword.isEmpty) {
            request.httpMethod = "PATCH"
            requestBody = UpdatePasswordForm(old_password: oldpassword, new_password: newpassword)
        } else {
            completion(false)
            return
        }
                
        if let jsonData = try? JSONEncoder().encode(requestBody) {
            request.httpBody = jsonData
        } else {
            Logger.user.error("Failed to encode user data")
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
                if (try? JSONDecoder().decode(UpdateUserForm.self, from: data)) != nil {
                    completion(true)
                }
            } else {
                if let errorMessage = String(data: data, encoding: .utf8) {
                    Logger.auth.error("\(errorMessage)")
                } else {
                    Logger.auth.error("\(error?.localizedDescription ?? "Unknown error")")
                }
                completion(false)
            }
        }.resume()
    }
}
        
