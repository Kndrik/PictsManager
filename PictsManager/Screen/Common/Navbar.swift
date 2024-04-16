//
//  Navbar.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI



struct Navbar: View {
    @EnvironmentObject var toastManager: ToastManager
    @State private var toast: Toast? = nil
    @StateObject private var albumsViewModel = AlbumsViewModel()
    
    var body: some View {
        VStack {
            TabView {
                PhotosView()
                    .tabItem() {
                        Image(systemName: "photo.fill.on.rectangle.fill")
                        Text("Photothèque")
                    }
                
                AlbumsScreen()
                    .tabItem {
                        Image(systemName: "rectangle.stack.fill")
                        Text("Albums")
                    }
                    .environmentObject(albumsViewModel)
                
                CameraScreen()
                    .tabItem {
                        Image(systemName: "camera")
                        Text("")
                    }
                
                Search()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Rechercher")
                    }
                    .environmentObject(albumsViewModel)
                
                UserScreen(userViewModel: UserViewModel(), authViewModel: AuthViewModel())
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Me")
                    }
            }
        }
        .toastView(toast: $toastManager.toast)
    }
}

struct Navbar_Previews: PreviewProvider {
    static var previews: some View {
        let toastManager = ToastManager()
        return Navbar().environmentObject(toastManager)
    }
}
