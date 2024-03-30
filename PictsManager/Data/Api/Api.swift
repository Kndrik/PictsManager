//
//  APIEndpoints.swift
//  PictsManager
//
//  Created by Minh Duc on 11/03/2024.
//

import Foundation

struct Api {
    static let baseURL = "http://127.0.0.1:3000"

    static func endpoint(path: String) -> String {
        return baseURL + path
    }
    
    struct Auth {
        static let login = endpoint(path: "/auth/login")
        static let register = endpoint(path: "/auth/register")
        static let loginWithToken = endpoint(path: "auth/login-with-token")
        static let me = endpoint(path: "/users/me")
    }
    
    struct Picture {
        static let pictureList = endpoint(path: "/pictures")
        static let uploadPicture = endpoint(path: "/pictures/upload")
    }
    
    struct Album {
        static let albumList = endpoint(path: "/albums")
    }
}
