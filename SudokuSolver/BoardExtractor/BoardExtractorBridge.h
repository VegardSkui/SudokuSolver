//
//  BoardExtractorBridge.h
//  SudokuSolver
//
//  Created by Vegard Skui on 10/12/2020.
//  Copyright © 2020 Vegard Skui. All rights reserved.
//

#ifndef BoardExtractorBridge_h
#define BoardExtractorBridge_h

#include <UIKit/UIKit.h>

@interface BoardExtractorBridge : NSObject

- (UIImage *) extractBoardFrom: (UIImage *) image;

@end

#endif /* BoardExtractorBridge_h */
