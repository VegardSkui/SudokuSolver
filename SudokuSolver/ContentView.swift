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

    var body: some View {
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

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            if let board = board {
                Image(uiImage: board)
                    .resizable()
                    .scaledToFit()
            }
        }.sheet(isPresented: $presentingImagePicker, onDismiss: processImage, content: {
            ImagePicker(image: self.$image)
        })
    }

    func processImage() {
        guard let image = image else { return }

        // Extract the board from the selected image
        board = BoardExtractorBridge().extractBoard(from: image)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
