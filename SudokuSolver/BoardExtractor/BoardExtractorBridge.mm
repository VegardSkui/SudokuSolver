//
//  BoardExtractorBridge.m
//  SudokuSolver
//
//  Created by Vegard Skui on 10/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "BoardExtractorBridge.h"
#import "BoardExtractor.hpp"

@implementation BoardExtractorBridge

- (UIImage *) extractBoardFrom: (UIImage *) image {
    // Convert the image to OpenCV matrix format
    cv::Mat sudoku;
    UIImageToMat(image, sudoku);

    // Extract the board
    BoardExtractor boardExtractor;
    cv::Mat board = boardExtractor.extract_board(sudoku);

    // Convert the result to UIImage and return
    return MatToUIImage(board);
}

@end
