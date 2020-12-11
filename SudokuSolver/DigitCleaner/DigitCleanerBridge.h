//
//  DigitCleanerBridge.h
//  SudokuSolver
//
//  Created by Vegard Skui on 11/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

#ifndef DigitCleanerBridge_h
#define DigitCleanerBridge_h

#include <UIKit/UIKit.h>

@interface DigitCleanerBridge : NSObject

- (UIImage *) cleanDigitIn: (UIImage *) image;

@end


#endif /* DigitCleanerBridge_h */
