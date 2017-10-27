//
//  BOBar.h
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/26/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BOBarModel;

@interface BOBar : UIView

- (instancetype)initWithBarModel:(BOBarModel*)barModel;
- (void)showBar;

@end
