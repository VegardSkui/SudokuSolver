//
//  BoardExtractor.hpp
//  SudokuSolver
//
//  Created by Vegard Skui on 10/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

#ifndef BoardExtractor_hpp
#define BoardExtractor_hpp

#include <opencv2/opencv.hpp>

using namespace cv;

class BoardExtractor {
public:
    Mat ExtractBoard(Mat image);

private:
    cv::Point FindLargestConnectedComponent(Mat image);
    void HighlightComponent(Mat image, cv::Point seed_point);
    void DrawLine(Vec2f line, Mat image, Scalar rgb);
    void MergeNearbyLines(std::vector<Vec2f> *lines, Mat image);
};

#endif /* BoardExtractor_hpp */
