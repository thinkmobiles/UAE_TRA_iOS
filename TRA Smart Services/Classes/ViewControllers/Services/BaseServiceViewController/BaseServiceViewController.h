//
//  BaseServiceViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 31.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "TRALoaderViewController.h"

@interface BaseServiceViewController : BaseDynamicUIViewController

- (void)presentLoginIfNeeded;
- (void)updateColors;

@end