//
//  PushNoAnimationSegue.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 20.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "PushNoAnimationSegue.h"

@implementation PushNoAnimationSegue

#pragma mark - Ovveride

- (void)perform
{
    [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:NO];
}

@end
