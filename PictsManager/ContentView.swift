//
//  ContentView.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct ContentView: View {    
    @EnvironmentObject var toastManager: ToastManager
    
    var body: some View {
        AuthScreen().environmentObject(toastManager)
    }
}

#Preview {
    ContentView();
}
