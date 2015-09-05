//
//  BlackWhiteConverter.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 26.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BlackWhiteConverter.h"

@interface BlackWhiteConverter()

@property (strong, nonatomic) CIContext *ciContext;

@end

@implementation BlackWhiteConverter

#pragma mark - Public

+ (instancetype)sharedManager
{
    static BlackWhiteConverter *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[BlackWhiteConverter alloc] init];
    });
    return sharedManager;
}

- (UIImage *)convertedBlackAndWhiteImage:(UIImage *)sourceImage
{
    CIImage *inputCIImage = [CIImage imageWithCGImage:sourceImage.CGImage];

    inputCIImage = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey, inputCIImage, @"inputIntensity", @(1), nil ].outputImage;
    inputCIImage = [CIFilter filterWithName:@"CIVignette" keysAndValues:kCIInputImageKey, inputCIImage, @"inputIntensity", @(0.5), nil ].outputImage;
    inputCIImage = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, inputCIImage, @"inputBrightness", @(-0.05), nil ].outputImage;
    inputCIImage = [CIFilter filterWithName:@"CIDotScreen" keysAndValues:kCIInputImageKey, inputCIImage, @"inputSharpness", @(0.01), nil ].outputImage;
    
    CGImageRef cgiimage = [self.ciContext createCGImage:inputCIImage fromRect:inputCIImage.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(cgiimage);
    
    return newImage;
}

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ciContext = [BlackWhiteConverter sharedCIContextWithEAGLContext];
    }
    return self;
}

#pragma mark - Private

+ (CIContext *)sharedCIContextWithEAGLContext
{
    static CIContext *ciContext;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        EAGLContext *eaglContext= [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        NSDictionary *option = @{kCIContextOutputColorSpace : [NSNull null]};
        ciContext = [CIContext contextWithEAGLContext:eaglContext options:option];
    });
    
    return ciContext;
}

@end