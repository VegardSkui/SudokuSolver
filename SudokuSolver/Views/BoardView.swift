//
//  BoardView.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 13/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

import SwiftUI

struct BoardView: View {
    let original: UIImage
    let board: UIImage

    /// Whether the original image or board image is currently shown.
    @State var isShowingOriginal = false

    var body: some View {
        VStack(spacing: 20) {
            if isShowingOriginal {
                Text("Original")
                    .font(.headline)

                Image(uiImage: original)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("Extracted Board")
                    .font(.headline)

                Image(uiImage: board)
                    .resizable()
                    .scaledToFit()
            }

            HStack {
                Image(systemName: "hand.tap")
                Text("Tap to toggle between the extracted board and original image")
            }
        }
        .onTapGesture {
            self.isShowingOriginal = !self.isShowingOriginal
        }
    }
}
