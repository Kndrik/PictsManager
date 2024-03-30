//
//  CustomCameraView.swift
//  PictsManager
//
//  Created by Stevens on 19/03/2024.
//

import SwiftUI

struct CustomCameraView: View {
    
    let cameraViewModel = CameraViewModel()
    @Binding var capturedImage: UIImage?
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            CameraView(cameraViewModel: cameraViewModel) { result in
                switch result {
                case .success(let photo):
                    if let data = photo.fileDataRepresentation() {
                        capturedImage = UIImage(data: data)
                        presentationMode.wrappedValue.dismiss()
                        if let image = capturedImage {
                            cameraViewModel.uploadImage(paramName: "file", fileName: "taken_with_picts_manager.png", image: image)
                        }
                    } else {
                        print("Error: no image data found")
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }


            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        //TODO check gallery
                    }, label: {
                        Image(systemName: "circle.fill")
                                .frame(width: 25.0)
                                .font(.system(size: 15))
                                .foregroundColor(.black)
                                .padding()
                    })
                            .background(Color.black.opacity(1))
                            .clipShape(Circle())
                    
                    Button(action: {
                        cameraViewModel.capturePhoto()
                    }, label: {
                        Image(systemName: "circle")
                                .font(.system(size: 72))
                                .foregroundColor(.white)
                                .padding(.bottom)
                    })
                    
                    Button(action: {
                        cameraViewModel.switchCamera()
                    }, label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .frame(width: 25.0)
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .padding()
                    })
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                
                    Spacer()
                }
            }
        }
    }
}

