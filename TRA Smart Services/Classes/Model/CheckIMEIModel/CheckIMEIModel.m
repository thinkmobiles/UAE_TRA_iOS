//
//  CheckIMEIModel.m
//  TRA Smart Services
//
//  Created by Admin on 9/28/15.
//

#import "CheckIMEIModel.h"

@implementation CheckIMEIModel

- (instancetype)initFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _allocationDate = [dictionary valueForKey:@"allocationDate"];
        _bands = [dictionary valueForKey:@"bands"];
        _count = [[dictionary valueForKey:@"count"] integerValue];
        _countryCode = [[dictionary valueForKey:@"countryCode"] integerValue];
        _designationType = [dictionary valueForKey:@"designationType"];
        _endIndex = [[dictionary valueForKey:@"endIndex"] integerValue];
        _fixedCode = [dictionary valueForKey:@"fixedCode"];
        _manufacturer = [dictionary valueForKey:@"manufacturer"];
        _manufacturerCode = [dictionary valueForKey:@"manufacturerCode"];
        _marketingName = [dictionary valueForKey:@"marketingName"];
        _radioInterface = [dictionary valueForKey:@"radioInterface"];
        _startIndex = [[dictionary valueForKey:@"startIndex"] integerValue];
        _tac = [dictionary valueForKey:@"tac"];
        _totalNumberofRecords = [[dictionary valueForKey:@"totalNumberofRecords"] integerValue];
    }
    return self;
}

- (NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"%@  %@", _marketingName, _allocationDate];
    return str;
}

@end
