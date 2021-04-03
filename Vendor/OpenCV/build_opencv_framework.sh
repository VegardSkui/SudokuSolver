#!/bin/sh

# Builds opencv2.framework and places it in PROJECT_ROOT/Frameworks,
# removing the old one if necessary.
# https://docs.opencv.org/master/d5/da3/tutorial_ios_install.html

# Change the working directory to the location of the script
cd -P -- "$(dirname -- "$0")"

python opencv/platforms/ios/build_framework.py ios \
    --iphoneos_archs arm64 \
    --iphonesimulator_archs x86_64

rm -rf ../../Frameworks/opencv2.framework
cp -r ios/opencv2.framework ../../Frameworks
