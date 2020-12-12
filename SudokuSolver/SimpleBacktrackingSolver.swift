//
//  SimpleBacktrackingSolver.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 12/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

class SimpleBacktrackingSolver {
    func solve(sudoku: [Int]) -> [Int]? {
        var sudoku = sudoku
        if fillCell(at: 0, sudoku: &sudoku) {
            return sudoku
        }
        return nil
    }

    private func fillCell(at index: Int, sudoku: inout [Int]) -> Bool {
        // If we reached the end of the sudoku, success
        if index == 81 {
            return true
        }

        // Skip cells with existing values
        if sudoku[index] != 0 {
            return fillCell(at: index + 1, sudoku: &sudoku)
        }

        // Try to place each digit in the cell
        for digit in 1...9 {
            if canPlace(digit: digit, at: index, sudoku: sudoku) {
                // If the digit can be placed, continue with the next cell
                sudoku[index] = digit
                if fillCell(at: index + 1, sudoku: &sudoku) {
                    return true
                }
            }
        }

        // If no digit could be placed in this cell, reset it and backtrack
        sudoku[index] = 0
        return false
    }

    /// Checks whether a given digit can be placed at the cell with the given
    /// index.
    ///
    /// The digit cannot be placed when this test is called, if it is, the test
    /// will always fail.
    private func canPlace(digit: Int, at index: Int, sudoku: [Int]) -> Bool {
        // Check row
        let row = index / 9
        for i in 9*row..<9*row+9 {
            if sudoku[i] == digit {
                return false
            }
        }

        // Check column
        let column = index % 9
        for i in stride(from: column, through: 72 + column, by: 9) {
            if sudoku[i] == digit {
                return false
            }
        }

        // Check box
        let boxX = column / 3
        let boxY = row / 3
        for y in 3*boxY..<3*boxY+3 {
            for x in 3*boxX..<3*boxX+3 {
                if sudoku[9*y+x] == digit {
                    return false
                }
            }
        }
        
        return true
    }
}
