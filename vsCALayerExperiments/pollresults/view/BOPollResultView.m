//
//  BOPollResultView.m
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/28/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "BOPollResultView.h"
#import "BOColor.h"
#import "BOFont.h"
#import "BOBarChart.h"

@interface BOPollResultView ()
@property (nonatomic) BOOL hasAppliedConstraints;
@property (nonatomic) UILabel* labelTitle;
@property (nonatomic, copy, readwrite) NSString* headerText;
@property (nonatomic) BOBarChart* barChartView;
@property (nonatomic) BOBarChartModel* barChartModel;
@end

@implementation BOPollResultView

- (instancetype)initWithBarChartModel:(BOBarChartModel*)barChartModel
                             question:(NSString*)question {
  if (self = [super init]) {
    _barChartModel = barChartModel;
    _headerText = question;
    [self commonInit];
  }
  return self;
}

- (void)dealloc {
  NSLog(@"BOPollResultView dealloc");
}

- (void)commonInit {
  self.hasAppliedConstraints = NO;
  self.translatesAutoresizingMaskIntoConstraints = NO;
#if defined DEBUG_UI_VIEW
  self.backgroundColor = [UIColor brownColor];
#endif
  
  [self addSubview:self.labelTitle];
  self.labelTitle.text = self.headerText;
  
  self.barChartView = [[BOBarChart alloc] initWithWithChartModel:self.barChartModel];
  [self addSubview:self.barChartView];
}

- (void)showPollsResults {
  [self.barChartView showBars];
}


#pragma mark - UI Elements
- (UILabel*)labelTitle {
  if (!_labelTitle) {
    UILabel* label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [BOColor barSubTitleFaintColor];
    label.font = [BOFont fontQuestion];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.minimumScaleFactor = 0.5; 
    label.adjustsFontSizeToFitWidth = YES;
    _labelTitle = label;
  }
  return _labelTitle;
}

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

- (void)applyConstraints {
  UIView* parent = self;  
  {
  // Label question
  NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:self.labelTitle
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.barChartView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.f
                                                             constant:-0.f];
    //bottom.priority = UILayoutPriorityDefaultLow;
  
  NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:self.labelTitle
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:parent
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.f
                                                          constant:0.f];
  
  NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:self.labelTitle
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:parent
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.f
                                                           constant:20.f];
  
  NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:self.labelTitle
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parent
                                                           attribute:NSLayoutAttributeTrailing
                                                          multiplier:1.f
                                                            constant:-20.f];
  
  [parent addConstraints:@[top, left, right, bottom]];
  
}
  
  //bar chart view
  {
    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:self.barChartView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.labelTitle attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f];
    NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:self.barChartView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeBottom multiplier:1.f constant:-0.f];
    NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:self.barChartView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeLeading multiplier:1.f constant:0.f];
    NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:self.barChartView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-0.f];
    
    [parent addConstraints:@[top, bottom, left, right]];
  }
  
}

@end
