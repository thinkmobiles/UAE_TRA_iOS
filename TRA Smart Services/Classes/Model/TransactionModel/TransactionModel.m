//
//  TransactionModel.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 05.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "TransactionModel.h"
#import "NSDictionary+Safe.h"

@implementation TransactionModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    dictionary = [dictionary removeNullValues];
    
    _title = [dictionary valueForKey:@"title"];
    _type = [dictionary valueForKey:@"type"];
    _traSubmitDatetime = [dictionary valueForKey:@"traSubmitDatetime"];
    _modifiedDatetime = [dictionary valueForKey:@"modifiedDatetime"];
    _stateCode = [dictionary valueForKey:@"stateCode"];
    _statusCode = [dictionary valueForKey:@"statusCode"];
    _traStatus = [dictionary valueForKey:@"traStatus"];
    _serviceStage = [dictionary valueForKey:@"serviceStage"];
    
    return self;
}

@end
