//
//  BoardExtractor.cpp
//  SudokuSolver
//
//  Created by Vegard Skui on 10/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

#include "BoardExtractor.hpp"

Mat BoardExtractor::extract_board(Mat image) {
    // Convert the image to grayscale
    Mat grayscaleImage;
    cvtColor(image, grayscaleImage, COLOR_BGR2GRAY);

    return grayscaleImage;
}
