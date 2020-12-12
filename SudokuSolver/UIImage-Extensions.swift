//
//  UIImage-Extensions.swift
//  SudokuSolver
//
//  Created by Vegard Skui on 12/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

import opencv2

extension UIImage {
    /// Returns an image with the pixel data transformed to correspond to the
    /// original image with imageOrientation up.
    ///
    /// Does not handle mirroring, only rotations.
    func normalizedRotation() -> UIImage {
        if imageOrientation == .up {
            return self
        }

        let mat = Mat(uiImage: self)

        if imageOrientation == .down {
            Core.rotate(src: mat, dst: mat, rotateCode: .ROTATE_180)
        } else if imageOrientation == .left {
            Core.rotate(src: mat, dst: mat, rotateCode: .ROTATE_90_COUNTERCLOCKWISE)
        } else if imageOrientation == .right {
            Core.rotate(src: mat, dst: mat, rotateCode: .ROTATE_90_CLOCKWISE)
        }

        return mat.toUIImage()
    }
}
