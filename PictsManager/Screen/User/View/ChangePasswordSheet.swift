//
//  ChangePasswordSheet.swift
//  PictsManager
//
//  Created by Minh Duc on 29/04/2024.
//

import Foundation
import SwiftUI

struct ChangePasswordSheet: View {
    @StateObject var userViewModel = UserViewModel()
    @Binding var isShowingSheet: Bool
    @Binding var oldPassword: String
    @Binding var newPassword: String
    @EnvironmentObject private var toastManager: ToastManager
    
    var body: some View {
        VStack {
            SecureField("Old Password", text: $oldPassword)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            SecureField("New Password", text: $newPassword)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            HStack {
                Button("Dismiss", action: { isShowingSheet.toggle() })
                    .bold()
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                
                Button("Confirm", action: {
                    Task {
                        await userViewModel.patchUser(oldpassword: oldPassword, newpassword: newPassword) { success in
                            DispatchQueue.main.async {
                                if success {
                                    toastManager.toast = Toast(style: .success, message: "Fields are modified with success")
                                } else {
                                    toastManager.toast = Toast(style: .error, message: "Error occured")
                                }
                            }
                        }
                    }
                    isShowingSheet.toggle()
                })
                .bold()
                .font(.subheadline)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.green)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
        }
        .presentationDetents([.height(200)])
        .padding()
    }
}
