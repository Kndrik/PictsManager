//
//  RegisterScreen.swift
//  PictsManager
//
//  Created by Minh Duc on 11/03/2024.
//

import Foundation
import SwiftUI

struct RegisterScreen: View {
    @StateObject var viewModel = AuthViewModel()
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isAccountCreated = false
    @EnvironmentObject private var toastManager: ToastManager
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                ScreenLinearColor(gradientTopColor: Color.green)

                VStack {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                    
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                }
                .padding()
                
                Button(action: {
                    Task {
                        viewModel.register(email: email, username: username, password: password)
                        isAccountCreated = UserSessionManager.shared.isAuthenticated
                        
                        if (isAccountCreated == true) {
                            toastManager.toast = Toast(style: .success, message: "Registration sucessful")
                        } else {
                            toastManager.toast = Toast(style: .error, message: "Registration failed")
                        }
                    }
                }) {
                    Text("Register")
                        .font(.headline)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .navigationDestination(isPresented: $isAccountCreated) { Navbar().navigationBarBackButtonHidden(true) }
                
                Spacer()
            }
            .toastView(toast: $toastManager.toast)
        }
        .navigationTitle("Register")
        .onReceive(toastManager.objectWillChange) { _ in
            DispatchQueue.main.async {
                self.toastManager.toast = toastManager.toast
            }
        }
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        let toastManager = ToastManager()
        return RegisterScreen().environmentObject(toastManager)
    }
}
