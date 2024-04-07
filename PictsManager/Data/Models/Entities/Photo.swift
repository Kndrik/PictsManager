//
//  Photo.swift
//  PictsManager
//
//  Created by Stevens on 02/04/2024.
//

struct Photo: Codable, Identifiable {
    let date: String
    let filename: String
    let id: String
    let location: String?
    let owner_id: String
    let viewers_ids: [String]
}
