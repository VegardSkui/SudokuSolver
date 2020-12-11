//
//  DigitCleanerBridge.m
//  SudokuSolver
//
//  Created by Vegard Skui on 11/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "DigitCleanerBridge.h"
#import "DigitCleaner.hpp"

@implementation DigitCleanerBridge

- (UIImage *) cleanDigitIn: (UIImage *) image {
    // Convert the image to OpenCV matrix format
    cv::Mat matrix;
    UIImageToMat(image, matrix);

    // Clean the digit
    DigitCleaner digitCleaner;
    Mat digit = digitCleaner.CleanDigit(matrix);

    // Convert the result to UIImage and return
    return MatToUIImage(digit);
}

@end
