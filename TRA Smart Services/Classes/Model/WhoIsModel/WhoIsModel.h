//
//  WhoIsModel.h
//  TRA Smart Services
//
//  Created by Admin on 23.09.15.
//

@class WhoIsModel;

@interface WhoIsModel : NSObject

@property (strong, nonatomic) NSArray *response;

+ (WhoIsModel *)whoIsWithString:(NSString *)inputString;

@end