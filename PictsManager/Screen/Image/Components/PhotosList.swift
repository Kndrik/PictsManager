//
//  PhotosList.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct PhotosList: View {
    @State private var selectedImage: ImageLoader?
    @State private var isImageSelected: Bool = false
    var pictureURLs: [String]

    func close() -> Void {
        selectedImage = nil
        isImageSelected = false
    }

    var body: some View {
        let columns = Array(repeating: GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 5), count: 3)
        let el = ImageLoader(url: "https://picts-api-dev.hollitizz.me/pictures/65eee9356b9d4a02d93ef595")

        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                
//                ForEach(pictureURLs, id: \.self) { imageURL in
//                    let imageLoader = ImageLoader(url: imageURL)
//                    imageLoader.aspectRatio(contentMode: .fill)
//                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//                        .clipped()
//                        .aspectRatio(1, contentMode: .fit)
//                        .onTapGesture {
//                            selectedImage = el
//                            isImageSelected = true
//                        }
//                }
                    
                ForEach(1...99, id: \.self) { i in

                    el.aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .clipped()
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                            selectedImage = el
                            isImageSelected = true
                        }
                }
            }
            Color.clear.frame(height: 55)
        }
        .fullScreenCover(isPresented: $isImageSelected) {
            Button("", systemImage: "chevron.left", action: close).font(.system(size: 30, weight: .semibold))
            if selectedImage != nil {
                ImageDetail(image: selectedImage!)
            }
        }
    }
}

//#Preview {
//    PhotosList()
//}
    
struct PhotoList_Preview: PreviewProvider {
    static var previews: some View {
        let album = Album(id: 17, name: "Favorites", pictureNames: ["turtlerock", "turtlerock"])
        PhotosList(pictureURLs: album.pictureNames)
    }
}

struct ImageLoader: View {
    var url: String
    var body: some View {
        AsyncImage(url: URL(string: url)
        ) { phase in
            switch phase {
            case .success(let image):
                image.resizable()
            case .failure(_):
                Image(systemName: "xmark").font(.system(size: 30)).foregroundColor(.red)
            case .empty:
                ProgressView()
            @unknown default:
                ProgressView()
            }
        }
    }
}

struct ImageDetail: View {
    var image: ImageLoader
    var body: some View {
        image
    }
}
