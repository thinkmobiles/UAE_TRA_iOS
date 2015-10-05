//
//  TransactionModel.h
//  TRA Smart Services
//
//  Created by RomaVizenko on 05.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@interface TransactionModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *traSubmitDatetime;
@property (strong, nonatomic) NSString *modifiedDatetime;
@property (strong, nonatomic) NSString *stateCode;
@property (strong, nonatomic) NSString *statusCode;
@property (strong, nonatomic) NSString *traStatus;
@property (strong, nonatomic) NSString *serviceStage;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
