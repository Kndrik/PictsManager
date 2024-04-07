//
//  PhotosList.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct PhotosView: View {

    @StateObject var photosViewModel = PhotosViewModel()
    @State var images: [Image] = []

    var body: some View {

        ZStack {
            PhotosList(images: $images)
            VStack{
                Spacer()
                PeriodSelector()

            }
                    .padding(.bottom, 10)
        }.onAppear {
                    Task {
                        if images.isEmpty {
                            await photosViewModel.getPicturesList()
                            for picture in photosViewModel.pictures {
                                print(picture.id)
                                if let image = await photosViewModel.getLowPicturesById(pictureId: picture.id) {
                                    images.append(image)
                                }
                            }
                        }
                    }
                }
    }
}

#Preview {
    PhotosView()
}
