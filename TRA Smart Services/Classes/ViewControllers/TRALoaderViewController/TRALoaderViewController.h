//
//  TRALoaderViewController.h
//  TRA Smart Services
//
//  Created by Admin on 21.09.15.
//

#import "BaseDynamicUIViewController.h"

#import "RatingView.h"

static CGFloat const TRAAnimationDuration = 2;

typedef NS_ENUM(NSInteger, TRACompleteStatus) {
    TRACompleteStatusFailure = 0,
    TRACompleteStatusSuccess = 1,
};

@interface TRALoaderViewController : BaseDynamicUIViewController <RatingViewDelegate>

@property (strong, nonatomic) void (^TRALoaderWillClose)();
@property (weak, nonatomic) IBOutlet RatingView *ratingView;

+ (TRALoaderViewController *)presentLoaderOnViewController:(UIViewController *)presenter requestName:(NSString *)requestName closeButton:(BOOL)button;

- (void)dismissTRALoader;
- (void)setCompletedStatus:(TRACompleteStatus)status withDescription:(NSString *)description;

@end
