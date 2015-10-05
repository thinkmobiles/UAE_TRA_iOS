//
//  NSDictionary+Safe.m
//  PTSquared
//
//  Created by Kirill Gorbushko on 13.05.15.
//  Copyright (c) 2015 Kirill Gorbushko. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)

#pragma mark - Public

- (NSDictionary *)removeNullValues
{
    NSMutableDictionary *mutDictionary = [self mutableCopy];
    NSMutableArray *keysToDelete = [NSMutableArray array];
    [mutDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) {
            [keysToDelete addObject:key];
        }
    }];
    
    [mutDictionary removeObjectsForKeys:keysToDelete];
    return [mutDictionary copy];
}

@end
