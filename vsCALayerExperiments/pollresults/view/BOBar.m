//
//  BOBar.m
//  vsCALayerExperiments
//
//  Created by Virendra Shakya on 10/26/17.
//  Copyright © 2017 Virendra Shakya. All rights reserved.
//

#import "BOBar.h"
#import "BOColor.h"
#import "BOBarModel.h"


//shape layer
static const CGFloat kBackgroundBarHeightIsMoreByThisFactor = .1f; //20% more than real bar height. example, if real bar height is 100, bgBar will be 120
static const CGFloat kHowBigIsItsShadow   = 0.33f; //the bigger the value, the longer the shadow on top
static const CGFloat kHowBlurIsIt         = 10.f; //the biiger the value, the blurreir it is
static const CGFloat kHowMuchVisibleIsIt  = .06f; //the bigger the value, the darker the shadow
static const CGFloat kHowLongWouldItTake  = .5f; //animation duration


//text layer
static const CGFloat kFontSizeBottomText = 12.f; //fontsize of top label aka subtitle label aka percent label
static const CGFloat kFontSizeTopTextSmall = 14.f; //fontsize of bottom label aka title label aka name label
static const CGFloat kFontSizeTopTextBig = 24.f;

static const CGFloat kMarginBottomSubTitle = 20.f;

@interface BOBar ()
@property (nonatomic) CGRect rectBarFrame;
@property (nonatomic) CGRect rectSecondaryBarFrame;
@property (nonatomic) CGFloat howBigIsItsShadow;
@property (nonatomic) CGFloat heightMargin;
@property (nonatomic) CGFloat bgBarHeightFactor;
@property (nonatomic, copy, readwrite) NSString* title;
@property (nonatomic, copy, readwrite) NSString* subTitle;
@property (nonatomic, readwrite) CGFloat progress;
@property (nonatomic, readwrite) UIColor* boBarColor;
@property (nonatomic, readwrite) BOOL showFullHeightForSecondaryBar;
@property (nonatomic, readwrite) BOOL animateTitleText;
@property (nonatomic, readwrite) BOOL animateSubTitleText;

@end

@implementation BOBar

#pragma mark - public api
- (instancetype)initWithBarModel:(BOBarModel*)barModel {
  if (self = [super init]) {
    _title = barModel.title;
    _subTitle = barModel.subTitle;
    _progress = barModel.progress;
    _boBarColor = barModel.boBarColor;
    _showFullHeightForSecondaryBar = barModel.showFullHeightForSecondaryBar;
    _animateTitleText = barModel.animateTitleText;
    _animateSubTitleText = barModel.animateSubTitleText;
    [self commonInit];
  }
  return self;
}


- (void)showBar {  
  {//main bar
    CAShapeLayer* bar = [self createMainBar];
    [self addShadowToShapeLayer:bar];
    [self addFillAnimation:bar];
    [self.layer addSublayer:bar];
  }
  {
    //bar with light opacity shadow overlapping main bar
    CAShapeLayer* bar = [self createSecondaryBar];
    if (NO == self.showFullHeightForSecondaryBar) {
      [self addFillAnimationToSecondaryBar:bar];
    }
    [self.layer addSublayer:bar];
  }
  {
    //top label == subtitle (percent shit)
    CATextLayer* subtitle = [self createTopTextLabel:self.subTitle];
    [self positionTopTextLabel:subtitle];
    if (self.animateSubTitleText) {
      [self addFontColorAndAlphaAnimation:subtitle];
    } else {
      
    }
    [self.layer addSublayer:subtitle];
  }
  {
    //bottom label == title (name shit)
    CATextLayer* title = [self createBottomTextLabel:self.title];
    [self positionBottomTextLabel:title];
    if (self.animateTitleText) {
      
    } else {
      
    }
    [self.layer addSublayer:title];
  }
}

- (void)addFontColorAndAlphaAnimation:(CATextLayer*)text {
  //foregroundColor
  CABasicAnimation* foregroundColor = [CABasicAnimation animationWithKeyPath:@"foregroundColor"];
  foregroundColor.fromValue = (id)[BOColor barSubTitleFaintColor].CGColor;
  foregroundColor.toValue = (id)[BOColor barSubTitleDarkColor].CGColor;
  
  //fontSize
  CABasicAnimation* fontSize = [CABasicAnimation animationWithKeyPath:@"fontSize"];
  fontSize.fromValue = @(kFontSizeTopTextSmall);
  fontSize.toValue = @(kFontSizeTopTextBig);

  //group
  CAAnimationGroup* group = [CAAnimationGroup animation];
  group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  group.duration = kHowLongWouldItTake;
  group.animations = @[foregroundColor, fontSize];
  group.removedOnCompletion = NO;
  [text addAnimation:group forKey:@"foregroundColor and fontSize"];
  
  text.foregroundColor = [BOColor barSubTitleDarkColor].CGColor;
  text.fontSize = kFontSizeTopTextBig;
}

- (void)commonInit {
  self.translatesAutoresizingMaskIntoConstraints = NO;
  self.backgroundColor = [UIColor clearColor];
  NSString* keypath = @"bounds";
  [self addObserver:self forKeyPath:keypath options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - text
- (CATextLayer*)createBottomTextLabel:(NSString*)title {
  CATextLayer* text = [CATextLayer layer];
  //XXX: Use attributed string
  text.string = title;
  text.foregroundColor = [BOColor barSubTitleFaintColor].CGColor;
  text.fontSize = kFontSizeBottomText;
  text.contentsScale = [UIScreen mainScreen].scale;
  text.alignmentMode = kCAAlignmentCenter;
  text.wrapped = YES;
  return text;
}
- (CATextLayer*)createTopTextLabel:(NSString*)title {
  CATextLayer* text = [CATextLayer layer];
  //XXX: Use attributed string
  text.string = title;
  text.foregroundColor = [BOColor barSubTitleDarkColor].CGColor;
  text.fontSize = kFontSizeTopTextBig;
  text.contentsScale = [UIScreen mainScreen].scale;
  text.alignmentMode = kCAAlignmentCenter;
  text.wrapped = YES;
  return text;
}

- (void)positionTopTextLabel:(CATextLayer*)text {
  {
    CGFloat width = self.bounds.size.width;
    CGFloat height = 2.f * kMarginBottomSubTitle;
    CGRect subtitleRect = CGRectMake(0., 0., width, height);
    
    text.frame = subtitleRect;
  }
  
  {
    CGFloat y = self.bounds.size.height - (3.f * kMarginBottomSubTitle);
    text.position = CGPointMake(self.bounds.size.width/2.f, y);
  }
}
- (void)positionBottomTextLabel:(CATextLayer*)text {
  {
    CGFloat width = self.bounds.size.width;
    CGFloat height = 2.f * kMarginBottomSubTitle;
    CGRect subtitleRect = CGRectMake(0., 0., width, height);
  
    text.frame = subtitleRect;
  }
  
  {
    CGFloat y = self.bounds.size.height - kMarginBottomSubTitle; 
    text.position = CGPointMake(self.bounds.size.width/2.f, y);
  }
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

- (void)addShadowToShapeLayer:(CAShapeLayer*)shapeLayer {
  shapeLayer.shadowColor = self.boBarColor.CGColor; 
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
                   shapeLayer.fillColor = self.boBarColor.CGColor; 
                   UIBezierPath* path = [self to];
                   shapeLayer.path = path.CGPath;
                 }];
  return bar;
}
- (CGRect)fromRect {
  CGFloat screenHeight = self.rectBarFrame.size.height; 
  CGFloat y = screenHeight + self.rectBarFrame.origin.y;
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, 
                           y, 
                           self.rectBarFrame.size.width, 
                           0.f);
  return rect;
}
- (CGRect)toRect {
  CGFloat screenHeight = self.rectBarFrame.size.height * (self.progress);
  CGFloat y = self.rectBarFrame.origin.y + (self.rectBarFrame.size.height - screenHeight); 
  CGRect rect = CGRectMake(self.rectBarFrame.origin.x, 
                           y,  
                           self.rectBarFrame.size.width, 
                           screenHeight
                           ); 
  return rect;
}
- (UIBezierPath*)from {
  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
  CGRect rect = [self fromRect];
  UIBezierPath* nofill = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
  return nofill;
}
- (UIBezierPath*)to {
  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
  CGRect rect = [self toRect];
  UIBezierPath* f = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
  return f;
}

- (UIBezierPath*)shadowFrom {
  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
  UIRectCorner rectCorner = UIRectCornerAllCorners;

  CGRect r = [self fromRect];
  CGFloat y = r.origin.y + (self.howBigIsItsShadow / 2.f);
  CGRect rect = CGRectMake(r.origin.x, y, r.size.width, r.size.height);
  
  UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect 
                                                   byRoundingCorners:rectCorner 
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
  return shadowPath;
}
- (UIBezierPath*)shadowTo {
  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
  UIRectCorner rectCorner = UIRectCornerAllCorners;
  CGFloat y = 0; 
  
  CGRect r = [self toRect];
  y = r.origin.y - (self.howBigIsItsShadow / 2.f); 
  CGFloat h = r.size.height + self.howBigIsItsShadow;
  CGRect rect = CGRectMake(r.origin.x, y, r.size.width, h);
  
  UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect 
                                                   byRoundingCorners:rectCorner 
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
  return shadowPath;
}

- (void)addFillAnimation:(CAShapeLayer*)shapeLayer {
  [CATransaction begin];
  CABasicAnimation* pathFillAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(path))];
  pathFillAnimation.fromValue = (id)([self from].CGPath);
  pathFillAnimation.toValue = (id)([self to].CGPath);
  pathFillAnimation.duration = kHowLongWouldItTake;
  pathFillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  pathFillAnimation.removedOnCompletion = NO;
  
  [shapeLayer addAnimation:pathFillAnimation forKey:@"Path"];
  [CATransaction commit];
}

- (UIBezierPath*)backgroundBarFrom {
  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
  UIRectCorner rectCorner = UIRectCornerAllCorners;
  
  CGRect r = [self fromRect];
  CGFloat y = r.origin.y + (self.bgBarHeightFactor/2.f);
  
  CGRect rect = CGRectMake(r.origin.x, y, r.size.width, r.size.height);
  
  UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect 
                                                   byRoundingCorners:rectCorner 
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
  return shadowPath;
}
- (UIBezierPath*)backgroundBarTo {
  CGFloat cornerRadius = self.rectBarFrame.size.width / 2.f;
  UIRectCorner rectCorner = UIRectCornerAllCorners;
  CGFloat y = 0; 
  
  CGRect r = [self toRect];
  y = r.origin.y - (self.bgBarHeightFactor / 2.f);
  
  CGFloat h = r.size.height + (self.bgBarHeightFactor);
  CGRect rect = CGRectMake(r.origin.x, y, r.size.width, h);
  
  UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect 
                                                   byRoundingCorners:rectCorner 
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
  return shadowPath;
}
- (void)addFillAnimationToSecondaryBar:(CAShapeLayer*)shapeLayer {
  [CATransaction begin];
  CABasicAnimation* pathFillAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(path))];
  pathFillAnimation.fromValue = (id)([self backgroundBarFrom].CGPath);
  pathFillAnimation.toValue = (id)([self backgroundBarTo].CGPath);
  pathFillAnimation.duration = kHowLongWouldItTake;
  pathFillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  pathFillAnimation.removedOnCompletion = NO;
  
  [shapeLayer addAnimation:pathFillAnimation forKey:@"Path"];
  [CATransaction commit];
}
- (CAShapeLayer*)createSecondaryBar {
  CAShapeLayer* bar = [CAShapeLayer layer];
  [self initShapeLayer:bar 
                 block:^(CAShapeLayer* shapeLayer){
                   UIColor* faintCOlor = [self.boBarColor colorWithAlphaComponent:0.1f];
                   shapeLayer.fillColor = faintCOlor.CGColor; 
                     
                   UIBezierPath* path = nil;
                   if (YES == self.showFullHeightForSecondaryBar) {
                     CGFloat width = self.bounds.size.width;
                     CGRect rect = self.rectSecondaryBarFrame;
                     path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:width/2.f];
                   } else {
                     path = [self backgroundBarTo];
                   }
                   shapeLayer.path = path.CGPath;
                 }];
  return bar;
}


#pragma mark - kvo
- (void)dealloc {
  NSLog(@"BOBar dealloc");
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
    self.layer.frame = self.bounds;
    [self computeVisibleAreaRect];
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)computeVisibleAreaRect {
  //adjust the height and width considering the shadow
  CGFloat marginPercentHorizontal = [self layerHorizontalMarginPercent];
  CGFloat marginPercentVertical = [self layerVerticalMarginPercent];
  CGFloat ourWidth = self.bounds.size.width;
  CGFloat ourHeight = self.bounds.size.height;
  
  CGFloat widthMargin = ourWidth * marginPercentHorizontal;
  CGFloat heightMargin = ourHeight * marginPercentVertical;
  self.heightMargin = heightMargin;
  
  CGFloat shadowHeight = ourHeight - heightMargin;
  self.howBigIsItsShadow = shadowHeight * kHowBigIsItsShadow;
  
  CGFloat progressHeight = 0.f; 
  
  CGFloat x = self.bounds.origin.x + widthMargin;
  CGFloat y = self.bounds.origin.y + heightMargin; 
  CGFloat width = ourWidth - ( 2.f * widthMargin );
  CGFloat height = ourHeight - ( 2.f * heightMargin ) - progressHeight;
  
  CGRect adjustedRect = CGRectMake(x, y, width, height);
  self.rectBarFrame = adjustedRect;
  
  
  //
  // ---
  //
  CGFloat bgBarHeightFactor = kBackgroundBarHeightIsMoreByThisFactor * height;
  CGFloat bgBarHeight = 2.f * bgBarHeightFactor;
  self.bgBarHeightFactor = bgBarHeightFactor;
  
  CGFloat bgBarX = adjustedRect.origin.x;
  CGFloat bgBarY = adjustedRect.origin.y - bgBarHeightFactor;
  CGFloat bgBarWidth = adjustedRect.size.width;
  CGFloat bgComputedBarHeight = adjustedRect.size.height + bgBarHeight;
  
  CGRect rectSecondaryBarFrame = CGRectMake(bgBarX, 
                                            bgBarY, 
                                            bgBarWidth, 
                                            bgComputedBarHeight);
  self.rectSecondaryBarFrame = rectSecondaryBarFrame;
  
}

#pragma mark - constraints
+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}
- (void)updateConstraints {
  [super updateConstraints];
}

@end
