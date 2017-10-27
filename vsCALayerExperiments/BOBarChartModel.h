//
//  BOBarChartModel.h
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/27/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BOBarModel;

@interface BOBarChartModel : NSObject
@property (nonatomic, copy, readonly) NSArray<BOBarModel*>* barModels;

- (instancetype)initWithBarModels:(NSArray<BOBarModel*>*)barModels;

@end
