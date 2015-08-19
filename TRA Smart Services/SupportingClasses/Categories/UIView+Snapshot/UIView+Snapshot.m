//
//  UIView+Snapshot.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 17.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

#pragma mark - Public

- (UIView *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshotView = [[UIImageView alloc] initWithImage:image];
    snapshotView.layer.masksToBounds = YES;
    snapshotView.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshotView.layer.shadowRadius = 5.f;
    snapshotView.layer.shadowOpacity = 0.4f;
    return snapshotView;
}

@end