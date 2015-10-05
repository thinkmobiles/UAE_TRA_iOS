//
//  TransactionModel.h
//  TRA Smart Services
//
//  Created by RomaVizenko on 05.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@interface TransactionModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *traSubmitDatetime;
@property (copy, nonatomic) NSString *modifiedDatetime;
@property (copy, nonatomic) NSString *stateCode;
@property (copy, nonatomic) NSString *statusCode;
@property (copy, nonatomic) NSString *traStatus;
@property (copy, nonatomic) NSString *serviceStage;
@property (copy, nonatomic) NSString *transationDescription;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
