//
//  UserModel.m
//  TRA Smart Services
//
//  Created by Admin on 9/30/15.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)init
{
    return [self initWithFirstName:@"" lastName:@"" streetName:@"" contactNumber:@""];
}

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName streetName:(NSString *)streetName contactNumber:(NSString *)contactNumber
{
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
        _streetName = streetName;
        _contactNumber = contactNumber;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_firstName forKey:@"firstName"];
    [encoder encodeObject:_lastName forKey:@"lastName"];
    [encoder encodeObject:_streetName forKey:@"streetName"];
    [encoder encodeObject:_contactNumber forKey:@"contactNumber"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _firstName = [decoder decodeObjectForKey:@"firstName"];
        _lastName = [decoder decodeObjectForKey:@"lastName"];
        _streetName = [decoder decodeObjectForKey:@"streetName"];
        _contactNumber = [decoder decodeObjectForKey:@"contactNumber"];
    }
    return self;
}

@end
