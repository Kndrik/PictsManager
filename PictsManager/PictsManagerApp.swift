//
//  PictsManagerApp.swift
//  PictsManager
//
//  Created by Charles Lamarque on 04/03/2024.
//

import SwiftUI

@main
struct PictsManagerApp: App {
    @StateObject var toastManager = ToastManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(toastManager)
        }
    }
}

