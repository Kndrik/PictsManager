//
//  LoginScreen.swift
//  PictsManager
//
//  Created by Minh Duc on 06/03/2024.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject var viewModel = AuthViewModel()
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @EnvironmentObject private var toastManager: ToastManager
    
    var body: some View {
        NavigationStack {
            VStack {
                ScreenLinearColor(gradientTopColor: Color.blue)
                
                HStack {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                }
                .padding([.leading, .trailing], 20)
                    
                HStack {
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                }
                .padding([.leading, .trailing], 20)
                
                Button(action: {
                    guard !username.isEmpty && !password.isEmpty else {
                        toastManager.toast = Toast(style: .error, message: "Please fill out all fields")
                        return
                    }
                    
                    Task {
                        await viewModel.login(login: username, password: password) { success in
                            isLoggedIn = success
                            DispatchQueue.main.async {
                                if isLoggedIn {
                                    toastManager.toast = Toast(style: .success, message: "Login successful")
                                } else {
                                    toastManager.toast = Toast(style: .error, message: "Login failed")
                                }
                            }
                        }
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .navigationDestination(isPresented: $isLoggedIn) { Navbar().navigationBarBackButtonHidden(true) }
                
                Spacer()
            }
            .toastView(toast: $toastManager.toast)
        }
        .navigationTitle(isLoggedIn ? "" : "Login")
        .navigationBarBackButtonHidden(isLoggedIn)
        .onReceive(toastManager.objectWillChange) { _ in
            DispatchQueue.main.async {
                self.toastManager.toast = toastManager.toast
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        let toastManager = ToastManager()
        return LoginScreen().environmentObject(toastManager)
    }
}
