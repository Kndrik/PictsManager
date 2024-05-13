//
//  CameraScreen.swift
//  PictsManager
//
//  Created by Stevens on 19/03/2024.
//

import SwiftUI

struct CameraScreen: View {
    @State private var capturedImage: UIImage? = nil
    @State private var isCustomCameraViewPresented = false

    var body: some View {
        ZStack {
            CustomCameraView(capturedImage: $capturedImage)
        }
              
    }
}
