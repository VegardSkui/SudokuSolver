//
//  SimpleBacktrackingSolverTests.swift
//  SudokuSolverTests
//
//  Created by Vegard Skui on 12/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

@testable import SudokuSolver
import XCTest

class SimpleBacktrackingSolverTests: XCTestCase {

    let sudoku = [
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
    let solution = [
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

    func testSolvableSudoku() throws {
        let result = SimpleBacktrackingSolver().solve(sudoku: sudoku)
        XCTAssertEqual(result, solution, "Solution is wrong")
    }

    func testEmptyBoard() throws {
        let empty = [Int](repeating: 0, count: 81)
        let result = SimpleBacktrackingSolver().solve(sudoku: empty)
        XCTAssertNotNil(result, "Solving an empty board failed")
    }
}
