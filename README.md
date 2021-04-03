# Sudoku Solver

![Screenshots](Images/Screenshots.png)

## Setup

Build the [OpenCV](https://github.com/opencv/opencv) iOS framework bundle by
running the script `build_opencv_framework.sh` in `Vendor/OpenCV`. Note that Git
submodules must be retrieved first.

## Digit Classification

Digits are classified using a CoreML model trained on the [MNIST](http://yann.lecun.com/exdb/mnist/)
dataset. The model is provided by Apple under the MIT [license](https://docs-assets.developer.apple.com/coreml/models/Image/DrawingClassification/MNISTClassifier/LICENSE-MIT.txt)
and can be found [here](https://developer.apple.com/machine-learning/models/).
