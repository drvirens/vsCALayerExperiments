//
//  BOColor.m
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/26/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "BOColor.h"

@implementation BOColor

+ (UIColor*)skyBlueColor {
  return [UIColor colorWithRed:41.f/255.f green:198.f/255.f blue:250.f/255.f alpha:1.f];
}
+ (UIColor*)skyBlueColorVeryFaint {
  return [UIColor colorWithRed:41.f/255.f green:198.f/255.f blue:250.f/255.f alpha:.1f];
}

+ (UIColor*)barSubTitleColor {
  return [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.5f];
}
+ (UIColor*)barTitleColor {
  return [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.95f];
}
@end
