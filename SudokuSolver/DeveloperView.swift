//
//  DeveloperView.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 14/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

import SwiftUI

struct DeveloperView: View {
    @EnvironmentObject var processor: SudokuProcessor

    var body: some View {
        TabView {
            if let image = processor.normalized, let board = processor.board {
                BoardView(original: image, board: board)
                    .tabItem {
                        Image(systemName: "squareshape.split.3x3")
                        Text("Board")
                    }
            }

            if processor.normalizedCellImages.count == 81 {
                ExtractedDigitsView(cellImages: processor.cellImages,
                                    normalizedCellImages: processor.normalizedCellImages)
                    .tabItem {
                        Image(systemName: "1.magnifyingglass")
                        Text("Extracted Digits")
                    }
            }

            if processor.cellValues.count == 81 {
                VStack(spacing: 20) {
                    Text("Recognized Digits")
                        .font(.headline)

                    let cells = processor.cellValues.map {
                        SudokuCell(value: $0, isHighlighted: $0 != 0)
                    }
                    SudokuView(cells: .constant(cells),
                               isEditable: false)
                }
                .tabItem {
                    Image(systemName: "textformat.123")
                    Text("Recognized Digits")
                }
            }
        }
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView()
            .environmentObject(SudokuProcessor())
    }
}

