//
//  Logger.swift
//  PictsManager
//
//  Created by Minh Duc on 31/03/2024.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let auth = Logger(subsystem: subsystem, category: String(describing: AuthViewModel.self))
    static let user = Logger(subsystem: subsystem, category: String(describing: UserViewModel.self))
    static let camera = Logger(subsystem: subsystem, category: String(describing: CameraViewModel.self))
    static let album = Logger(subsystem: subsystem, category: String(describing: AlbumsViewModel.self))
    static let imageDetails = Logger(subsystem: subsystem, category: String(describing: ImageDetailsViewModel.self))
    static let imageFetcher = Logger(subsystem: subsystem, category: String(describing: ImageFetcher.self))

}
