//
//  NavBar.swift
//  PictsManager
//
//  Created by Minh Duc on 16/03/2024.
//

import Foundation
import SwiftUI

struct NavBar: View {
    var body: some View {
        TabView {
            LoginScreen()
                .tabItem {
                    Label("Received", systemImage: "tray.and.arrow.down.fill")
                }
            
            RegisterScreen()
                .tabItem {
                    Label("Received", systemImage: "tray.and.arrow.down.fill")
                }
                    
            UserScreen()
                .tabItem { Label("Received", systemImage: "tray.and.arrow.down.fill") }
        }
    }
}


#Preview {
    NavBar()
}
