//
//  BOPollResultsViewController.m
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/28/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "BOPollResultsViewController.h"
#import "BOColor.h"
#import "BOBarModel.h"
#import "BOBarChartModel.h"
#import "BOPollResultView.h"

#define SHOW_FULL_LENGHT_SECONDARY_BAR NO
#define ANIMATE_TITLE_LABEL NO
#define ANIMATE_SUB_TITLE_LABEL YES


@interface BOPollResultsViewController ()
@property (nonatomic) BOPollResultView* pollResultView;
@end

@implementation BOPollResultsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [BOColor darkPurple];
}
- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self addPollResultView];
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self.pollResultView showPollsResults];
}
- (BOOL)prefersStatusBarHidden {
  return YES;
}
#pragma mark - polls results view
- (void)addPollResultView {
  BOOL showFullHeightForSecondaryBar = SHOW_FULL_LENGHT_SECONDARY_BAR;
  BOOL animateTitleText = ANIMATE_TITLE_LABEL;
  BOOL animateSubTitleText = ANIMATE_SUB_TITLE_LABEL;
  
  BOBarModel* model1 = [[BOBarModel alloc] initWithTitle:@"BOWEN SWIFT" subTitle:@"92%"     progress:.92f boBarColor:[BOColor skyBlueColor] showFullHeightForSecondaryBar:showFullHeightForSecondaryBar animateTitleText:animateTitleText animateSubTitleText:animateSubTitleText];
  BOBarModel* model2 = [[BOBarModel alloc] initWithTitle:@"VIRENDRA SHAKYA" subTitle:@"10%" progress:.10f boBarColor:[BOColor pinkColor]showFullHeightForSecondaryBar:showFullHeightForSecondaryBar animateTitleText:animateTitleText animateSubTitleText:animateSubTitleText];
  BOBarModel* model3 = [[BOBarModel alloc] initWithTitle:@"YOLANDA" subTitle:@"4%"          progress:.04f boBarColor:[BOColor brightGreen]showFullHeightForSecondaryBar:showFullHeightForSecondaryBar animateTitleText:animateTitleText animateSubTitleText:animateSubTitleText];
  BOBarModel* model4 = [[BOBarModel alloc] initWithTitle:@"BRENT CORRIGAN" subTitle:@"43%"  progress:.43f boBarColor:[BOColor brightYellow]showFullHeightForSecondaryBar:showFullHeightForSecondaryBar animateTitleText:animateTitleText animateSubTitleText:animateSubTitleText];
  
  
  BOBarChartModel* barChartModel = [[BOBarChartModel alloc] initWithBarModels:@[model1, model2, model3, model4]];
  self.pollResultView = [[BOPollResultView alloc] initWithBarChartModel:barChartModel question:@"Most likely to have their own talk show"];
  
  [self.view addSubview:self.pollResultView];
  
  UIView* parent = self.view;
  //constraints
  {
    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:self.pollResultView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f];
    NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:self.pollResultView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeBottom multiplier:1.f constant:-0.f];
    NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:self.pollResultView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeLeading multiplier:1.f constant:0.f];
    NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:self.pollResultView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0.f];
    
    [parent addConstraints:@[top, bottom, left, right]];
  }
}

@end
