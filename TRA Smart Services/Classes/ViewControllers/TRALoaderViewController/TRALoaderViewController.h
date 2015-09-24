//
//  TRALoaderViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

typedef NS_ENUM(NSInteger, TRACompleteStatus) {
    TRACompleteStatusUnknown = -1,
    TRACompleteStatusFailure = 0,
    TRACompleteStatusSuccess = 1,
};

@interface TRALoaderViewController : BaseDynamicUIViewController

@property (strong, nonatomic) void (^TRALoaderWillClose)();

+ (TRALoaderViewController *)presentLoaderOnViewController:(UIViewController *)presenter requestName:(NSString *)requestName closeButton:(BOOL)button;

- (void)dismissTRALoader;
- (void)setCompletedStatus:(TRACompleteStatus)status withDescription:(NSString *)description;

@end
