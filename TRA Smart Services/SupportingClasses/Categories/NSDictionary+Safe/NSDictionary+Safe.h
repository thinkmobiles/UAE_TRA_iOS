//
//  NSDictionary+Safe.h
//  PTSquared
//
//  Created by Kirill Gorbushko on 13.05.15.
//  Copyright (c) 2015 Kirill Gorbushko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

- (NSDictionary *)removeNullValues;

@end
