//
//  PhotosList.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct PhotosList: View {
    @Binding var photos: [Photo]
    var photoListName: String
    @State private var selectedPhoto: Photo?

    var body: some View {
        let columns = Array(repeating: GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 5), count: 3)

        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(photos.indices, id: \.self) { index in
                        NavigationLink(destination: ImageDetail(photo: photos[index])) {
                            ImageLoader(photo: photos[index])
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .clipped()
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
                Color.clear.frame(height: 55)
            }
            .navigationTitle(photoListName)
        }
    }
}

struct ImageLoader: View {
    var photo: Photo
    var body: some View {
        photo.image?
            .resizable()
            .rotationEffect(.degrees(90))
    }
}

struct ImageDetail: View {
    var photo: Photo
    @StateObject var imageDetailsViewModel = ImageDetailsViewModel()
    @State private var isLiked = false

    var body: some View {
        ZStack {
            imageDetailsViewModel.image?
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(90))

            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        //shareImage()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 30, weight: .semibold))
                                .padding()
                    }

                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 30, weight: .semibold))
                                .padding()
                                .foregroundColor(isLiked ? .red : .gray)
                    }
                    Button(action: {
                        // deleteImage()
                    }) {
                        Image(systemName: "trash")
                                .font(.system(size: 30, weight: .semibold))
                                .padding()
                                .foregroundColor(.red)
                    }
                }
            }
        }
                .onAppear {
                    Task {
                        await imageDetailsViewModel.getPictureById(pictureId: photo.id)
                    }
                }
    }

}
