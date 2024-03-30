//
//  Album.swift
//  PictsManager
//
//  Created by Charles Lamarque on 18/03/2024.
//

import Foundation
import SwiftUI

struct Album: Hashable, Codable, Identifiable {
  var id: Int
  var name: String
  var pictureNames: [String]
  var pictures: [Image] {
    pictureNames.compactMap{ pictureName in
      Image(pictureName)
    }
  }
}
