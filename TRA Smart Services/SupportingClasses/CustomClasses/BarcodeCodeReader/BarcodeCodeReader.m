//
//  BarcodeReader.m
//  QRCodeReader
//
//  Created by Kirill Gorbushko on 04.05.15.
//  Copyright (c) 2015. All rights reserved.
//

#import "BarcodeCodeReader.h"

@interface BarcodeCodeReader()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (strong, nonatomic) UIView *previewLayer;
@property (strong, nonatomic) UIView *scannerIndicatorView;

@end

@implementation BarcodeCodeReader

#pragma mark - Public

- (instancetype)initWithView:(UIView *)viewPreview;
{
    self = [super init];
    if (self) {
        if (viewPreview) {
            self.previewLayer = viewPreview;
            self.isReading = NO;
    #if !TARGET_IPHONE_SIMULATOR
            [self setupSession];
    #endif
            [self prepareScanningIndicatorView];
        } else {
            return nil;
        }
    }
    return self;
}

- (void)prepareScanningIndicatorView
{
    self.scannerIndicatorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.scannerIndicatorView.layer.borderColor = [UIColor greenColor].CGColor;
    self.scannerIndicatorView.layer.borderWidth = 1.f;
    [self.previewLayer addSubview:self.scannerIndicatorView];
}

- (void)relayout
{
    self.videoPreviewLayer.frame = self.previewLayer.bounds;
}

- (void)startReading
{
    [self.captureSession startRunning];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(readerDidChangeStatusTo:)]) {
        [self.delegate readerDidChangeStatusTo:@"Reading started"];
    }

}

- (void)stopReading
{
    [self.captureSession stopRunning];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(readerDidChangeStatusTo:)]) {
        [self.delegate readerDidChangeStatusTo:@"Reading stoped"];
    }
}

- (void)startStopReading
{
    if (self.isReading) {
        [self stopReading];
    } else {
        [self startReading];
    }
    
    self.isReading = !self.isReading;
}

+ (BOOL)isDeviceHasBackCamera
{
    BOOL deviceHasBackCamera = NO;
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in videoDevices) {
        if ( device.position == AVCaptureDevicePositionBack) {
            deviceHasBackCamera = YES;
        }
    }
    
    return deviceHasBackCamera;
}

+ (void)checkPermissionForCamera:(AccessGranted)status
{
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType:completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    status(YES);
                });
            } else {
                status(NO);
            }
        }];
    }
}

#pragma mark - Private

- (void)setupSession
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(readerDidChangeStatusTo:)]) {
        [self.delegate readerDidChangeStatusTo:@"Preparing..."];
    }
    
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (input) {
        self.captureSession = [[AVCaptureSession alloc] init];
        if ([self.captureSession canAddInput:input]) {
            [self.captureSession addInput:input];
        }
        
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.captureSession addOutput:captureMetadataOutput];
        
        dispatch_queue_t dispatchQueue = dispatch_queue_create("com.thinkMobiles.captureQueue.barcodeReading.TRA.smart.service", DISPATCH_QUEUE_SERIAL);
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        [captureMetadataOutput setMetadataObjectTypes: [self allowedTypes]];
        
        self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [self.videoPreviewLayer setFrame:self.previewLayer.bounds];
        
        [self.previewLayer.layer addSublayer:self.videoPreviewLayer];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(readerDidChangeStatusTo:)]) {
            [self.delegate readerDidChangeStatusTo:@"Ready to start scanning"];
        }
    } else {
        NSLog(@"%@", [error localizedDescription]);
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects firstObject];
        for (NSString *type in [self allowedTypes]) {
            if ([metadataObj.type isEqualToString:type]) {
                
                AVMetadataMachineReadableCodeObject *barcodeObject = (AVMetadataMachineReadableCodeObject *)[self.videoPreviewLayer transformedMetadataObjectForMetadataObject:metadataObj];
                if (CGRectIntersectsRect(barcodeObject.bounds, self.acceptableRect)) {
                    __weak typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.scannerIndicatorView.frame = barcodeObject.bounds;
                    });
                    if (self.delegate && [self.delegate respondsToSelector:@selector(readerDidFinishCapturingWithResult:)]) {
                        [self.delegate readerDidFinishCapturingWithResult: metadataObj.stringValue];
                    }
                }
                self.isReading = NO;
            }
        }
    } else {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.scannerIndicatorView.frame = CGRectZero;
        });
    }
}

#pragma mark - Private

- (NSArray *)allowedTypes
{
    return [NSArray arrayWithObjects:AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, nil];
}

@end
