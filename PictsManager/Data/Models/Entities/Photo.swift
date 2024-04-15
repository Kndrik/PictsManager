//
//  Photo.swift
//  PictsManager
//
//  Created by Stevens on 02/04/2024.
//

import SwiftUI

struct Photo: Identifiable, Decodable {
    let date: String
    let filename: String
    let id: String
    let location: String?
    let owner_id: String
    let viewers_ids: [String]
    var imageData: Data?
    var image: Image? {
        if let imageData = imageData {
            if let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            }
        }
        return nil
    }
}
