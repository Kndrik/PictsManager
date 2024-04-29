//
//  PhotosList.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct PhotosView: View {
    @StateObject var photosViewModel = PhotosViewModel()
    @State private var selectedPeriodIndex = 3
    let periodTitles = [PeriodConstants.years, PeriodConstants.months, PeriodConstants.days, PeriodConstants.all]

    var body: some View {
        ZStack {
            VStack {
                HStack {
    
                    Text(periodTitles[selectedPeriodIndex])
                      .bold()
                      .font(.title2)
                  
                  Spacer()
                    
                    HStack {
                        Button(action: {
                            print("tapped")
                        }) {
                            Text("Sélectionner")
                                .bold()
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(.gray)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                        
                        Button {
                            print("tapped")
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        .background(.white)
                        .foregroundColor(.gray)
                        .cornerRadius(25)
                    }
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                
                Spacer()
                
                PhotosList(photos: $photosViewModel.pictures)
            }
        }
        .onAppear {
            Task {
                await photosViewModel.getPicturesList()
            }
        }
    }
}

#Preview {
    PhotosView()
}
