//
//  UserModel.h
//  TRA Smart Services
//
//  Created by Admin on 9/30/15.
//

@interface UserModel : NSObject

@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *streetName;
@property (copy, nonatomic) NSString *contactNumber;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *uriForImage;
@property (copy, nonatomic) NSString *avatarImageBase64;

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName streetName:(NSString *)streetName contactNumber:(NSString *)contactNumber imageUri:(NSString *)uri imageBase64Data:(NSString *)imageBase64Data;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
