//
//  Logger.swift
//  PictsManager
//
//  Created by Minh Duc on 31/03/2024.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let auth = Logger(subsystem: subsystem, category: String(describing: UserViewModel.self))
    static let user = Logger(subsystem: subsystem, category: String(describing: UserViewModel.self))
    static let album = Logger(subsystem: subsystem, category: String(describing: UserViewModel.self))
    static let image = Logger(subsystem: subsystem, category: String(describing: UserViewModel.self))
    static let camera = Logger(subsystem: subsystem, category: String(describing: UserViewModel.self))
}
