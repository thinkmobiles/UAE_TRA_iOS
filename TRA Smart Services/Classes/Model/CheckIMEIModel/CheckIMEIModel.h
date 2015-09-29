//
//  CheckIMEIModel.h
//  TRA Smart Services
//
//  Created by Admin on 9/28/15.
//

#import <Foundation/Foundation.h>

@interface CheckIMEIModel : NSObject

@property (readonly, nonatomic) NSString *allocationDate;
@property (readonly, nonatomic) NSString *bands;
@property (readonly, assign, nonatomic) NSInteger count;
@property (readonly, assign, nonatomic) NSInteger countryCode;
@property (readonly, nonatomic) NSString *designationType;
@property (readonly, assign, nonatomic) NSInteger endIndex;
@property (readonly, nonatomic) NSString *fixedCode;
@property (readonly, nonatomic) NSString *manufacturer;
@property (readonly, nonatomic) NSString *manufacturerCode;
@property (readonly, nonatomic) NSString *marketingName;
@property (readonly, nonatomic) NSString *radioInterface;
@property (readonly, assign, nonatomic) NSInteger startIndex;
@property (readonly, nonatomic) NSString *tac;
@property (readonly, assign, nonatomic) NSInteger totalNumberofRecords;

- (instancetype)initFromDictionary:(NSDictionary *)dictionary;

@end
