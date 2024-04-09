//
//  UserScreen.swift
//  PictsManager
//
//  Created by Minh Duc on 16/03/2024.
//

import Foundation
import SwiftUI

struct UserScreen: View {
    
    @StateObject var userViewModel: UserViewModel
    @StateObject var authViewModel: AuthViewModel
    @State private var isEditing = false
    @State private var editableUsername: String = ""
    @State private var editableEmail: String = ""
    @State private var isLoggedOut = false
    @State private var isUserLoaded = false
    @EnvironmentObject private var toastManager: ToastManager

    var body: some View {
        NavigationView {
//            ScreenLinearColor(gradientTopColor: Color.red)
            
            VStack {
                
                Spacer()
        
                TextField("Username", text: /*$viewModel.user.username*/ $editableUsername)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .disabled(!isEditing)
                
                TextField("Email", text: /*$viewModel.user.email*/ $editableEmail)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .disabled(!isEditing)
                
                SecureField("Password", text: /*$viewModel.user.email*/ $editableEmail)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .textCase(.lowercase)
                    .disabled(!isEditing)
                
                Button(action: {
                    authViewModel.logout()
                    isLoggedOut = !UserSessionManager.shared.isAuthenticated
                    toastManager.toast = Toast(style: .info, message: "Logout")
                }) {
                    Text("Logout")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .navigationDestination(isPresented: $isLoggedOut) { AuthScreen().navigationBarBackButtonHidden(true) }
                
                
            }
            .padding()
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            }
            .onReceive(userViewModel.$user) { user in
                if let user = user {
                    editableUsername = user.username
                    editableEmail = user.email
                }
            }
            .onAppear {
                Task {
                    await userViewModel.fetchUser()
                    isUserLoaded = true
                }
            }
            .navigationTitle(isUserLoaded ? "Hi,  \(editableUsername)" : "Loading...")
        }
    }
}

struct UserScreen_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        let toastManager = ToastManager()
        UserScreen(userViewModel: userViewModel, authViewModel: AuthViewModel()).environmentObject(toastManager)
    }
}
