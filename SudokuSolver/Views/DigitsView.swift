//
//  DigitsView.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 13/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

import SwiftUI

struct DigitsView: View {
    @EnvironmentObject var processor: SudokuProcessor

    /// Whether the non cleaned and normalized cells are shown or the originals.
    @State var isShowingUnprocessed = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Digits")
                .font(.headline)

            VStack(spacing: 2) {
                ForEach(0..<9) { i in
                    HStack(spacing: 2) {
                        ForEach(0..<9) { j in
                            let index = i*9 + j
                            if isShowingUnprocessed {
                                Image(uiImage: processor.cellImages[index])
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            } else {
                                Image(uiImage: processor.normalizedCellImages[index])
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                }
            }

            HStack {
                Image(systemName: "hand.tap")
                Text("Tap to toggle between the extracted digit images and the board")
            }
        }
        .onTapGesture {
            self.isShowingUnprocessed = !self.isShowingUnprocessed
        }
    }
}
