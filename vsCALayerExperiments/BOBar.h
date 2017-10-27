//
//  BOBar.h
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/26/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOBar : UIView
@property (nonatomic, copy, readonly) NSString* title;
@property (nonatomic, copy, readonly) NSString* subTitle;
@property (nonatomic, readonly) CGFloat progress;

- (instancetype)initWithTitle:(NSString*)title subTitle:(NSString*)subTitle;
- (void)createBarWithProgress:(CGFloat)progress;

@end
