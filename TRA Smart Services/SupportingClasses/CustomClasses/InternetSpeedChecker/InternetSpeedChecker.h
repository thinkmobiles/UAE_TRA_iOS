//
//  InternetSpeedChecker.h
//  TRA Smart Services
//
//  Created by Admin on 05.08.15.
//

typedef NS_ENUM(NSUInteger, SpeedTestType) {
    SpeedTestTypeFast,
    SpeedTestTypeAccurate
};

@protocol InternetSpeedCheckerDelegate  <NSObject>

@required
- (void)speedCheckerDidCalculateSpeed:(CGFloat)speed testMethod:(SpeedTestType)method;

@end

@interface InternetSpeedChecker : NSObject <NSURLConnectionDataDelegate>

@property (weak, nonatomic) id <InternetSpeedCheckerDelegate> delegate;

- (void)performFastInternetSpeedTest;
- (void)performAccurateInternetTest;
- (void)stopTest;

@end
