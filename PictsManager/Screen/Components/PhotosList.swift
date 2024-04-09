//
//  PhotosList.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct PhotosList: View {
    @Binding var photos: [Photo]
    @State private var selectedPhoto: Photo?
    @State private var isPhotoSelected: Bool = false

    var body: some View {
        let columns = Array(repeating: GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 5), count: 3)

        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(photos.indices, id: \.self) { index in
                    ImageLoader(photo: photos[index])
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .clipped()
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                            selectedPhoto = photos[index]
                            isPhotoSelected = true
                        }
                }
            }
            Color.clear.frame(height: 55)
        }.fullScreenCover(isPresented: $isPhotoSelected) {
            VStack {
                Button(action: {
                    isPhotoSelected = false
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 30, weight: .semibold))
                        .padding()
                }
                Spacer()
                if let selectedPhoto = selectedPhoto {
                    ImageDetail(photo: selectedPhoto)
                }
                Spacer()
            }
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
    var body: some View {
        VStack {
            imageDetailsViewModel.image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(90))
        }.onAppear {
            Task {
                await imageDetailsViewModel.getPictureById(pictureId: photo.id)
            }
        }
    }
}
