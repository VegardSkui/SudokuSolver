//
//  DigitCleaner.hpp
//  SudokuSolver
//
//  Created by Vegard Skui on 11/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

#ifndef DigitCleaner_hpp
#define DigitCleaner_hpp

#include <opencv2/opencv.hpp>

using namespace cv;

class DigitCleaner {
public:
    Mat CleanDigit(Mat image);

private:
    cv::Point FindDigit(Mat image);
};

#endif /* DigitCleaner_hpp */
