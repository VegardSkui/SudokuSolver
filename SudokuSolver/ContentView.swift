//
//  ContentView.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 09/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var presentingImagePicker = false

    @State var image: UIImage?
    @State var board: UIImage?

    @State var originalCellImages = [UIImage]()
    @State var cleanedCellImages = [UIImage]()

    var body: some View {
        ScrollView {
            VStack {
                Button(action: {
                    presentingImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Open Photo")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                /*if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }

                if let board = board {
                    Image(uiImage: board)
                        .resizable()
                        .scaledToFit()
                }*/

                if originalCellImages.count > 0 {
                    ForEach(0..<9) { i in
                        HStack {
                            ForEach(0..<9) { j in
                                let index = i*9 + j
                                VStack {
                                    Image(uiImage: originalCellImages[index])
                                        .resizable()
                                        .scaledToFit()
                                        .border(Color.blue)

                                    Image(uiImage: cleanedCellImages[index])
                                        .resizable()
                                        .scaledToFit()
                                        .border(Color.blue)
                                }
                            }
                        }
                    }
                }

            }.sheet(isPresented: $presentingImagePicker, onDismiss: processImage, content: {
                ImagePicker(image: self.$image)
            })
        }
    }

    func processImage() {
        guard let image = image else { return }

        // Empty any existing cell images
        originalCellImages = [UIImage]()
        cleanedCellImages = [UIImage]()

        // Extract the board from the selected image
        board = BoardExtractorBridge().extractBoard(from: image)

        guard let cgImage = board?.cgImage else { return }

        let digitCleaner = DigitCleanerBridge()

        // Split the board into 81 smaller images, one for each cell
        let edgeLength = Double(cgImage.width) / 9
        // We include a bit more around the cell to reduce the probability of
        // the digit touching the edge
        let expansionFactor = 0.2
        for y in 0...8 {
            for x in 0...8 {
                let rect = CGRect(x: (Double(x) - expansionFactor / 2) * edgeLength,
                                  y: (Double(y) - expansionFactor / 2) * edgeLength,
                                  width: (1.0 + expansionFactor) * edgeLength,
                                  height: (1 + expansionFactor) * edgeLength)
                let cell = UIImage(cgImage: cgImage.cropping(to: rect)!)
                originalCellImages.append(cell)

                let cleaned = digitCleaner.cleanDigit(in: cell)!
                cleanedCellImages.append(cleaned)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
