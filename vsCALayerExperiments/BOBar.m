//
//  BOBar.m
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/26/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "BOBar.h"
#import "BOColor.h"


static const CGFloat kBackgroundBarHeightIsMoreByThisFactor = .1f; //20% more than real bar height. example, if real bar height is 100, bgBar will be 120

static const CGFloat kHowBigIsItsShadow   = 0.5f; //the bigger the value, the longer the shadow on top
static const CGFloat kHowBlurIsIt         = 10.f; //the biiger the value, the blurreir it is
static const CGFloat kHowMuchVisibleIsIt  = .14f; //the bigger the value, the darker the shadow

static const CGFloat kHowLongWouldItTake  = 15.5f; //animation duration


@interface BOBar ()
@property (nonatomic) CGRect rectBarFrame;
@property (nonatomic) CGRect rectSecondaryBarFrame;
@property (nonatomic) CGFloat howBigIsItsShadow;
@end

@implementation BOBar

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self commonInit];
  }
  return self;
}
- (void)commonInit {
  self.translatesAutoresizingMaskIntoConstraints = NO;
  self.backgroundColor = [UIColor whiteColor];
  NSString* keypath = @"bounds";
  [self addObserver:self forKeyPath:keypath options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - helpers
- (void)initShapeLayer:(CAShapeLayer*)layer block:(void(^)(CAShapeLayer*))block {
  block(layer);
}

#pragma mark - shadow
- (void)animateShadowPath:(CAShapeLayer*)shapeLayer from:(CGPathRef)from to:(CGPathRef)to {
  [CATransaction begin];
  NSString* keyPath = NSStringFromSelector(@selector(shadowPath));
  
  CABasicAnimation* shadowPath = [CABasicAnimation animationWithKeyPath:keyPath];
  shadowPath.fromValue = (__bridge id)from;
  shadowPath.toValue = (__bridge id)to;
  
  shadowPath.duration = kHowLongWouldItTake;
  shadowPath.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [shapeLayer addAnimation:shadowPath forKey:@"Animate ShadowPath"];
  
  [CATransaction commit];
}

- (UIBezierPath*)shadowFrom {
  UIRectCorner rectCorner = UIRectCornerAllCorners;
  CGFloat screenHeight = self.rectBarFrame.size.height; //[UIScreen mainScreen].bounds.size.height;
  CGFloat y = screenHeight - self.rectBarFrame.size.height - self.howBigIsItsShadow;
  
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, 
                           y, 
                           self.rectBarFrame.size.width, 
                           (2.f * self.howBigIsItsShadow) 
                           );
  UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner cornerRadii:CGSizeMake(10.f, 10.f)];
  return shadowPath;
}
- (UIBezierPath*)shadowTo {
  UIRectCorner rectCorner = UIRectCornerAllCorners;
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, self.rectBarFrame.origin.y - self.howBigIsItsShadow, self.rectBarFrame.size.width, self.rectBarFrame.size.height + (2.f * self.howBigIsItsShadow) );
  UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner cornerRadii:CGSizeMake(10.f, 10.f)];
  return shadowPath;
}



- (void)addShadowToShapeLayer:(CAShapeLayer*)shapeLayer {
  shapeLayer.shadowColor = [BOColor skyBlueColor].CGColor;
  
  //using shadowOffset and shadowPath will most likely screw up your shit so be careful
  //shapeLayer.shadowOffset = CGSizeMake(0, -kHowBigIsItsShadow); //animatable
  shapeLayer.shadowRadius = kHowBlurIsIt;
  shapeLayer.shadowOpacity = kHowMuchVisibleIsIt; //animatable
  
  //shadowPath;
  UIBezierPath* to = [self shadowTo];
  UIBezierPath* from = [self shadowFrom];
  shapeLayer.shadowPath = to.CGPath;
  
  //animate shadow
  [self animateShadowPath:shapeLayer from:from.CGPath to:to.CGPath];
}

- (CAShapeLayer*)createMainBar {
  CAShapeLayer* bar = [CAShapeLayer layer];
  [self initShapeLayer:bar 
                 block:^(CAShapeLayer* shapeLayer){
                   shapeLayer.fillColor = [BOColor skyBlueColor].CGColor;
                   CGFloat width = self.bounds.size.width;
                   
                   CGRect rect = self.rectBarFrame;
                   NSLog(@"FRAME for BOBar is [%@]", NSStringFromCGRect(self.frame));
                   NSLog(@"So rectBarFrame here is [%@]", NSStringFromCGRect(self.rectBarFrame));
                   UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:width/2.f];
                   shapeLayer.path = path.CGPath;
                 }];
  return bar;
}


//- (UIBezierPath*)from {
//  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
//  CGFloat screenHeight = self.rectBarFrame.size.height; 
//  CGFloat y = screenHeight - self.rectBarFrame.size.height;
//  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, y, self.rectBarFrame.size.width, 0);
//  UIBezierPath* nofill = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
//  return nofill;
//}
//- (UIBezierPath*)to {
//  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
//  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, self.rectBarFrame.origin.y, self.rectBarFrame.size.width, self.rectBarFrame.size.height);
//  UIBezierPath* f = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
//  return f;
//}

- (UIBezierPath*)from {
  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
  CGFloat screenHeight = self.rectBarFrame.size.height; 
  CGFloat y = screenHeight + self.rectBarFrame.origin.y;
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, 
                           y, 
                           self.rectBarFrame.size.width, 
                           0.f);
  UIBezierPath* nofill = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
  return nofill;
}
- (UIBezierPath*)to {
  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
  CGFloat y = self.rectBarFrame.origin.y; // + self.rectBarFrame.size.height; 
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, 
                           y, //self.rectBarFrame.origin.y, 
                           self.rectBarFrame.size.width, 
                           self.rectBarFrame.size.height);
  UIBezierPath* f = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
  return f;
}



- (void)addFillAnimation:(CAShapeLayer*)shapeLayer {
  [CATransaction begin];
  CABasicAnimation* pathFillAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(path))];
  pathFillAnimation.fromValue = (id)([self from].CGPath);
  pathFillAnimation.toValue = (id)([self to].CGPath);
  pathFillAnimation.duration = kHowLongWouldItTake;
  pathFillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  //pathFillAnimation.fillMode = kCAFillModeForwards;
  pathFillAnimation.removedOnCompletion = YES;
  
  [shapeLayer addAnimation:pathFillAnimation forKey:@"Path"];
  [CATransaction commit];
}


- (CAShapeLayer*)createSecondaryBar {
  CAShapeLayer* bar = [CAShapeLayer layer];
  [self initShapeLayer:bar 
                 block:^(CAShapeLayer* shapeLayer){
                   
                   shapeLayer.fillColor = [BOColor skyBlueColorVeryFaint].CGColor;
                   
                   CGFloat width = self.bounds.size.width;
                   
                   CGRect rect = self.rectSecondaryBarFrame;
                   NSLog(@"FRAME for BOBar is [%@]", NSStringFromCGRect(self.frame));
                   NSLog(@"So rectSecondaryBarFrame here is [%@]", NSStringFromCGRect(self.rectSecondaryBarFrame));
                   
                   UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:width/2.f];
                   shapeLayer.path = path.CGPath;
                 }];
  return bar;
}

#pragma mark - api
- (void)createBar {
  {//main bar}
    CAShapeLayer* bar = [self createMainBar];
    [self addShadowToShapeLayer:bar];
    [self addFillAnimation:bar];
    [self.layer addSublayer:bar];
  }
  {
    //bar with light opacity shadow overlapping main bar
    CAShapeLayer* bar = [self createSecondaryBar];
    [self.layer addSublayer:bar];
  }
}


#pragma mark - kvo
- (void)dealloc {
  @try {
    NSString* keypath = @"bounds";
    [self removeObserver:self forKeyPath:keypath];
  }@catch(NSException* exception) {
    NSLog(@"Exception happened while removing observer");
  }
}
- (CGFloat)layerHorizontalMarginPercent {
  return 0.2f;
}
- (CGFloat)layerVerticalMarginPercent {
  return .2f;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  NSLog(@"observeValueForKeyPath for BOBar called");
  if ([keyPath isEqualToString:@"bounds"]) {
    //self.layer.frame = self.bounds;
    
    //adjust the height and width considering the shadow
    CGFloat marginPercentHorizontal = [self layerHorizontalMarginPercent];
    CGFloat marginPercentVertical = [self layerVerticalMarginPercent];
    CGFloat ourWidth = self.bounds.size.width;
    CGFloat ourHeight = self.bounds.size.height;
    
    CGFloat widthMargin = ourWidth * marginPercentHorizontal;
    CGFloat heightMargin = ourHeight * marginPercentVertical;
    
    
    CGFloat shadowHeight = ourHeight - heightMargin;
    self.howBigIsItsShadow = shadowHeight * kHowBigIsItsShadow;
    
    CGFloat x = self.bounds.origin.x + widthMargin;
    CGFloat y = self.bounds.origin.y + heightMargin; 
    CGFloat width = ourWidth - ( 2.f * widthMargin );
    CGFloat height = ourHeight - ( 2.f * heightMargin );
    
    CGRect adjustedRect = CGRectMake(x, y, width, height);
    self.rectBarFrame = adjustedRect;
    
    
    //
    // ---
    //
    CGFloat bgBarHeightFactor = kBackgroundBarHeightIsMoreByThisFactor * height;
    CGFloat bgBarHeight = 2.f * bgBarHeightFactor;
    
    CGFloat bgBarX = adjustedRect.origin.x;
    CGFloat bgBarY = adjustedRect.origin.y - bgBarHeightFactor;
    CGFloat bgBarWidth = adjustedRect.size.width;
    CGFloat bgComputedBarHeight = adjustedRect.size.height + bgBarHeight;
    
    CGRect rectSecondaryBarFrame = CGRectMake(bgBarX, 
                                              bgBarY, 
                                              bgBarWidth, 
                                              bgComputedBarHeight);
    self.rectSecondaryBarFrame = rectSecondaryBarFrame;
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

#pragma mark - constraints
+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}
- (void)updateConstraints {
  [super updateConstraints];
}

@end
