//
//  DigitCleaner.cpp
//  SudokuSolver
//
//  Created by Vegard Skui on 11/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

#include "DigitCleaner.hpp"

// Finds the height (from the top) of the first white pixel from the top.
// Returns -1 if not found.
int SearchFromTop(Mat image) {
    for (int y = 0; y < image.size().height; y++) {
        uchar *row = image.ptr(y);
        for (int x = 0; x < image.size().width; x++) {
            if (row[x] == 255) return y;
        }
    }
    return -1;
}

// Finds the height (from the top) of the first white pixel from the bottom.
// Returns -1 if not found.
int SearchFromBottom(Mat image) {
    for (int y = image.size().height-1; y > 0; y--) {
        uchar *row = image.ptr(y);
        for (int x = 0; x < image.size().width; x++) {
            if (row[x] == 255) return y;
        }
    }
    return -1;
}

// Extracts a binary image (white on black) of the digit present in a single
// cell. The cell image should be grayscale. If no digit is found, the returned
// image will be 1x1 pure red.
Mat DigitCleaner::CleanDigit(Mat image) {
    // Blur the image to smooth out noise
    GaussianBlur(image, image, Size(5, 5), 0);

    // Make the image binary (black and white) using an adaptive threshold (use
    // an adaptive method since the image can have varying illumination levels)
    adaptiveThreshold(image, image, 255, ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY,
                      3, 2);

    // Invert the image such that we have white features on a black background
    bitwise_not(image, image);

    // Create a red error image to return when a digit cannot be found
    Mat error_image = Mat(1, 1, CV_8UC3);
    error_image.setTo(CV_RGB(0,0,255));

    Point point = FindDigit(image);
    if (point.x == 0 && point.y == 0) return error_image;

    // Turn the digit into a gray color
    floodFill(image, point, CV_RGB(0,0,128));

    // Make the digit white and remove everything else (i.e. turn to black)
    for (int y = 0; y < image.size().height; y++) {
        uchar *row = image.ptr(y);
        for (int x = 0; x < image.size().width; x++) {
            if (row[x] == 0) continue;

            if (row[x] == 255) row[x] = 0;
            else if (row[x] == 128) row[x] = 255;
        }
    }

    // Find the height of the first pixel in the digit from the top and bottom
    int top = SearchFromTop(image);
    int bottom = SearchFromBottom(image);

    // If the digit touches the top or bottom, we assume that it's actually part
    // of the grid, not a digit
    if (top == 0 || bottom == image.size().height-1) return error_image;

    // Find the position of the left and right extremes of the digit using a
    // transposed matrix so that the same search method as for top and bottom
    // can be used
    Mat transposed;
    transpose(image, transposed);
    int left = SearchFromTop(transposed);
    int right = SearchFromBottom(transposed);

    // Since the digit is found by searching horizontally most probably left and
    // right won't be at the edge. If we actually found a grid line it would
    // more likely already be detected by the top and bottom check.

    // Create a rectangle signifying where the digit is located in the image
    Rect digit = Rect(left, top, right-left+1, bottom-top+1);

    // Return only the part of the image where the digit is located
    return image(digit);
}

// Detects a point which is likely part of the digit by searching horizontally
// out from the center of the image. A point with coordinates (0,0) is returned
// if no digit is found.
Point DigitCleaner::FindDigit(Mat image) {
    Point point = Point(image.size().width / 2, image.size().height / 2);

    for (int i = 0; i < image.size().width / 2; i++) {
        // Go alternating further left and right
        if (i % 2 == 0) point.x += i;
        else point.x -= i;

        // A white pixel means we found a digit (or other feature)
        if (image.at<uchar>(point) == 255) return point;
    }

    return Point(0,0);
}

// Places the digit at the center of a 28x28 binary image with 4 pixels of
// margin.
Mat DigitCleaner::NormalizeDigit(Mat image) {
    Mat output = Mat(28, 28, CV_8UC1, Scalar(0,0,0));

    // Calculate the rect inside the output image the original image will be
    // copied to. Handle both both tall and wide images.
    int x, y, width, height;
    if (image.size().height > image.size().width) {
        width = round(20.0 * (double)image.size().width / (double)image.size().height);
        height = 20;
        x = (28 - width) / 2;
        y = 4;
    } else {
        width = 20;
        height = round(20.0 * (double)image.size().height / (double)image.size().width);
        x = 4;
        y = (28 - height) / 2;
    }
    Rect rect = Rect(x, y, width, height);

    // Resize the image and make sure it's still binary. Darker pixels are
    // turned black and lighter pixels are turned white.
    resize(image, image, Size(width, height));
    for (int y = 0; y < height; y++) {
        uchar *row = output.ptr(y);
        for (int x = 0; x < width; x++) {
            if (row[x] == 0) continue;
            if (row[x] < 128) row[x] = 0;
            else if (row[x] != 255) row[x] = 255;
        }
    }

    // Copy the image into the output image and return it
    image.copyTo(output(rect));
    return output;
}
