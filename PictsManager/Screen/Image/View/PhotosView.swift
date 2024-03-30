//
//  Photos.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct Photos: View {

    var body: some View {

        ZStack {
                PhotosList()
            VStack{
                Spacer()
                PeriodSelector()
            }
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    Photos()
}
