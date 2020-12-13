//
//  SolutionView.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 13/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

import SwiftUI

struct SolutionView: View {
    @EnvironmentObject var processor: SudokuProcessor

    var body: some View {
        VStack(spacing: 20) {
            Text("Solution")
                .font(.headline)

            SudokuView(prefilled: processor.cellValues, digits: processor.cellValues)

            Text("Digits recognized from the image are highlighted in bold")
                .padding(.horizontal)
        }
    }
}
