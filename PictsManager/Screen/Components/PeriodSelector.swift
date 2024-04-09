//
//  PeriodSelector.swift
//  PictsManager
//
//  Created by Valentin Caure on 12/03/2024.
//

import SwiftUI

struct PeriodSelector: View {
    @State private var selectedItem = 3
    @State private var itemWidths: [CGFloat] = Array(repeating: 0, count: 4)

    let items = ["Années", "Mois", "Jours", "Toutes les photos"]

    func getSelectedItem() -> Int {
        return selectedItem
    }

    var body: some View {

        HStack (spacing: 0) {

            ForEach(Array(items.enumerated()), id: \.offset) { index, text in
                Text(text)
                    .bold()
                    .onTapGesture {
                        withAnimation {
                            selectedItem = index
                        }
                    }
                    .padding([.vertical], 5)
                    .padding([.horizontal], 8)
                    .foregroundColor(selectedItem != index ?
                        .gray : .white
                    )
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: WidthPreferenceKey.self,
                                value: [WidthPreferenceData(index: index, width: geometry.size.width)]
                            )
                        }
                    )
            }
        }
        .onPreferenceChange(WidthPreferenceKey.self) { preferences in
            preferences.forEach { data in
                itemWidths[data.index] = data.width
            }
        }
        .background(
            Capsule()
                .frame(width: itemWidths[selectedItem], height: 30)
                .fixedSize()
                .foregroundColor(
                    .init(cgColor: CGColor(gray: 0.3, alpha: 0.8))
                )
                .offset(x: CGFloat(itemWidths[..<selectedItem].reduce(0, +)))
                .animation(.easeInOut(duration: 0.2), value: selectedItem),
            alignment: .leading
        )
        .padding(5)
        .background(
            Capsule().frame(height: 40).foregroundColor(.init(cgColor: CGColor(gray: 0.1, alpha: 0.8)))
        )
    }
}

struct WidthPreferenceData: Equatable {
    let index: Int
    let width: CGFloat
}


struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: [WidthPreferenceData] = []

    static func reduce(value: inout [WidthPreferenceData], nextValue: () -> [WidthPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

#Preview {
    PeriodSelector()
}
