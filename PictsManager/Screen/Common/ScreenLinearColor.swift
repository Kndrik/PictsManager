//
//  ScreenColor.swift
//  PictsManager
//
//  Created by Minh Duc on 20/03/2024.
//

import Foundation
import SwiftUI

struct ScreenLinearColor: View {
    @Environment(\.colorScheme) var colorScheme
    let gradientTopColor: Color
    
    var body: some View {
        let solidColor = colorScheme == .dark ? Color.black : Color.white
        
        ZStack(alignment: .top) {
            solidColor.edgesIgnoringSafeArea(.all)
            
            LinearGradient(
                gradient: Gradient(colors: [gradientTopColor.opacity(0.8), Color.clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
