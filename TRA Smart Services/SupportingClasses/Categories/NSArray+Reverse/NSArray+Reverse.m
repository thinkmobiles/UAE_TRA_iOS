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

- (NSMutableArray *)reversedArrayByElementsInGroup:(NSInteger)elementsInGroup
{
    NSMutableArray *reversedItems = [[NSMutableArray alloc] init];
    
    if (self.count < elementsInGroup) {
        reversedItems = [[self reversedArray] mutableCopy];
    } else {
        int i;
        for (i = 0; i < (int)(self.count / elementsInGroup); i++) {
            int j = (int)elementsInGroup - 1;
            while (j >= 0) {
                [reversedItems addObject:self[j + i * (int)elementsInGroup]];
                j--;
            }
        }
        for (int k = (int)self.count - 1; k >= i* elementsInGroup; k--) {
            [reversedItems addObject:self[k]];
        }
    }
    return reversedItems;
}

@end
