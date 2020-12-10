//
//  BoardExtractor.cpp
//  SudokuSolver
//
//  Created by Vegard Skui on 10/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

#include "BoardExtractor.hpp"

// NOTE: All functions, except ExtractBoard, expects the input matrix image to
// be of the CV_8UC1 (8-bit unsigned 1-channel) type.

// Extracts the sudoku board from a larger image. Assuming the largest element
// in the image is the sudoku board, black on white, and that it has a black
// border around it.
Mat BoardExtractor::ExtractBoard(Mat image) {
    // Convert the image to grayscale
    cvtColor(image, image, COLOR_BGR2GRAY);

    // Image to hold the outer border of the sudoku puzzle, an 8-bit unsigned
    // 1-channel array
    Mat border_image = Mat(image.size(), CV_8UC1);

    // Blur the image to smooth out noise and make border extraction easier
    GaussianBlur(image, image, Size(11, 11), 0);

    // Make the image binary (black and white) using an adaptive threshold (use
    // an adaptive method since the image can have varying illumination levels)
    adaptiveThreshold(image, border_image, 255, ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY, 5, 2);

    // Invert the image such that the border (and noise) is white and the
    // background is black
    bitwise_not(border_image, border_image);

    // Dilate the image using a 3by3 plus-shaped kernel to connect lines
    // disconnected by the thresholding operation
    Mat kernel = (Mat_<uchar>(3,3) << 0,1,0,1,1,1,0,1,0);
    dilate(border_image, border_image, kernel);

    // Remove everything but the largest connected component in the image, this
    // should include the puzzle grid
    Point largest_component_seed = FindLargestConnectedComponent(border_image);
    HighlightComponent(border_image, largest_component_seed);

    return border_image;
}

// Finds the point of the pixel giving rise to the largest connected component.
// All components are assumed to be white on a black background. Afterwards, all
// components will be turned to a dark gray color, (0,0,64).
Point BoardExtractor::FindLargestConnectedComponent(Mat image) {
    Point max_point;
    int max_area = 0;

    for (int y = 0; y < image.size().height; y++) {
        // Get a pointer to the y-th row of the image matrix
        uchar *row = image.ptr(y);

        for (int x = 0; x < image.size().width; x++) {
            // Skip background pixels and already encountered pixels
            if (row[x] < 128) continue;

            Point point = Point(x,y);

            // Find the area of the connected component stemming from the
            // current point using the floodFill function (the return value is
            // the area of the component). The fill color is dark gray such that
            // the component can be easily skipped in later iterations.
            int area = floodFill(image, point, CV_RGB(0,0,64));
            if (area > max_area) {
                max_point = point;
                max_area = area;
            }
        }
    }

    return max_point;
}

// Highlights the connected component stemming from seed_point, turning it
// white. Every other component is removed (turned into the background color of
// black). All components are assumed to have the color (0,0,64).
void BoardExtractor::HighlightComponent(Mat image, Point seed_point) {
    // Color the selected component white
    floodFill(image, seed_point, CV_RGB(0,0,255));

    for (int y = 0; y < image.size().height; y++) {
        // Get a pointer to the y-th row of the image matrix
        uchar *row = image.ptr(y);

        for (int x = 0; x < image.size().width; x++) {
            // Skip pixels which are not part of any remaining components
            if (row[x] != 64) continue;

            // Remove the component stemming from the pixel at (x,y)
            floodFill(image, Point(x,y), CV_RGB(0,0,0));
        }
    }
}
