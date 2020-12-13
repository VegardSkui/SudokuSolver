# Sudoku Solver

![Screenshots](Images/Screenshots.png)

## Setup

Download [OpenCV](https://github.com/opencv/opencv) version 4.5.0 for iOS and
move the `opencv2.framework` bundle into the `Frameworks` folder. You may have
to build OpenCV yourself to get the Swift bindings to work due to differing
Swift compiler versions, see [this
page](https://docs.opencv.org/master/d5/da3/tutorial_ios_install.html) for
instructions.

## Digit Classification

Digits are classified using a CoreML model trained on the [MNIST](http://yann.lecun.com/exdb/mnist/)
dataset. The model is provided by Apple under the MIT [license](https://docs-assets.developer.apple.com/coreml/models/Image/DrawingClassification/MNISTClassifier/LICENSE-MIT.txt)
and can be found [here](https://developer.apple.com/machine-learning/models/).
