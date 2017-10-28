//
//  BOBarChartModel.m
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/27/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "BOBarChartModel.h"

@interface BOBarChartModel ()
@property (nonatomic, copy, readwrite) NSArray<BOBarModel*>* barModels;
@end

@implementation BOBarChartModel
- (instancetype)initWithBarModels:(NSArray<BOBarModel*>*)barModels {
  if (self = [super init]) {
    _barModels = barModels;
  }
  return self;
}
@end
