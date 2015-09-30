//
//  UserModel.h
//  TRA Smart Services
//
//  Created by Admin on 9/30/15.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *streetName;
@property (strong, nonatomic) NSString *contactNumber;

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName streetName:(NSString *)streetName contactNumber:(NSString *)contactNumber;

@end
