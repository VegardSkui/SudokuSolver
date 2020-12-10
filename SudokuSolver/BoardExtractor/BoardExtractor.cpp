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

    // Detect lines using a Hough transform
    std::vector<Vec2f> lines;
    HoughLines(border_image, lines, 1, CV_PI/180, 200);

    MergeNearbyLines(&lines, image);

    // Draw remaining lines after merge
    for (int i = 0; i < lines.size(); i++) {
        DrawLine(lines[i], border_image, CV_RGB(0,0,128));
    }

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

// Draws a line on an image with the given color.
void BoardExtractor::DrawLine(Vec2f line, Mat image, Scalar rgb) {
    Point pt1, pt2;

    // Vertical lines must be treated separately, to avoid dividing by zero
    if (line[1] != 0) {
        pt1 = Point(0, line[0]/sin(line[1]));
        pt2 = Point(image.size().width, (line[0] - image.size().width*cos(line[1]))/sin(line[1]));
    } else {
        pt1 = Point(line[0], 0);
        pt2 = Point(line[0], image.size().height);
    }

    cv::line(image, pt1, pt2, rgb);
}

// Calculates the squared distance between two points.
inline float SquaredDistance(Point p1, Point p2) {
    return (p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y);
}

// Finds two different points on a line.
inline void FindTwoPoints(Vec2f *line, Size image_size, Point *p1, Point *p2) {
    float p = (*line)[0];
    float θ = (*line)[1];

    if (θ > CV_PI*45/180 && θ < CV_PI*135/180) {
        // θ ∈ (45°,135°) i.e. closer to horizontal, find a point on the left
        // and right side
        p1->x = 0;
        p1->y = p/sin(θ);
        p2->x = image_size.width;
        p2->y = (p - image_size.width*cos(θ)) / sin(θ);
    } else {
        // If the line is closer to vertical, find a point on the top and bottom
        p1->x = p/cos(θ);
        p1->y = 0;
        p2->x = (p - image_size.height*sin(θ)) / cos(θ);
        p2->y = image_size.height;
    }
}

// Merges lines that are close to each other.
void BoardExtractor::MergeNearbyLines(std::vector<Vec2f> *lines, Mat image) {
    std::vector<Vec2f>::iterator line1, line2;
    for (line1 = lines->begin(); line1 != lines->end(); line1++) {
        // While merging we'll mark merged lines by setting them to (0,100),
        // which is an impossible value (θ <= 2π). We skip already merged lines.
        if ((*line1)[0] == 0 && (*line1)[1] == 100) continue;

        // Find two points on line1
        Point line1_p1, line1_p2;
        FindTwoPoints(&(*line1), image.size(), &line1_p1, &line1_p2);

        for (line2 = lines->begin(); line2 != lines->end(); line2++) {
            // Again, we need to skip the already merged lines
            if ((*line2)[0] == 0 && (*line2)[1] == 100) continue;

            // There is no point merging a line with itself, skip it
            if (*line1 == *line2) continue;

            // Skip the line if they differ by more than 10 degrees or 20 in
            // distance from the origin
            if (fabs((*line2)[0] - (*line1)[0]) > 20 || fabs((*line2)[1] - (*line1)[1]) > CV_PI*10/180) continue;

            // Find two points on line2
            Point line2_p1, line2_p2;
            FindTwoPoints(&(*line2), image.size(), &line2_p1, &line2_p2);

            // Merge the lines if the distance within their two pairs of
            // endpoints is less than 64
            if (SquaredDistance(line1_p1, line2_p1) < 64*64 && SquaredDistance(line1_p2, line2_p2) < 64*64) {
                // Merge the two lines by averaging, store in line1
                (*line1)[0] = ((*line1)[0] + (*line2)[0]) / 2;
                (*line1)[1] = ((*line1)[1] + (*line2)[1]) / 2;

                // Mark line2 as merged, so that it's not used again
                (*line2)[0] = 0;
                (*line2)[1] = 100;
            }
        }
    }
}
