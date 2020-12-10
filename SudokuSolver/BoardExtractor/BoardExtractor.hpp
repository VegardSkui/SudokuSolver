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
    void FindEdges(std::vector<Vec2f> *lines, Vec2f *top_edge, Vec2f *bottom_edge, Vec2f *left_edge, Vec2f *right_edge);
    cv::Point Intersection(Vec2f line1, Vec2f line2);
};

#endif /* BoardExtractor_hpp */
