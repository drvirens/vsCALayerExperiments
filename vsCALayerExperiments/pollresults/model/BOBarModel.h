//
//  BOBarModel.h
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/27/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BOBarModel : NSObject

@property (nonatomic, copy, readonly) NSString* title;
@property (nonatomic, copy, readonly) NSString* subTitle;
@property (nonatomic, readonly) CGFloat progress;
@property (nonatomic, readonly) UIColor* boBarColor;
@property (nonatomic, readonly) BOOL showFullHeightForSecondaryBar;
@property (nonatomic, readonly) BOOL animateTitleText;
@property (nonatomic, readonly) BOOL animateSubTitleText;

- (instancetype)initWithTitle:(NSString*)title
                     subTitle:(NSString*)subTitle
                     progress:(CGFloat)progress
                   boBarColor:(UIColor*)boBarColor
showFullHeightForSecondaryBar:(BOOL)showFullHeightForSecondaryBar
             animateTitleText:(BOOL)animateTitleText
          animateSubTitleText:(BOOL)animateSubTitleText;

@end
