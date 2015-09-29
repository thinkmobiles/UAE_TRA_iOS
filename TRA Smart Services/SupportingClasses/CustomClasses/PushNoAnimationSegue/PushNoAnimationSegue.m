//
//  PushNoAnimationSegue.m
//  TRA Smart Services
//
//  Created by Admin on 20.08.15.
//

#import "PushNoAnimationSegue.h"

@implementation PushNoAnimationSegue

#pragma mark - Ovveride

- (void)perform
{
    [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:NO];
}

@end
