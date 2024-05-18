//
//  PhotosList.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct PhotosList: View {
    @State var photosViewModel: PhotosViewModel
    @Binding var photos: [Photo]
    @State var album: Album?
    @State var picture_ids: [String]?
    @State private var selectedPhoto: Photo?

    var isShared: Bool
    var albumId: String
  
    @Binding var isShowingSheet: Bool
    var onAddPhotos: ([Photo]) -> Void
    let columns = Array(repeating: GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 5), count: 3)
  
    var body: some View {
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
                    
                    Button (action: {
                        isShowingSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 25))
                            .bold()
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                    }
                    .background(.gray)
                    .sheet(isPresented: $isShowingSheet) {
                        if let alb = album {
                            PhotosSelectionToAlbum(isShowingSheet: $isShowingSheet, album: alb) { newPhotos in
                                onAddPhotos(newPhotos)
                            }
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

