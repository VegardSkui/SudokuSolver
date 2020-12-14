//
//  SudokuCell.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 14/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

struct SudokuCell {
    /// The current value in the cell.
    var value: Int

    /// Whether the cell is highlighted.
    var isHighlighted: Bool

    /// The current value in textual from, tied to the `value` field.
    var textValue: String {
        get {
            if value != 0 {
                return String(value)
            } else {
                return ""
            }
        }
        set {
            guard let value = Int(newValue) else {
                return
            }
            self.value = value % 10
        }
    }
}
