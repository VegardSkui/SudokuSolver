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

    @State var presentingImagePicker = false

    @State var image: UIImage?

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

                if let board = processor.board {
                    Image(uiImage: board)
                        .resizable()
                        .scaledToFit()
                }*/

                if processor.hasCellValues {
                    ForEach(0..<9) { i in
                        HStack {
                            ForEach(0..<9) { j in
                                let index = i*9 + j
                                VStack {
                                    Image(uiImage: processor.cellImages[index])
                                        .resizable()
                                        .scaledToFit()
                                        .border(Color.blue)

                                    Image(uiImage: processor.normalizedCellImages[index])
                                        .resizable()
                                        .scaledToFit()
                                        .border(Color.blue)

                                    Text("\(processor.cellValues[index])")
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

        processor.process(image: image)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SudokuProcessor())
    }
}
