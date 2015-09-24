//
//  TRALoaderViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "TRALoaderViewController.h"
#import "Animation.h"

static NSString *const LoaderIdentifier = @"loaderTRAId";

static NSString *const LoaderBackgroundOrange = @"img_bg_1";

@interface TRALoaderViewController ()

@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (strong, nonatomic) CAShapeLayer *hexLayer;
@property (strong, nonatomic) CAShapeLayer *tailLayer;
@property (strong, nonatomic) CAShapeLayer *backgroundLayer;

@property (copy, nonatomic) NSString *requestName;
@property (strong, nonatomic) UIViewController *presenter;

@end

@implementation TRALoaderViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view.layer addAnimation:[Animation fadeAnimFromValue:0.f to:1.0f delegate:nil] forKey:nil];
    self.view.layer.opacity = 1.0f;
}

#pragma mark - Public

+ (TRALoaderViewController *)presentLoaderOnViewController:(UIViewController *)presenter requestName:(NSString *)requestName closeButton:(BOOL)show
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TRALoaderViewController *loader = [storyboard instantiateViewControllerWithIdentifier:LoaderIdentifier];
    loader.modalPresentationStyle = UIModalPresentationOverFullScreen;
    if (requestName.length) {
        loader.requestName = requestName;
    }
    loader.presenter = presenter;
    presenter.modalPresentationStyle = UIModalPresentationCurrentContext;
    [presenter presentViewController:loader animated:NO completion:^{
        [loader startAnimations];
    }];
    
    loader.closeButton.hidden = !show;
    [loader.closeButton setTitle:dynamicLocalizedString(@"TRALoader.backButton.cancel") forState:UIControlStateNormal];
    
    return loader;
}

- (void)dismissTRALoader
{
    [self closeButtonTapped:nil];
}

- (void)setCompletedStatus:(TRACompleteStatus)status withDescription:(NSString *)description
{
    [self.tailLayer removeAllAnimations];
    [self.hexLayer removeAllAnimations];
    self.tailLayer.strokeColor = [UIColor clearColor].CGColor;
    self.backgroundLayer.strokeColor = [UIColor clearColor].CGColor;
    self.hexLayer.strokeColor = [UIColor clearColor].CGColor;
    
    self.logoImageView.layer.opacity = 0.f;
    CABasicAnimation *fadeAnim = [Animation fadeAnimFromValue:1 to:0 delegate:self];
    fadeAnim.duration = 0.2;
    [self.logoImageView.layer addAnimation:fadeAnim forKey:@"hideImage"];
    
    CABasicAnimation *pathFilling = [self pathFillingAnimations] ;
    pathFilling.duration = 0.2f;
    [self.hexLayer addAnimation:pathFilling forKey:@"fillingColorAnimation"];
    self.hexLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.closeButton.hidden = NO;
    self.closeButton.layer.opacity = 0.f;
    [self.closeButton.layer addAnimation:[Animation fadeAnimFromValue:0 to:1 delegate:nil] forKey:nil];
    self.closeButton.layer.opacity = 1.f;
    [self.closeButton setTitle:dynamicLocalizedString(@"TRALoader.backButton.title") forState:UIControlStateNormal];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.type = kCATransitionPush;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.informationLabel.layer addAnimation:animation forKey:nil];
    
    self.informationLabel.text = dynamicLocalizedString(@"TRALoader.information.finish");
}

#pragma mark - IBActions

- (IBAction)closeButtonTapped:(id)sender
{
    [self.view.layer addAnimation:[Animation fadeAnimFromValue:1.f to:0.0f delegate:self] forKey:@"dismissView"];
    self.view.layer.opacity = 0.0f;
    
    if (self.TRALoaderWillClose) {
        self.TRALoaderWillClose();
    }
}

#pragma mark - SuperClassMethods

- (void)updateColors
{
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        self.backgroundImageView.image = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:[UIImage imageNamed:LoaderBackgroundOrange]];
    } else {
        NSString *name = [NSString stringWithFormat:@"img_bg_%i", (int)self.dynamicService.colorScheme];
        self.backgroundImageView.image = [UIImage imageNamed:name];
    }
}

- (void)localizeUI
{
    self.informationLabel.text = [NSString stringWithFormat:dynamicLocalizedString(@"TRALoader.information.begin"), self.requestName];
}

#pragma mark - Private

- (void)startAnimations
{
    CGRect hexagonRect = CGRectMake(self.loaderView.bounds.origin.x + 1, self.loaderView.bounds.origin.y + 1, self.loaderView.bounds.size.width - 2, self.loaderView.bounds.size.height - 2);
    
    self.hexLayer = [self layerWithColor:[UIColor whiteColor] inRect:hexagonRect];
    [self.loaderView.layer addSublayer:self.hexLayer];
    
    self.backgroundLayer = [self layerWithColor:[UIColor lightGrayColor] inRect:hexagonRect];
    [self.loaderView.layer insertSublayer:self.backgroundLayer below:self.hexLayer];
    
    CABasicAnimation *pathAnimation = [self strokeEndAnimation];
    CABasicAnimation *pathAnimation2 = [self strokeStartAnimation];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[pathAnimation, pathAnimation2];
    group.repeatCount = MAXFLOAT;
    group.duration = 2.f;
    
    self.tailLayer = [self layerWithColor:[UIColor clearColor] inRect:hexagonRect];
    [self.loaderView.layer insertSublayer:self.tailLayer above:self.hexLayer];
    
    [self.hexLayer addAnimation:group forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.hexLayer animationForKey:@"fillingColorAnimation"]) {
        CAShapeLayer *checkSymbolLayer = [self checkSymbolLayer];
        [self.loaderView.layer addSublayer:checkSymbolLayer];
        [checkSymbolLayer addAnimation:[self strokeEndAnimation] forKey:nil];
    } else if (anim == [self.view.layer animationForKey:@"dismissView"]) {
        [self.view.layer removeAllAnimations];
        [self.presenter dismissViewControllerAnimated:NO completion:nil];
    } else if (anim == [self.logoImageView.layer animationForKey:@"hideImage"]) {
        [self.logoImageView.layer removeAllAnimations];
        self.logoImageView.hidden = YES;
    }
}

#pragma mark - Animations

- (CABasicAnimation *)pathFillingAnimations
{
    CABasicAnimation *pathFilling = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    pathFilling.fromValue = (id)[UIColor clearColor].CGColor;
    pathFilling.toValue = (id)[UIColor whiteColor].CGColor;
    pathFilling.duration = 0.3;
    pathFilling.delegate = self;
    pathFilling.removedOnCompletion = NO;
    return pathFilling;
}

- (CABasicAnimation *)strokeStartAnimation
{
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.duration = 2;
    strokeStartAnimation.beginTime = 0.2;
    strokeStartAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    strokeStartAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return strokeStartAnimation;
}

- (CABasicAnimation *)strokeEndAnimation
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return pathAnimation;
}

#pragma mark - Layers

- (CAShapeLayer *)checkSymbolLayer
{
    CAShapeLayer *checkSymbolLayer = [CAShapeLayer layer];
    checkSymbolLayer.frame = self.loaderView.layer.bounds;
    checkSymbolLayer.strokeColor = [self.dynamicService currentApplicationColor].CGColor;
    checkSymbolLayer.fillColor = [UIColor clearColor].CGColor;
    checkSymbolLayer.path = [self bezierPathForCheckSymbolInRect:self.loaderView.bounds].CGPath;
    checkSymbolLayer.lineWidth = 3.f;
    return checkSymbolLayer;
}

- (CAShapeLayer *)layerWithColor:(UIColor *)color inRect:(CGRect)rect
{
    CAShapeLayer *maskWhiteLayer = [CAShapeLayer layer];
    maskWhiteLayer.frame = self.loaderView.layer.bounds;
    maskWhiteLayer.strokeColor = color.CGColor;
    maskWhiteLayer.fillColor = [UIColor clearColor].CGColor;
    UIBezierPath *path = [self hexagonPathForRect:rect];
    maskWhiteLayer.path = path.CGPath;
    maskWhiteLayer.lineWidth = 2.f;
    return maskWhiteLayer;
}

#pragma mark - Calculations

- (UIBezierPath *)bezierPathForCheckSymbolInRect:(CGRect)parentRect
{
    CGFloat innerRectHeight = 0.3 * parentRect.size.height;
    CGFloat innerRectWidth = 0.45 * parentRect.size.width;
    CGFloat originX = (parentRect.size.width - innerRectWidth) / 2;
    CGFloat originY = (parentRect.size.height - innerRectHeight) / 2;
    CGRect innerRect = CGRectMake(originX, originY, innerRectWidth, innerRectHeight);
    
    UIBezierPath *checkSymbolBezierPath = [UIBezierPath bezierPath];
    [checkSymbolBezierPath moveToPoint:CGPointMake(innerRect.origin.x, innerRect.origin.y + innerRect.size.height * 0.5)];
    [checkSymbolBezierPath addLineToPoint:CGPointMake(innerRect.origin.x + innerRect.size.width * 0.33f, innerRect.origin.y + innerRect.size.height)];
    [checkSymbolBezierPath addLineToPoint:CGPointMake(innerRect.origin.x + innerRect.size.width, innerRect.origin.y)];
    checkSymbolBezierPath.lineJoinStyle = kCGLineJoinRound;
    
    return checkSymbolBezierPath;
}

- (UIBezierPath *)hexagonPathForRect:(CGRect)hexagonRect
{
    UIBezierPath *hexagonPath = [UIBezierPath bezierPath];
    [hexagonPath moveToPoint:CGPointMake(CGRectGetMidX(hexagonRect), 0)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMaxX(hexagonRect), CGRectGetMaxY(hexagonRect) * 0.25)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMaxX(hexagonRect), CGRectGetMaxY(hexagonRect) * 0.75)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMidX(hexagonRect), CGRectGetMaxY(hexagonRect))];
    [hexagonPath addLineToPoint:CGPointMake(0, CGRectGetMaxY(hexagonRect) * 0.75)];
    [hexagonPath addLineToPoint:CGPointMake(0, CGRectGetMaxY(hexagonRect) * 0.25)];
    [hexagonPath closePath];
    hexagonPath.lineJoinStyle = kCGLineJoinRound;
    return hexagonPath;
}

@end
