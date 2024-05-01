//
//  MapView.swift
//  PictsManager
//
//  Created by Minh Duc on 01/05/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        if #available(iOS 17, *) {
            Map()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
