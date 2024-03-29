//
//  BarcodeReader.h
//  QRCodeReader
//
//  Created by Admin on 04.05.15.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^AccessGranted)(BOOL status);

@protocol BarcodeCodeReaderDelegate <NSObject>

@optional
- (void)readerDidChangeStatusTo:(NSString *)status;

@required
- (void)readerDidFinishCapturingWithResult:(NSString *)result;

@end

@interface BarcodeCodeReader : NSObject <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) id <BarcodeCodeReaderDelegate> delegate;
@property (nonatomic) BOOL isReading;
@property (assign, nonatomic) CGRect acceptableRect;

- (instancetype)initWithView:(UIView *)viewPreview;
- (void)startStopReading;

- (void)relayout;

+ (BOOL)isDeviceHasBackCamera;
+ (void)checkPermissionForCamera:(AccessGranted)status;

@end
