//
//  SudokuCellView.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 14/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

import SwiftUI

struct SudokuCellView: View {
    @Binding var cell: SudokuCell
    let index: Int
    let isEditable: Bool

    let background: Color

    init(cell: Binding<SudokuCell>, index: Int, isEditable: Bool) {
        self._cell = cell
        self.index = index
        self.isEditable = isEditable

        let x = index % 9
        let y = index / 9
        if y % 6 < 3 && x % 6 < 3 || y / 3 == 1 && x / 3 == 1 {
            background = Color(white: 0.9)
        } else {
            background = Color.white
        }
    }

    var font: Font {
        if cell.isHighlighted {
            return .system(size: 16, weight: .bold, design: .default)
        } else {
            return .system(size: 16, weight: .regular, design: .default)
        }
    }

    var body: some View {
        if isEditable {
            TextField("", text: $cell.textValue)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 40, height: 40, alignment: .center)
                .border(Color.black, width: 1)
                .background(background)
                .foregroundColor(.black)
                .font(font)
        } else {
            Text(cell.textValue)
                .frame(width: 40, height: 40, alignment: .center)
                .border(Color.black, width: 1)
                .background(background)
                .foregroundColor(.black)
                .font(font)
        }
    }
}

struct SudokuCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SudokuCellView(cell: .constant(SudokuCell(value: 0, isHighlighted: false)),
                           index: 3, isEditable: false)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Empty Cell")

            SudokuCellView(cell: .constant(SudokuCell(value: 4, isHighlighted: false)),
                           index: 3, isEditable: false)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Regular Cell")

            SudokuCellView(cell: .constant(SudokuCell(value: 2, isHighlighted: true)),
                           index: 3, isEditable: false)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Highlighted Cell")
        }
    }
}
