//
//  UINavigationController+Transparent.h
//  PTSquared
//
//  Created by Kirill Gorbushko on 23.04.15.
//  Copyright (c) 2015 Kirill Gorbushko. All rights reserved.
//

@interface UINavigationController (Transparent)

- (void)presentTransparentNavigationBarAnimated:(BOOL)animated;
- (void)hideTransparentNavigationBarAnimated:(BOOL)animated;

@end
