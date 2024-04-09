//
//  ImageDetails.swift
//  PictsManager
//
//  Created by Stevens on 09/04/2024.
//

import SwiftUI

struct ImageDetails: View {
    var photo: Photo
    @Binding var photos: [Photo]
    @StateObject var imageDetailsViewModel = ImageDetailsViewModel()
    @State private var isLiked = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false

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
                        showingDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                                .font(.system(size: 30, weight: .semibold))
                                .padding()
                                .foregroundColor(.red)
                    }
                }
            }
        }
        .alert(isPresented: $showingDeleteAlert) {
            deleteConfirmationAlert()
        }
        .onAppear {
            Task {
                await imageDetailsViewModel.getPictureById(pictureId: photo.id)
            }
        }
    }

    private func deleteConfirmationAlert() -> Alert {
        Alert(title: Text("Delete Picture"),
              message: Text("Are you sure you want to delete this picture?"),
              primaryButton: .destructive(Text("Delete")) {
                  Task {
                      let success = await imageDetailsViewModel.deletePictureById(pictureId: photo.id)
                      if success {
                          print("Image deleted successfully")
                          if let index = photos.firstIndex(where: { $0.id == photo.id }) {
                              photos.remove(at: index)
                          }
                          presentationMode.wrappedValue.dismiss()
                      } else {
                          print("Failed to delete image")
                      }
                  }
              },
              secondaryButton: .cancel())
    }
}
