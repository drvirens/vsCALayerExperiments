//
//  BOBarChart.m
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/27/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "BOBarChart.h"
#import "BOBar.h"
#import "BOBarChartModel.h"

@interface BOBarChart ()
@property (nonatomic, copy, readwrite) BOBarChartModel* chartModel;
@property (nonatomic) BOOL hasAppliedConstraints;
@property (nonatomic) NSMutableArray<BOBar*>* barsArray;
@end

@implementation BOBarChart

- (instancetype)initWithWithChartModel:(BOBarChartModel*)chartModel {
  if (self = [super init]) {
    _chartModel = chartModel;
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  self.hasAppliedConstraints = NO;
  self.translatesAutoresizingMaskIntoConstraints = NO;
#if defined DEBUG_UI_VIEW
  self.backgroundColor = [UIColor magentaColor];
#endif
  
  self.barsArray = [@[] mutableCopy];
  
  //create bars based on models
  [self.chartModel.barModels enumerateObjectsUsingBlock:^(BOBarModel * _Nonnull barModel, NSUInteger idx, BOOL * _Nonnull stop) {
    BOBar* bar = [[BOBar alloc] initWithBarModel:barModel];
    [self.barsArray addObject:bar];
    [self addSubview:bar];
  }];
}

- (void)showBars {
  [self.barsArray enumerateObjectsUsingBlock:^(BOBar * _Nonnull bar, NSUInteger idx, BOOL * _Nonnull stop) {
    [bar showBar];
  }];
}
#pragma mark - content size
//- (CGSize)intrinsicContentSize {TRACE
//  CGFloat height = [self.cardLayoutConstraintConstants getHeightActionBarView];
//  return CGSizeMake(UIViewNoIntrinsicMetric, height); 
//}

#pragma mark - api


#pragma mark - helpers


#pragma mark - UI Elements


#pragma mark - constraints
+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (void)updateConstraints {
  if (!self.hasAppliedConstraints) {
    [self applyConstraints];
    //self.hasAppliedConstraints = YES;
  }
  [super updateConstraints];
}

- (CGFloat)ourTotalWidth {
  CGFloat w = [UIScreen mainScreen].bounds.size.width;
  return w;
}

- (void)applyConstraints {
  UIView* parent = self;
  
  [self.barsArray enumerateObjectsUsingBlock:^(BOBar * _Nonnull bar, NSUInteger idx, BOOL * _Nonnull stop) {
    //
    //width = all are equals.
    //
    if (idx == 0) {//we compute first bar width..
      CGFloat w = [self ourTotalWidth] * 0.25f;
      NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:bar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:w];
      [bar addConstraints:@[width] ];
    } else {//and apply equal width constraint to remaining bars
      BOBar* firstBar = self.barsArray[0];
      NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:bar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:firstBar attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.f];
      [parent addConstraints:@[width] ];
    }
    
    NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:bar
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:parent
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.f
                                                               constant:-0.f];
    
    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:bar
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parent
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.f
                                                            constant:0.f];
    CGFloat multiplier = 1.f; //TODO
    CGFloat constant = 10.f; //TODO
    NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:bar
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:parent
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:multiplier
                                                             constant:constant];
    
    [parent addConstraints:@[bottom, top, left]];
  }];
  
  /*
  NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.quizContainerView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:parent
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.f
                                                             constant:-0.f];
  
  NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.quizContainerView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:parent
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.f
                                                          constant:0.f];
  
  NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.quizContainerView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:parent
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.f
                                                           constant:0.f];
  
  NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.quizContainerView
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parent
                                                           attribute:NSLayoutAttributeTrailing
                                                          multiplier:1.f
                                                            constant:-0.f];
  
  [parent addConstraints:@[bottom, top, left, right]];
  */
}

@end
