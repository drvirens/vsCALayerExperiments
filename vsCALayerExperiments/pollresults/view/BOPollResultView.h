//
//  BOPollResultView.h
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/28/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BOBarChartModel;

@interface BOPollResultView : UIView
- (instancetype)initWithBarChartModel:(BOBarChartModel*)barChartModel
                              question:(NSString*)question;
- (void)showPollsResults;
@end
