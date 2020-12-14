//
//  ContentView.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 09/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var processor: SudokuProcessor

    @State var presentingSourceTypeSelectionSheet = false
    @State var selectedSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var presentingImagePicker = false

    @State var presentingDeveloperView = false

    @State var image: UIImage?

    @State var message = "Start by opening a photo of a sudoku puzzle"

    @State var isEditable = true
    @State var cells = [SudokuCell](repeating: SudokuCell(value: 0, isHighlighted: false),
                                    count: 81)

    @State var isSolved = false

    var body: some View {
        VStack {
            Button(action: {
                presentingSourceTypeSelectionSheet = true
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
            .actionSheet(isPresented: $presentingSourceTypeSelectionSheet) {
                ActionSheet(title: Text("Choose a Photo"),
                            buttons: [.default(Text("Photo Library"), action: presentPhotoLibrary),
                                      .default(Text("Camera"), action: presentCamera),
                                      .cancel()])
            }
            .sheet(isPresented: $presentingImagePicker, onDismiss: processImage) {
                ImagePicker(image: self.$image, sourceType: selectedSourceType)
            }

            Text(message)
                .padding()
                .onTapGesture(count: 3) {
                    self.presentingDeveloperView = true
                }
                .sheet(isPresented: $presentingDeveloperView, content: {
                    DeveloperView()
                })

            SudokuView(cells: $cells, isEditable: isEditable)

            if isSolved {
                Button(action: clear) {
                    Text("Clear")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                Button(action: solve) {
                    Text("Solve")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }

    func processImage() {
        guard let image = image else { return }

        clear()

        DispatchQueue.global(qos: .userInitiated).async {
            guard let prefilled = processor.process(image: image) else {
                DispatchQueue.main.async {
                    self.message = "Could not find sudoku board"
                }
                return
            }

            DispatchQueue.main.async {
                self.cells = prefilled.map {
                    SudokuCell(value: $0, isHighlighted: $0 != 0)
                }
                self.message = "Input any missing digits or edit wrongly classified digits by tapping a cell"
                self.isEditable = true
            }
        }
    }

    func solve() {
        // Disable editing while solving
        self.isEditable = false

        self.message = "Solving"

        DispatchQueue.global(qos: .userInitiated).async {
            let values = cells.map { $0.value }
            let solution = SimpleBacktrackingSolver().solve(sudoku: values)

            DispatchQueue.main.async {
                if solution == nil {
                    self.message = "The puzzle is unsolvable"
                    self.isEditable = true
                } else {
                    for i in 0..<81 {
                        self.cells[i].value = solution![i]
                    }
                    self.message = "Done!"
                    self.isSolved = true
                }
            }
        }
    }

    func clear() {
        isSolved = false
        isEditable = true
        message = "Start by opening a photo of a sudoku puzzle"
        cells = [SudokuCell](repeating: SudokuCell(value: 0, isHighlighted: false),
                             count: 81)
    }

    private func presentPhotoLibrary() {
        selectedSourceType = .savedPhotosAlbum
        presentingImagePicker = true
    }

    private func presentCamera() {
        selectedSourceType = .camera
        presentingImagePicker = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SudokuProcessor())
    }
}
