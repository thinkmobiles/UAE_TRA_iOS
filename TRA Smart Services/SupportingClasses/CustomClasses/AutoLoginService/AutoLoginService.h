//
//  AutoLoginService.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 22.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@interface AutoLoginService : NSObject

- (void)performAutoLoginIfPossible;
- (void)performAutoLoginWithPassword:(NSString *)userPassword;

@end
