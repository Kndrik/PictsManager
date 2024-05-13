//
//  ToastStyle.swift
//  PictsManager
//
//  Created by Minh Duc on 18/03/2024.
//

import Foundation
import SwiftUI

enum ToastStyle {
    case error
    case warning
    case success
    case info
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
            case .error: return Color.red
            case .warning: return Color.orange
            case .info: return Color.blue
            case .success: return Color.green
        }
    }
    
    var letterColor: Color {
        switch self {
            case .error: return Color.white
            case .warning: return Color.white
            case .info: return Color.white
            case .success: return Color.white
        }
    }
    
    var iconFileName: String {
        switch self {
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
        }
    }
}
