//
//  ToastHelper.swift
//  PictsManager
//
//  Created by Minh Duc on 18/03/2024.
//

import Foundation
import SwiftUI

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
