//
//  SudokuProcessor.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 12/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

class SudokuProcessor: ObservableObject {
    /// The inputted image with normalized orientation.
    private(set) var normalized: UIImage?

    /// The board extracted from the original image.
    private(set) var board: UIImage?

    /// Cropped images of each cell on the board.
    private(set) var cellImages = [UIImage]()

    /// Images of each cell as passed to the classifier.
    private(set) var normalizedCellImages = [UIImage]()
    private(set) var cellValues = [Int]()

    private let boardExtractor = BoardExtractorBridge()
    private let digitCleaner = DigitCleanerBridge()
    private let classifier = MNISTClassifier()

    /// Extracts and classifies the digits from an image of a sudoku board.
    func process(image: UIImage) -> [Int]? {
        // Remove any existing cell images and values
        cellImages = [UIImage]()
        normalizedCellImages = [UIImage]()
        cellValues = [Int]()

        normalized = image.normalizedRotation()

        board = boardExtractor.extractBoard(from: normalized)

        guard let cellImages = extractCellImages(from: board!) else { return nil }
        self.cellImages = cellImages

        normalizedCellImages = cellImages.map { cell in
            digitCleaner.cleanAndNormalizeDigit(in: cell)!
        }

        cellValues = normalizedCellImages.map { cell in
            classifyDigit(in: cell)
        }

        return cellValues
    }

    /// Splits the board into 81 smaller images, one for each cell.
    ///
    /// The images extend 10% outside the calculated cell size when possible to
    /// reduce the probability of the digit touching the edge, thus the images
    /// along the edges are not square.
    private func extractCellImages(from board: UIImage) -> [UIImage]? {
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
                    print("Cropping failed")
                    return nil
                }

                result.append(UIImage(cgImage: cgCell))
            }
        }

        return result
    }

    /// Tries to determine the digit in the given cell, 0 signifies that the
    /// digit could not be determined.
    private func classifyDigit(in cell: UIImage) -> Int {
        guard cell.size.width != 1 else {
            return 0
        }

        guard let cgCell = cell.cgImage else {
            fatalError("No backing CGImage")
        }

        guard let input = try? MNISTClassifierInput(imageWith: cgCell) else {
            fatalError("Could not create classifier input")
        }

        guard let output = try? classifier.prediction(input: input) else {
            fatalError("Could not classify digit in cell")
        }

        let classification = output.classLabel
        let probability = output.labelProbabilities[classification]!

        // If the classifier is certain, use the result
        if probability == 1 {
            return Int(classification)
        }

        // Get the second highest probability
        let secondProbability = output.labelProbabilities.values.filter {
            $0 != probability
        }.max()!

        // Also include the result if the classifier is at least 98% certain and
        // the certainty is higher then the next highest by a factor of 10
        if probability > 0.98 && probability / secondProbability > 10 {
            return Int(classification)
        }

        // We discard every other result. This also removes some correct
        // results, but any wrong digit guarentees a wrong solution and is
        // unacceptable. With less digits it is at least possible to arrive at
        // the correct solution to the puzzle.
        return 0
    }
}
