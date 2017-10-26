//
//  ViewController.m
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/25/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) CGRect rectBarFrame;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor colorWithRed:102.f/255. green:51./255. blue:153./255. alpha:1.f];
  //[self testBasics];
  //[self testShapeWithRoundedRect];
  
  [self testShapeLayerOval];
}


//Gradient
//Bar
//Percent
//Name

- (UIColor*)skyBlueColor {
  return [UIColor colorWithRed:41.f/255.f green:198.f/255.f blue:250.f/255.f alpha:1.f];
}

- (void)initShapeLayer:(CAShapeLayer*)layer block:(void(^)(CAShapeLayer*))block {
  block(layer);
}

#pragma mark - shadow
//static const CGFloat kHowBigIsItsShadow   = 60.f; //the bigger the value, the longer the shadow on top
//static const CGFloat kHowBlurIsIt         = 20.f; //the biiger the value, the blurreir it is
//static const CGFloat kHowMuchVisibleIsIt  = .12f; //the bigger the value, the darker the shadow

static const CGFloat kHowBigIsItsShadow   = 120.f; //the bigger the value, the longer the shadow on top
static const CGFloat kHowBlurIsIt         = 10.f; //the biiger the value, the blurreir it is
static const CGFloat kHowMuchVisibleIsIt  = .12f; //the bigger the value, the darker the shadow


- (void)animateShadowPath:(CAShapeLayer*)shapeLayer from:(CGPathRef)from to:(CGPathRef)to {
    [CATransaction begin];
    //shadow shoud grow by 50% - NOT working yolo
    NSString* keyPath = NSStringFromSelector(@selector(shadowPath));
    
    CABasicAnimation* shadowPath = [CABasicAnimation animationWithKeyPath:keyPath];
    shadowPath.fromValue = (__bridge id)from;
    shadowPath.toValue = (__bridge id)to;
    
    shadowPath.duration = 10.f;
    shadowPath.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [shapeLayer addAnimation:shadowPath forKey:@"Animate ShadowPath"];
  
    //shapeLayer.shadowOffset = CGSizeMake(0, -(2.f * kHowBigIsItsShadow) );
    
    [CATransaction commit];
}


- (UIBezierPath*)shadowFrom {
  UIRectCorner rectCorner = UIRectCornerAllCorners;
  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
  CGFloat y = screenHeight - self.rectBarFrame.size.height - kHowBigIsItsShadow;
  
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, 
                           y, //self.rectBarFrame.origin.y - kHowBigIsItsShadow, 
                           self.rectBarFrame.size.width, 
                           (2.f * kHowBigIsItsShadow) //0. //self.rectBarFrame.size.height + (2.f * kHowBigIsItsShadow) 
                           );
  UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner cornerRadii:CGSizeMake(10.f, 10.f)];
  return shadowPath;

  
//  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
//  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//  CGFloat y = screenHeight - self.rectBarFrame.size.height;
//  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, y, self.rectBarFrame.size.width, 0);
//  UIBezierPath* nofill = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
//  return nofill;
}

- (UIBezierPath*)shadowTo {
  UIRectCorner rectCorner = UIRectCornerAllCorners;
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, self.rectBarFrame.origin.y - kHowBigIsItsShadow, self.rectBarFrame.size.width, self.rectBarFrame.size.height + (2.f * kHowBigIsItsShadow) );
  UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner cornerRadii:CGSizeMake(10.f, 10.f)];
  return shadowPath;
}

- (void)addShadowToShapeLayer:(CAShapeLayer*)shapeLayer {
  shapeLayer.shadowColor = [self skyBlueColor].CGColor;
  
  //using shadowOffset and shadowPath will most likely screw up your shit so be careful
  //shapeLayer.shadowOffset = CGSizeMake(0, -kHowBigIsItsShadow); //animatable
  shapeLayer.shadowRadius = kHowBlurIsIt;
  shapeLayer.shadowOpacity = kHowMuchVisibleIsIt; //animatable
  
  //shadowPath;
  
  UIBezierPath* to = [self shadowTo];
  UIBezierPath* from = [self shadowFrom];
  shapeLayer.shadowPath = to.CGPath;
  
  //animate
  [self animateShadowPath:shapeLayer from:from.CGPath to:to.CGPath];
}

- (CAShapeLayer*)createMainBar {
  CAShapeLayer* bar = [CAShapeLayer layer];
  [self initShapeLayer:bar 
                 block:^(CAShapeLayer* shapeLayer){
                   static const CGFloat kHowThickIsIt = 50.f;
                   static const CGFloat kHowBigIsIt = 300.f;
                   
                   shapeLayer.fillColor = [self skyBlueColor].CGColor;
                   
                   CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                   CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
                   
                   CGFloat x = (screenWidth - kHowThickIsIt)/2.f;
                   CGFloat y = (screenHeight - kHowBigIsIt)/2.f;
                   CGFloat width = kHowThickIsIt;
                   CGFloat height = kHowBigIsIt;
                   CGRect rect = CGRectMake(x, y, width, height);
                   self.rectBarFrame = rect;
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
  pathFillAnimation.duration = 10.f;
  pathFillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  //pathFillAnimation.fillMode = kCAFillModeForwards;
  pathFillAnimation.removedOnCompletion = YES;
  
  [shapeLayer addAnimation:pathFillAnimation forKey:@"Path"];
  [CATransaction commit];
}
- (void)createBar {
  CAShapeLayer* bar = [self createMainBar];
  [self addShadowToShapeLayer:bar];
  [self addFillAnimation:bar];

  [self.view.layer addSublayer:bar];
}
- (void)testShapeLayerOval {
  [NSTimer scheduledTimerWithTimeInterval:1.f repeats:NO block:^(NSTimer * _Nonnull timer) {
    [self createBar];
  }];
}









- (void)testShapeWithRoundedRect {
  //draw a line from point a to point b
  CGFloat w = [UIScreen mainScreen].bounds.size.width;
  CGFloat x = w/2.f;
  CGFloat h = [UIScreen mainScreen].bounds.size.height;
  CGFloat y = h/2.f;
  
  CGFloat oneFourthHeight = h * .25f;
  //CGFloat oneFourthWidth = w * .25f;
  CGFloat x1 = x;
  CGFloat y1 = y - oneFourthHeight;
  CGFloat x2 = x;
  CGFloat y2 = y + oneFourthHeight;
  
  CGRect rect = CGRectMake(x, y, w, w);
  
  CGPoint pointA = CGPointMake(x2, y2);
  CGPoint pointB = CGPointMake(x1, y1);
  
  
  
  //
  //Shape Layer
  //
  {
    CAShapeLayer* line = [CAShapeLayer layer];
    //line.bounds = rect; //in what region should we draw
    line.lineWidth = kBarThickness;
    line.fillColor = [UIColor blueColor].CGColor;
    line.strokeColor = [UIColor purpleColor].CGColor;
    line.cornerRadius = 25.f;
    
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:25.f];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    line.path = path.CGPath;
    [self addProgressAnimation:line];
    
    
    
    [self.view.layer addSublayer:line];
  }
 
}

static const CGFloat kBarThickness = 60.f;
- (void)testBasics {
  //draw a line from point a to point b
  CGFloat w = [UIScreen mainScreen].bounds.size.width;
  CGFloat x = w/2.f;
  CGFloat h = [UIScreen mainScreen].bounds.size.height;
  CGFloat y = h/2.f;
  
  CGFloat oneFourthHeight = h * .25f;
  //CGFloat oneFourthWidth = w * .25f;
  CGFloat x1 = x;
  CGFloat y1 = y - oneFourthHeight;
  CGFloat x2 = x;
  CGFloat y2 = y + oneFourthHeight;
  
  CGRect rect = CGRectMake(x, y, w, w);
  
  CGPoint pointA = CGPointMake(x2, y2);
  CGPoint pointB = CGPointMake(x1, y1);
  
  
  
  //
  //Shape Layer
  //
  {

    
    CAShapeLayer* line = [CAShapeLayer layer];
    //line.bounds = rect; //in what region should we draw
    line.lineWidth = kBarThickness;
    line.fillColor = [UIColor blueColor].CGColor;
    line.strokeColor = [UIColor purpleColor].CGColor;

    
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    line.path = path.CGPath;
    
    [self addProgressAnimation:line];
    
    CGRect pathRect = path.bounds;
    //CGRect gradientBounds = CGRectMake(pathRect.origin.x - 50.f, pathRect.origin.y, 100.f, pathRect.size.height + 50);
    CGRect gradientBounds = CGRectMake(pathRect.origin.x, pathRect.origin.y, 2, pathRect.size.height + 50);
    line.shadowColor = [UIColor redColor].CGColor;
    line.shadowOpacity = 1.f;
    line.shadowOffset = CGSizeMake(0, 0);
    line.shadowRadius = kBarThickness/2;
    CGPathRef shadowPath = nil; //CGPathCreateWithRoundedRect(CGRectInset(gradientBounds, -10, -50), 10, 10, nil);
    CGAffineTransform* transform = nil;
    shadowPath = CGPathCreateWithRoundedRect(gradientBounds, gradientBounds.size.width/2., gradientBounds.size.width/2., transform);
    //shadowPath = CGPathCreateWithRoundedRect(CGRectInset(gradientBounds, -10, -50), 10, 10, nil);
    line.shadowPath = shadowPath;

      
    
//    CAGradientLayer* gradient = [self createGradient];
//    CGRect pathRect = path.bounds;
//    //CGRect gradientBounds = CGRectMake(pathRect.origin.x - 50.f, pathRect.origin.y, 100.f, pathRect.size.height + 50);
//    CGRect gradientBounds = CGRectMake(pathRect.origin.x, pathRect.origin.y, kBarThickness, pathRect.size.height + 50);
//    gradient.frame = gradientBounds;
//    
//    //gradient.shadowRadius = 20.f;
//    gradient.shadowColor = [UIColor purpleColor].CGColor;
//    gradient.shadowOpacity = 1.f;
//    //gradient.shadowOffset = CGSizeMake(10, 10);
//    
////    maskLayer.shadowPath = CGPathCreateWithRoundedRect(CGRectInset(yourImageView.bounds, 5, 5), 10, 10, nil)
//
//    //CGPathRef shadowPath = CGPathCreateWithRoundedRect(CGRectInset(gradientBounds, 5, -50), 10, 10, nil);
//    CGPathRef shadowPath = CGPathCreateWithRoundedRect(CGRectInset(gradientBounds, -10, -50), 10, 10, nil);
//    CGAffineTransform* transform = nil;
//    shadowPath = CGPathCreateWithRoundedRect(gradientBounds, gradientBounds.size.width/2., gradientBounds.size.width/2., transform);
//    //shadowPath = CGPathCreateWithRoundedRect(CGRectInset(gradientBounds, -10, -50), 10, 10, nil);
//    gradient.shadowPath = shadowPath;
//    
//    //line.mask = gradient;
//    [self.view.layer addSublayer:gradient];
    
    [self.view.layer addSublayer:line];
  }

  
  //
  //Gradient Layer
  //
  {
//  CAGradientLayer* gradient = [CAGradientLayer layer];
//  gradient.bounds = self.view.bounds; //in what region should we draw
//  gradient.colors = @[ (__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor ];
//  [self.view.layer addSublayer:gradient];
  }
}

- (CAGradientLayer*)createGradient {
  CAGradientLayer* gradient = [CAGradientLayer layer];
  gradient.colors = @[ (__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor ];
  return gradient;
}

- (void)addProgressAnimation:(CALayer*)line {
  [CATransaction begin];
  //progress
  CABasicAnimation* progress = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  progress.fromValue = @(0.0f);
  progress.toValue = @(1.0);
  
  //animation group
  CAAnimationGroup* group = [CAAnimationGroup animation];
  group.duration = .5f;
  group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [group setAnimations:@[progress]]; //add progress to group
  
  [line addAnimation:group forKey:@"progress"];
  
  [CATransaction commit];
}


@end
