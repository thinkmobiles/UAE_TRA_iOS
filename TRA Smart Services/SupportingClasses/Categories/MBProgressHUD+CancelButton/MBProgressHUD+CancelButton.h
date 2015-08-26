//
//  MBProgressHUD+CancelButton.h
//  360cam
//
//  Created by Kirill Gorbushko on 06.07.15.
//  Copyright © 2015 Kirill Gorbushko. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (CancelButton)

- (void)addCancelButtonForTarger:(id)target andSelector:(NSString *)selector;

@end
