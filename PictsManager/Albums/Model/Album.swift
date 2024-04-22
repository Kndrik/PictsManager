//
//  Album.swift
//  PictsManager
//
//  Created by Charles Lamarque on 18/03/2024.
//

import SwiftUI

struct Album: Hashable, Codable, Identifiable {
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
