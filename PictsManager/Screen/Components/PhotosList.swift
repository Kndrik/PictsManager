//
//  PhotosList.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct PhotosList: View {
    @Binding var photos: [Photo]
    @State var picture_ids: [String]?
    @State private var selectedPhoto: Photo?
    var isShared: Bool
    var albumId: String

    var body: some View {
        let columns = Array(repeating: GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 5), count: 3)

        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(photos.indices, id: \.self) { index in
                      NavigationLink(destination: ImageDetails(photo: photos[index],photos: $photos, isShared: isShared, albumId: albumId)) {
                            ImageLoader(photo: photos[index])
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .clipped()
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
                Color.clear.frame(height: 55)
                
                Spacer()
                Text("\(photos.count) photos")
                    .bold()
            }
        }
    }
}

struct ImageLoader: View {
    var photo: Photo
    @State private var isLoading = true

    var body: some View {
        Group {
            if photo.image == nil {
                ProgressView()
            } else {
                photo.image?.resizable()
            }
        }
    }
}

