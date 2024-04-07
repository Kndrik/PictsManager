//
//  PhotosList.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct PhotosList: View {
    @Binding var images: [Image]
    @State private var selectedImage: Image?
    @State private var isImageSelected: Bool = false

    func close() -> Void {
        selectedImage = nil
        isImageSelected = false
    }

    var body: some View {
        let columns = Array(repeating: GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 5), count: 3)

        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(images.indices, id: \.self) { index in
                    ImageLoader(image: images[index])
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                            .onTapGesture {
                                selectedImage = images[index]
                                isImageSelected = true
                            }
                }
            }
            Color.clear.frame(height: 55)
        }.fullScreenCover(isPresented: $isImageSelected) {
                    VStack {
                        Button(action: {
                            isImageSelected = false
                        }) {
                            Image(systemName: "chevron.left")
                                    .font(.system(size: 30, weight: .semibold))
                                    .padding()
                        }
                        Spacer()
                        if let selectedImage = selectedImage {
                            ImageDetail(image: selectedImage)
                        }
                        Spacer()
                    }
                }
    }
}

struct ImageLoader: View {
    var image: Image
    var body: some View {
        image
                .resizable()
                .rotationEffect(.degrees(90))
    }
}

struct ImageDetail: View {
    var image: Image
    var body: some View {
        image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(90))
    }
}