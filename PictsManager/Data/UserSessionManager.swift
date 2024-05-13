//
//  UserSessionManager.swift
//  PictsManager
//
//  Created by Stevens on 12/03/2024.
//

import Foundation

class UserSessionManager {
    static let shared = UserSessionManager()

    private let tokenKey = "AuthToken"

    func getToken() -> String? {
        return authToken
    }
    
    var isAuthenticated: Bool {
        return authToken != nil
    }

    private var authToken: String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }

    func saveAuthToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    func clearSession() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
