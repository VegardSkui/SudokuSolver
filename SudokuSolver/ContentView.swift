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
        TabView {
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

            }
            .tabItem {
                Image(systemName: "plus.square")
                Text("Open")
            }

            if let board = processor.board {
                BoardView(original: image!, board: board)
                    .tabItem {
                        Image(systemName: "squareshape.split.3x3")
                        Text("Board")
                    }
            }

            if processor.hasCellValues {
                DigitsView()
                    .tabItem {
                        Image(systemName: "textformat.123")
                        Text("Digits")
                    }
            }
        }.sheet(isPresented: $presentingImagePicker, onDismiss: processImage, content: {
            ImagePicker(image: self.$image)
        })
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
