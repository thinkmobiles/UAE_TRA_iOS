//
//  BarcodeReader.h
//  QRCodeReader
//
//  Created by Kirill Gorbushko on 04.05.15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol BarcodeCodeReaderDelegate <NSObject>

@optional
- (void)readerDidChangeStatusTo:(NSString *)status;

@required
- (void)readerDidFinishCapturingWithResult:(NSString *)result;

@end

@interface BarcodeCodeReader : NSObject <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) id <BarcodeCodeReaderDelegate> delegate;
@property (nonatomic) BOOL isReading;

- (instancetype)initWithView:(UIView *)viewPreview;
- (void)startStopReading;

- (void)relayout;

@end
