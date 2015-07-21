//
//  Animation.h
//  PTSquared
//
//  Created by Kirill Gorbushko on 29.04.15.
//  Copyright (c) 2015 Kirill Gorbushko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animation : NSObject

+ (CABasicAnimation *)fadeAnimFromValue:(CGFloat)fromValue to:(CGFloat)toValue delegate:(id)delegate;

@end
