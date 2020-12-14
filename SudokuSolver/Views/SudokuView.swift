//
//  SudokuView.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 13/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

import SwiftUI

struct SudokuView: View {
    @Binding var cells: [SudokuCell]
    var isEditable: Bool

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<9) { y in
                HStack(spacing: 0) {
                    ForEach(0..<9) { x in
                        let index = 9 * y + x
                        SudokuCellView(cell: $cells[index], index: index,
                                       isEditable: isEditable)
                    }
                }
            }
        }.border(Color.black, width: 3)
    }
}

struct SudokuView_Previews: PreviewProvider {
    private static let empty = [SudokuCell](repeating: SudokuCell(value: 0, isHighlighted: false), count: 81)
    private static let prefilled = {
        [
            2,0,3,7,0,4,0,0,0,
            0,8,0,3,0,0,0,0,5,
            0,0,0,0,0,0,0,1,0,
            0,0,0,1,0,0,0,0,3,
            0,2,0,0,8,0,1,7,0,
            9,0,0,0,0,3,0,0,0,
            0,5,0,0,0,0,0,0,0,
            6,0,0,0,7,1,0,3,0,
            0,0,0,6,0,5,7,0,4,
        ].map { SudokuCell(value: $0, isHighlighted: true) }
    }()
    private static let solved = {
        [
            2,1,3,7,5,4,8,6,9,
            7,8,9,3,1,6,2,4,5,
            5,4,6,9,2,8,3,1,7,
            8,6,5,1,4,7,9,2,3,
            3,2,4,5,8,9,1,7,6,
            9,7,1,2,6,3,4,5,8,
            4,5,7,8,3,2,6,9,1,
            6,9,8,4,7,1,5,3,2,
            1,3,2,6,9,5,7,8,4,
        ].map { SudokuCell(value: $0, isHighlighted: false) }
    }()

    static var previews: some View {
        Group {
            SudokuView(cells: .constant(empty), isEditable: false)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Empty Board")

            SudokuView(cells: .constant(prefilled), isEditable: false)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Prefilled Board")

            SudokuView(cells: .constant(solved), isEditable: false)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Solved Board")
        }
    }
}
