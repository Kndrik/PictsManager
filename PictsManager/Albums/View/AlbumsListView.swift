//
//  AlbumsListView.swift
//  PictsManager
//
//  Created by Charles Lamarque on 25/03/2024.
//

import SwiftUI

struct AlbumsListView: View {
  @State var title: String
  @State var albums: [Album]
    var body: some View {
      NavigationStack {
        ScrollView {
          LazyVGrid(columns: [GridItem(.adaptive(minimum: 175))], spacing: 10) {
            ForEach(albums) { album in
              NavigationLink {
                AlbumsScreen()
              } label: {
                AlbumPreview(album: album, isFavorite: false)
              }
              .buttonStyle(PlainButtonStyle())
            }
          }
        }
        .padding(.horizontal, 15)
      }
      .navigationBarTitle(title, displayMode: .inline)
      .toolbar {
        ToolbarItem() {
          Button {
            print("Modifier")
          } label: {
            Text("Modifier")
          }
        }
      }
    }
}

//#Preview {
//  AlbumsListView(title: "My albums", albums: [Album(id: 29, name: "Vacances", pictureNames: ["turtlerock"]), Album(id: 30, name: "Vacances", pictureNames: ["turtlerock"]), Album(id: 31, name: "Vacances", pictureNames: ["turtlerock"]), Album(id: 32, name: "Vacances", pictureNames: ["turtlerock"])])
//}
