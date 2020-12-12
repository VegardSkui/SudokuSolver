//
//  SudokuProcessor.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 12/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

import Foundation

class SudokuProcessor: ObservableObject {
    @Published var hasNormalizedCells = false

    /// The board extracted from the original image.
    private(set) var board: UIImage?

    private(set) var cellImages = [UIImage]()
    private(set) var normalizedCellImages = [UIImage]()

    private let boardExtractor = BoardExtractorBridge()
    private let digitCleaner = DigitCleanerBridge()

    func process(image: UIImage) {
        hasNormalizedCells = false

        // Remove any existing cell images and values
        cellImages = [UIImage]()
        normalizedCellImages = [UIImage]()

        board = boardExtractor.extractBoard(from: image)

        cellImages = extractCellImages(from: board!)

        normalizedCellImages = cellImages.map { cell in
            digitCleaner.cleanAndNormalizeDigit(in: cell)
        }

        hasNormalizedCells = true
    }

    /// Splits the board into 81 smaller images, one for each cell.
    ///
    /// The images extend 10% outside the calculated cell size when possible to
    /// reduce the probability of the digit touching the edge, thus the images
    /// along the edges are not square.
    private func extractCellImages(from board: UIImage) -> [UIImage] {
        guard let cgBoard = board.cgImage else {
            fatalError("No backing CGImage")
        }

        var result = [UIImage]()

        let edgeLength = Double(cgBoard.width) / 9
        for y in 0...8 {
            for x in 0...8 {
                let rect = CGRect(x: (Double(x) - 0.1) * edgeLength,
                                  y: (Double(y) - 0.1) * edgeLength,
                                  width: 1.2 * edgeLength,
                                  height: 1.2 * edgeLength)

                guard let cgCell = cgBoard.cropping(to: rect) else {
                    fatalError("Cropping failed")
                }

                result.append(UIImage(cgImage: cgCell))
            }
        }

        return result
    }
}
