//
//  UserModel.m
//  TRA Smart Services
//
//  Created by Admin on 9/30/15.
//

#import "UserModel.h"

@implementation UserModel

#pragma mark - LifeCycle

- (instancetype)init
{
    return [self initWithFirstName:@"" lastName:@"" streetName:@"" contactNumber:@"" imageUri:@"" imageBase64Data:@""];
}

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName streetName:(NSString *)streetName contactNumber:(NSString *)contactNumber imageUri:(NSString *)uri imageBase64Data:(NSString *)imageBase64Data
{
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
        _streetName = streetName;
        _contactNumber = contactNumber;
        _uriForImage = uri;
        _avatarImageBase64 = imageBase64Data;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    _firstName = [dictionary valueForKey:@"first"];
    _lastName = [dictionary valueForKey:@"last"];
    _email = [dictionary valueForKey:@"email"];
    _contactNumber = [dictionary valueForKey:@"mobile"];
    _uriForImage = [dictionary valueForKey:@"image"];
    
    return self;
}

#pragma mark - Coder

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_firstName forKey:@"firstName"];
    [encoder encodeObject:_lastName forKey:@"lastName"];
    [encoder encodeObject:_streetName forKey:@"streetName"];
    [encoder encodeObject:_contactNumber forKey:@"contactNumber"];
    [encoder encodeObject:_uriForImage forKey:@"uriForImage"];
    [encoder encodeObject:_avatarImageBase64 forKey:@"base64StringData"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        _firstName = [decoder decodeObjectForKey:@"firstName"];
        _lastName = [decoder decodeObjectForKey:@"lastName"];
        _streetName = [decoder decodeObjectForKey:@"streetName"];
        _contactNumber = [decoder decodeObjectForKey:@"contactNumber"];
        _uriForImage =[decoder decodeObjectForKey:@"uriForImage"];
        _avatarImageBase64 =[decoder decodeObjectForKey:@"base64StringData"];
    }
    return self;
}

@end
