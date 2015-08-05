//
//  InternetSpeedChecker.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 05.08.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@protocol InternetSpeedCheckerDelegate  <NSObject>

@required
- (void)speedCheckerDidCalculateSpeed:(CGFloat)speed;

@end

@interface InternetSpeedChecker : NSObject <NSURLConnectionDataDelegate>

@property (weak, nonatomic) id <InternetSpeedCheckerDelegate> delegate;

- (void)performFastInternetSpeedTest;

@end
