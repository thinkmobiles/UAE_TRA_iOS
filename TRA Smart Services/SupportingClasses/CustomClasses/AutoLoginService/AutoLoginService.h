//
//  AutoLoginService.h
//  TRA Smart Services
//
//  Created by Admin on 22.07.15.
//

@interface AutoLoginService : NSObject

- (void)performAutoLoginIfPossible;
- (void)performAutoLoginWithPassword:(NSString *)userPassword;

@end
