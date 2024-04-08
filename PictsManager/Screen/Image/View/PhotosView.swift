//
//  PhotosList.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct PhotosView: View {

    @StateObject var photosViewModel = PhotosViewModel()

    var body: some View {

        ZStack {
            PhotosList(photos: $photosViewModel.pictures)
            VStack{
                Spacer()
                PeriodSelector()
            }
                    .padding(.bottom, 10)
        }.onAppear {
                    Task {
                        if photosViewModel.pictures.isEmpty {
                            await photosViewModel.getPicturesList()
                        }
                    }
                }
    }
}

#Preview {
    PhotosView()
}
