//
//  BOBar.m
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/26/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "BOBar.h"
#import "BOColor.h"


static const CGFloat kHowThickIsIt = 50.f;
static const CGFloat kHowBigIsIt = 300.f;

static const CGFloat kHowBigIsItsShadow   = 100.f; //the bigger the value, the longer the shadow on top
static const CGFloat kHowBlurIsIt         = 10.f; //the biiger the value, the blurreir it is
static const CGFloat kHowMuchVisibleIsIt  = .14f; //the bigger the value, the darker the shadow

static const CGFloat kHowLongWouldItTake  = 10.5f; //animation duration


@interface BOBar ()
@property (nonatomic) CGRect rectBarFrame;
@property (nonatomic) CGRect rectSecondaryBarFrame;

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
  //shadow shoud grow by 50% - NOT working yolo
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
  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
  CGFloat y = screenHeight - self.rectBarFrame.size.height - kHowBigIsItsShadow;
  
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, 
                           y, 
                           self.rectBarFrame.size.width, 
                           (2.f * kHowBigIsItsShadow) 
                           );
  UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner cornerRadii:CGSizeMake(10.f, 10.f)];
  return shadowPath;
}

- (UIBezierPath*)shadowTo {
  UIRectCorner rectCorner = UIRectCornerAllCorners;
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, self.rectBarFrame.origin.y - kHowBigIsItsShadow, self.rectBarFrame.size.width, self.rectBarFrame.size.height + (2.f * kHowBigIsItsShadow) );
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
                   
                   CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                   CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
                   
                   CGFloat x = (screenWidth - kHowThickIsIt)/2.f;
                   CGFloat y = (screenHeight - kHowBigIsIt)/2.f;
                   CGFloat width = kHowThickIsIt;
                   CGFloat height = kHowBigIsIt;
                   //CGRect rect = CGRectMake(x, y, width, height);
                   //self.rectBarFrame = rect;
                   CGRect rect = self.rectBarFrame;
                   NSLog(@"FRAME for BOBar is [%@]", NSStringFromCGRect(self.frame));
                   NSLog(@"So rectBarFrame here is [%@]", NSStringFromCGRect(self.rectBarFrame));
                   UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:width/2.f];
                   shapeLayer.path = path.CGPath;
                 }];
  return bar;
}


- (UIBezierPath*)from {
  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
  CGFloat y = screenHeight - self.rectBarFrame.size.height;
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, y, self.rectBarFrame.size.width, 0);
  UIBezierPath* nofill = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
  return nofill;
}

- (UIBezierPath*)to {
  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, self.rectBarFrame.origin.y, self.rectBarFrame.size.width, self.rectBarFrame.size.height);
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
                   CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                   CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
                   
                   CGFloat factor = .1*kHowBigIsIt;
                   const CGFloat howBigIsIt = kHowBigIsIt + factor;
                   
                   shapeLayer.fillColor = [BOColor skyBlueColorVeryFaint].CGColor;
                   
                   CGFloat x = (screenWidth - kHowThickIsIt)/2.f;
                   CGFloat y = (screenHeight - howBigIsIt)/2.f;
                   CGFloat width = kHowThickIsIt;
                   CGFloat height = howBigIsIt;
//                   CGRect rect = CGRectMake(x, y, width, height);
//                   self.rectSecondaryBarFrame = rect;
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
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  NSLog(@"observeValueForKeyPath for BOBar called");
  if ([keyPath isEqualToString:@"bounds"]) {
    self.layer.frame = self.bounds;
    self.rectBarFrame = self.frame;
    self.rectSecondaryBarFrame = self.frame;
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
