//
//  BOBarChart.h
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/27/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BOBarChartModel;

@interface BOBarChart : UIView
- (instancetype)initWithWithChartModel:(BOBarChartModel*)chartModel;
- (void)showBars;
@end
