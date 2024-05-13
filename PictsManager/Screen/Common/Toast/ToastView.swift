//
//  Toast.swift
//  PictsManager
//
//  Created by Minh Duc on 18/03/2024.
//

import Foundation
import SwiftUI

struct ToastView: View {
    
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.letterColor)
            Text(message)
                .font(.caption)
                .foregroundStyle(style.letterColor)
            
            Spacer(minLength: 10)
            
            Button {
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(style.letterColor)
            }
        }
        .padding()
        .background(style.themeColor)
//        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .frame(maxWidth: width)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style.themeColor, lineWidth: 1)
                .opacity(0.8)
        )
        .padding(.horizontal, 16)
    }
}

struct Toast_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 30) {
        ToastView(
            style: .error,
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            onCancelTapped: { print("Canceled") }
        )
        
        ToastView(
          style: .warning,
          message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
          onCancelTapped: { print("Canceled") }
        )
        
        ToastView(
          style: .success,
          message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
          onCancelTapped: { print("Canceled") }
        )
        
        ToastView(
          style: .info,
          message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
          onCancelTapped: { print("Canceled") }
        )
    }
  }
}
