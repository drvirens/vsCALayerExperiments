//
//  BOBarModel.m
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/27/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "BOBarModel.h"

@interface BOBarModel ()

@property (nonatomic, copy, readwrite) NSString* title;
@property (nonatomic, copy, readwrite) NSString* subTitle;
@property (nonatomic, readwrite) CGFloat progress;
@property (nonatomic, readwrite) UIColor* boBarColor;

@end

@implementation BOBarModel
- (instancetype)initWithTitle:(NSString*)title
                     subTitle:(NSString*)subTitle
                     progress:(CGFloat)progress
                   boBarColor:(UIColor*)boBarColor {
  if (self = [super init]) {
    _title = title;
    _subTitle = subTitle;
    _progress = progress;
    _boBarColor = boBarColor;
  }
  return self;
}
@end
