//
//  SudokuView.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 13/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

import SwiftUI

struct SudokuView: View {
    let prefilled: [Int]
    let digits: [Int]

    var body: some View {
        VStack {
            ForEach(0..<9) { y in
                HStack(spacing: 0) {
                    ForEach(0..<9) { x in
                        let index = 9 * y + x
                        Text(digits[index] == 0 ? "" : "\(digits[index])")
                            .frame(width: 40, height: 40, alignment: .center)
                            .border(Color.black, width: 1)
                            .background(backgroundForCellAt(x, y))
                            .font(fontForCellAt(index))

                    }
                }
            }
        }.border(Color.black, width: 3)
    }

    private func fontForCellAt(_ index: Int) -> Font {
        if prefilled[index] == 0 {
            return .system(size: 16, weight: .regular, design: .default)
        } else {
            return .system(size: 16, weight: .bold, design: .default)
        }
    }

    private func backgroundForCellAt(_ x: Int, _ y: Int) -> Color {
        if y / 3 % 2 == 0 && x / 3 % 2 == 0 || y / 3 == 1 && x / 3 == 1 {
            return Color(white: 0.9)
        } else {
            return Color.white
        }
    }
}

struct SudokuView_Previews: PreviewProvider {
    private static let prefilled = [
        2,0,3,7,0,4,0,0,0,
        0,8,0,3,0,0,0,0,5,
        0,0,0,0,0,0,0,1,0,
        0,0,0,1,0,0,0,0,3,
        0,2,0,0,8,0,1,7,0,
        9,0,0,0,0,3,0,0,0,
        0,5,0,0,0,0,0,0,0,
        6,0,0,0,7,1,0,3,0,
        0,0,0,6,0,5,7,0,4,
    ]
    private static let digits = [
        2,1,3,7,5,4,8,6,9,
        7,8,9,3,1,6,2,4,5,
        5,4,6,9,2,8,3,1,7,
        8,6,5,1,4,7,9,2,3,
        3,2,4,5,8,9,1,7,6,
        9,7,1,2,6,3,4,5,8,
        4,5,7,8,3,2,6,9,1,
        6,9,8,4,7,1,5,3,2,
        1,3,2,6,9,5,7,8,4,
    ]

    static var previews: some View {
        Group {
            SudokuView(prefilled: [Int](repeating: 0, count: 81),
                       digits: [Int](repeating: 0, count: 81))
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Empty Board")

            SudokuView(prefilled: prefilled, digits: prefilled)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Prefilled Board")

            SudokuView(prefilled: prefilled, digits: digits)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Solved Board")
        }
    }
}
