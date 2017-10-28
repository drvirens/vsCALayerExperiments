//
//  BOFont.m
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/28/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOFont.h"

static const CGFloat kStandardComparisonSizeFromSketch = 568.f;
static const CGFloat kStandardFontSizeQuestion = 22.f;

@implementation BOFont

+ (UIFont*)fontQuestion {
  CGFloat newFontSize = kStandardFontSizeQuestion;
  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
  
  newFontSize = (screenHeight * kStandardFontSizeQuestion) / kStandardComparisonSizeFromSketch;
  NSLog(@"AvenirNext-Bold = [%f]", newFontSize);
  return [UIFont fontWithName:@"AvenirNext-Bold" size:newFontSize];
}


@end
