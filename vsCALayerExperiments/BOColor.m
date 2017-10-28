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
+ (UIColor*)pinkColor {
  return [UIColor magentaColor];
}
+ (UIColor*)skyBlueColorVeryFaint {
  return [UIColor colorWithRed:41.f/255.f green:198.f/255.f blue:250.f/255.f alpha:.1f];
}

+ (UIColor*)barSubTitleFaintColor {
  return [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.5f];
}
+ (UIColor*)barSubTitleDarkColor {
  return [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.9f];
}
+ (UIColor*)barTitleColor {
  return [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.95f];
}
+ (UIColor*)darkPurple {
  //return [UIColor colorWithRed:57.f/255. green:37./255. blue:104./255. alpha:1.f];
  //return [UIColor colorWithRed:51.f/255. green:29./255. blue:102./255. alpha:1.f]; //OKAY
  return [UIColor colorWithRed:43.f/255. green:26./255. blue:81./255. alpha:1.f];
}
+ (UIColor*)brightGreen {
  return [UIColor colorWithRed:104.f/255. green:239./255. blue:173./255. alpha:1.f];
}
+ (UIColor*)brightYellow {
  return [UIColor colorWithRed:255.f/255. green:255.f/255. blue:0.f/255. alpha:1.f];
}
+ (UIColor*)faintPurple {
  return [UIColor colorWithRed:155.f/255. green:38./255. blue:175./255. alpha:1.f];
}

@end
