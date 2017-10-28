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

@interface BOPollResultView ()
@property (nonatomic) BOOL hasAppliedConstraints;
@property (nonatomic) UILabel* labelTitle;
@property (nonatomic, copy, readwrite) NSString* headerText;
@end

@implementation BOPollResultView

- (instancetype)initWithWithQuestion:(NSString*)question {
  if (self = [super init]) {
    _headerText = question;
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  self.hasAppliedConstraints = NO;
  self.translatesAutoresizingMaskIntoConstraints = NO;
#if defined DEBUG_UI_VIEW
  self.backgroundColor = [UIColor greenColor];
#endif
  
  [self addSubview:self.labelTitle];
  self.labelTitle.text = self.headerText;
}


#pragma mark - UI Elements
- (UILabel*)labelTitle {
  if (!_labelTitle) {
    UILabel* label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [BOColor barSubTitleFaintColor];
    label.font = [BOFont fontQuestion];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 1;
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
  [self addLabelConstraints];
}


- (void)addLabelConstraints {
  UIView* parent = self;
  // Label Tip Body
  NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.labelTitle
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:parent
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.f
                                                             constant:-0.f];
  
  NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.labelTitle
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:parent
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.f
                                                          constant:0.f];
  
  NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.labelTitle
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:parent
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.f
                                                           constant:20.f];
  
  NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.labelTitle
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parent
                                                           attribute:NSLayoutAttributeTrailing
                                                          multiplier:1.f
                                                            constant:-20.f];
  
  [parent addConstraints:@[top, left, right]];
}

@end
