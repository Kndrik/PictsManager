//
//  Album.swift
//  PictsManager
//
//  Created by Charles Lamarque on 18/03/2024.
//

import SwiftUI

//struct Album: Hashable, Codable, Identifiable {
//  var id: Int
//  var name: String
//  var pictureNames: [String]
//  var pictures: [Image] {
//    pictureNames.compactMap{ pictureName in
//      Image(pictureName)
//    }
//  }
//}

struct Album: Hashable, Codable, Identifiable {
  var id: String
  var cover_id: String?
  var owner_id: String
  var pictures_ids: [String]
  var title: String
  var viewers_ids: [String]
}

struct AlbumAPI: Codable, Identifiable {
  var id: String
  var cover_id: String?
  var owner_id: String
  var pictures_ids: [String]
  var title: String
  var viewers_ids: [String]
}

struct AlbumCollection: Codable {
  var albums: [Album]
}
