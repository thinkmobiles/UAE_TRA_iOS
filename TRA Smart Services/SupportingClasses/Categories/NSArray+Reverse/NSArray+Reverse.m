//
//  NSArray+Reverse.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 12.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "NSArray+Reverse.h"

@implementation NSArray (Reverse)

#pragma mark - Public

- (NSArray *)reversedArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id element in self.reverseObjectEnumerator) {
        [array addObject:element];
    }
    return array;
}

@end
