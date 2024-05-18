//
//  PhotosSelectionToAlbum.swift
//  PictsManager
//
//  Created by Minh Duc on 13/05/2024.
//

import Foundation
import SwiftUI

struct PhotosSelectionToAlbum: View {
    @StateObject var photosViewModel = PhotosViewModel()
    @StateObject var albumsViewModel = AlbumsViewModel()
    @Binding var isShowingSheet: Bool
    @State private var selectedPhotos: [String] = []
    @State var album: Album
    var onAddPhotos: ([Photo]) -> Void
    @State private var showErrorAlert = false

    var body: some View {
        let columns = Array(repeating: GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 5), count: 3)
        let photos = photosViewModel.pictures
        
        ZStack {
            VStack {
                HStack {
                    Text("Add photos to your album")
                        .bold()
                        .font(.title2)
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            print("Selected photos: \(selectedPhotos)")
                            Task {
                                for photoId in selectedPhotos {
                                    print(photoId)
                                    await albumsViewModel.uploadImagesToAlbum(picture_id: photoId, album_id: album.id ?? "") { success in
                                        DispatchQueue.main.async {
                                            if success {
                                                print("success")
                                            } else {
                                                print("lol")
                                                showErrorAlert = true
                                            }
                                        }
                                    }
                                    isShowingSheet = false
                                }
                            }
                        }) {
                            Text("Add")
                                .bold()
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                        
                        Button(action: {
                            isShowingSheet = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(photos.indices, id: \.self) { index in
                        let photo = photos[index]
                        PhotoListToAdd(photo: photo, isSelected: selectedPhotos.contains(photo.id)) {
                            if let index = selectedPhotos.firstIndex(of: photo.id) {
                                selectedPhotos.remove(at: index)
                            } else {
                                selectedPhotos.append(photo.id)
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            Task {
                await photosViewModel.getPicturesList()
            }
        }
    }
}


struct PhotoListToAdd: View {
    let photo: Photo
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        ZStack {
            ImageLoader(photo: photo)
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .aspectRatio(1, contentMode: .fit)
            
            if isSelected {
                Color.black.opacity(0.3)
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .onTapGesture {
            onSelect()
        }
    }
}
