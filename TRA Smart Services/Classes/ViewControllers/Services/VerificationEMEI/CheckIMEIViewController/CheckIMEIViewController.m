//
//  CheckIMEIViewController.m
//  TRA Smart Services
//
//  Created by Admin on 13.08.15.
//

#import "CheckIMEIViewController.h"
#import "CheckIMEIModel.h"

@interface CheckIMEIViewController ()

@property (weak, nonatomic) IBOutlet UIView *barcodeView;
@property (weak, nonatomic) IBOutlet UIView *scannerZoneView;

@property (strong, nonatomic) BarcodeCodeReader *reader;
@property (strong, nonatomic) UIImage *navigationBarImage;

@property (strong, nonatomic) CALayer *shapeLayer;
@property (strong, nonatomic) CAShapeLayer *lineLayer;

@end

@implementation CheckIMEIViewController

#pragma mark - LifeCycle

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.needTransparentNavigationBar) {
        [self.reader relayout];
        [self drawLayers];
        self.reader.acceptableRect = self.scannerZoneView.frame;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareReaderIfNeeded];
    
    if (self.needTransparentNavigationBar) {
        self.navigationBarImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    } 
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.reader startStopReading];

    if (self.needTransparentNavigationBar) {
        [self.navigationController.navigationBar setBackgroundImage:self.navigationBarImage forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - BarcodeCodeReaderDelegate

- (void)readerDidFinishCapturingWithResult:(NSString *)result
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.didFinishWithResult) {
            weakSelf.didFinishWithResult(result);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"checkIMEIViewController.title");
}

- (void)updateColors
{
    [super updateColors];

    [super updateBackgroundImageNamed:@"img_bg_service"];
}

#pragma mark - Private

- (void)prepareReaderIfNeeded
{
    if (self.needTransparentNavigationBar && self.barcodeView) {
        if ([BarcodeCodeReader isDeviceHasBackCamera]) {
            __weak typeof(self) weakSelf = self;
            [BarcodeCodeReader checkPermissionForCamera:^(BOOL status) {
                if (status) {
                    weakSelf.reader = [[BarcodeCodeReader alloc] initWithView:weakSelf.barcodeView];
                    weakSelf.reader.delegate = weakSelf;
                    [weakSelf.reader startStopReading];
                } else {
                    [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.NoCameraPermissionsGranted") delegate:weakSelf];
                }
            }];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:settingsURL];
}

#pragma mark - Drawing

- (void)drawLayers
{
    [self.shapeLayer removeFromSuperlayer];
    
    self.shapeLayer = [CALayer layer];
    self.shapeLayer.frame = self.barcodeView.bounds;
    self.shapeLayer.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3f].CGColor;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *boundPath = [UIBezierPath bezierPathWithRect:self.barcodeView.frame];
    UIBezierPath *scannerViewPath = [UIBezierPath bezierPathWithRoundedRect:self.scannerZoneView.frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8, 8)];
    [boundPath appendPath:scannerViewPath];
    [boundPath setUsesEvenOddFillRule:YES];
    
    maskLayer.path = boundPath.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    self.shapeLayer.masksToBounds = YES;
    self.shapeLayer.mask = maskLayer;
    
    [self.lineLayer removeFromSuperlayer];
    
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.frame = self.scannerZoneView.frame;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, self.scannerZoneView.bounds.size.height / 2)];
    [linePath addLineToPoint:CGPointMake(self.scannerZoneView.bounds.size.width, self.scannerZoneView.bounds.size.height /2)];
    self.lineLayer.strokeColor = [UIColor greenColor].CGColor;
    self.lineLayer.lineWidth = 1.f;
    self.lineLayer.path = linePath.CGPath;
    
    [self.barcodeView.layer addSublayer:self.lineLayer];
    [self.barcodeView.layer addSublayer:self.shapeLayer];
    
    self.scannerZoneView.layer.borderColor = [UIColor greenColor].CGColor;
    self.scannerZoneView.layer.borderWidth = 1.f;
}

@end