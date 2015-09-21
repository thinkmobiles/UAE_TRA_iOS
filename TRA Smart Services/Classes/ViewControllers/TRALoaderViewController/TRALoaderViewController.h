//
//  TRALoaderViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@interface TRALoaderViewController : BaseDynamicUIViewController

@property (strong, nonatomic) void (^TRALoaderWillClose)();

+ (TRALoaderViewController *)presentLoaderOnViewController:(UIViewController *)presenter requestName:(NSString *)requestName;
- (void)dismissTRALoader;
- (void)setCompletedStatus;

@end
