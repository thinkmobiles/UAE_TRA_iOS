//
//  InternetSpeedChecker.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 05.08.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "InternetSpeedChecker.h"

static CGFloat MaximumElapsedTime = 2.f;
static NSUInteger Repeats = 10;
static NSUInteger AccurateTestRepeats = 15;


static NSString *const TestFilePath = @"https://drive.google.com/uc?export=download&id=0B1GU18BxUf8hTFdUcFpMejlYUXc";

@interface InternetSpeedChecker()

@property (strong, nonatomic) NSURLConnection *URLConnection;
@property (assign, nonatomic) NSUInteger downloadedBytes;
@property (strong, nonatomic) NSDate *startTime;

@property (assign, nonatomic) NSInteger tryCount;
@property (assign, nonatomic) CGFloat averageSpeed;
@property (assign, nonatomic) BOOL isAccurateTest;

@end

@implementation InternetSpeedChecker

#pragma mark - Public

- (void)performFastInternetSpeedTest
{
    self.tryCount = 0;
    self.isAccurateTest = NO;
    [self testInternetDownloadSpeed];
}

- (void)performAccurateInternetTest
{
    self.tryCount = 0;
    self.isAccurateTest = YES;
    [self testInternetDownloadSpeed];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(nonnull NSURLConnection *)connection didReceiveResponse:(nonnull NSURLResponse *)response
{
    self.startTime = [NSDate date];
}

- (void)connection:(nonnull NSURLConnection *)connection didFailWithError:(nonnull NSError *)error
{
    if (self.URLConnection) {
        self.URLConnection = nil;
    }
    [self calculateMegabytesPerSecond];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.URLConnection = nil;
    [self calculateMegabytesPerSecond];
}

- (void)connection:(nonnull NSURLConnection *)connection didReceiveData:(nonnull NSData *)data
{
    self.downloadedBytes += data.length;
}

#pragma mark - Private

- (void)testInternetDownloadSpeed
{
    NSURL *url = [NSURL URLWithString:TestFilePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.startTime = [NSDate date];
    self.downloadedBytes = 0;
    self.URLConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MaximumElapsedTime * NSEC_PER_SEC));
    __weak typeof(self) weakSelf = self;
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        if (weakSelf.URLConnection){
            [weakSelf.URLConnection cancel];
            weakSelf.URLConnection = nil;
            [weakSelf calculateMegabytesPerSecond];
        }
    });
}

- (void)calculateMegabytesPerSecond
{
    CGFloat speed = -1.f;
    if (self.startTime){
        NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:self.startTime];
        speed = self.downloadedBytes / elapsedTime / 1024 / 1024;
    }
    
    if (self.isAccurateTest) {
        if (self.tryCount < AccurateTestRepeats && speed >= 0) {
            self.averageSpeed += speed;
            self.tryCount++;
            [self testInternetDownloadSpeed];
        } else if (self.tryCount == AccurateTestRepeats) {
            self.averageSpeed /= (CGFloat)AccurateTestRepeats;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(speedCheckerDidCalculateSpeed:testMethod:)]) {
                [self.delegate speedCheckerDidCalculateSpeed:self.averageSpeed testMethod:SpeedTestTypeAccurate];
            }
            
        }
    } else {
        if (speed < 0 && self.tryCount < Repeats) {
            self.tryCount++;
            [self testInternetDownloadSpeed];
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(speedCheckerDidCalculateSpeed:testMethod:)]) {
                [self.delegate speedCheckerDidCalculateSpeed:speed testMethod:SpeedTestTypeFast];
            }
        }
    }
}

@end