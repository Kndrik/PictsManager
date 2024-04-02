//
//  Search.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct Search: View {
    
    @State private var searchText = ""
    
    private let countries = ["France", "England", "USA", "Vietnam", "Japan", "Korea"]
    
    private var searchResults : [String] {
        searchText.isEmpty ? countries : countries.filter { $0.contains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(searchResults, id: \.self) { country in
                    Text(country)
                }
            }
            .navigationTitle("Rechercher")
            .searchable(text: $searchText)
        }
        
        //        ZStack(content:{
        //            Color.blue
        //
        //            Image.init(systemName: "magnifyingglass")
        //                .foregroundColor(Color.white)
        //                .font(.system(size: 100))
        //        })
    }
}

#Preview {
    Search()
}
