//
//  NSArray+Reverse.h
//  TRA Smart Services
//
//  Created by Admin on 12.08.15.
//

#import <Foundation/Foundation.h>

@interface NSArray (Reverse)

- (NSArray *)reversedArray;
- (NSMutableArray *)reversedArrayByElementsInGroup:(NSInteger)elementsInGroup;

@end
