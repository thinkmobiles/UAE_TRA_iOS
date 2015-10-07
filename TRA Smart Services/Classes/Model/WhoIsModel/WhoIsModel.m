//
//  WhoIsModel.m
//  TRA Smart Services
//
//  Created by Admin on 23.09.15.
//

static NSString *const Keykey = @"key";
static NSString *const keyValue = @"value";
static NSString *const keyOrder = @"order";

#import "WhoIsModel.h"

@implementation WhoIsModel

#pragma mark - Public

+ (WhoIsModel *)whoIsWithString:(NSString *)inputString
{
    WhoIsModel *model = [[WhoIsModel alloc] init];
    model.response = [WhoIsModel parseData:inputString];
    
    return model;
}

#pragma mark - Private

+ (NSArray *)parseData:(NSString *)inputData
{
    NSArray *values = [inputData componentsSeparatedByString:@"\r\n"];
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *key;
    NSInteger i = 0;
    for (NSString *string in values) {
        
        if (string.length) {
            
            NSArray *keyValueData = [string componentsSeparatedByString:@":"];
            NSString *value = [(NSString *)[keyValueData lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            key = [(NSString *)[keyValueData firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([key isEqualToString:@"No Data Found"]) {
                key = @"Result";
            }
            NSMutableDictionary *innerDictionary = [[NSMutableDictionary alloc] init];
            [innerDictionary setValue:@(i) forKey:keyOrder];
            [innerDictionary setValue:key forKey:Keykey];
            i++;
            
            if ([dataDictionary valueForKey:key]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                id innerObj = [[dataDictionary valueForKey:key] valueForKey:keyValue];
                if ([innerObj isKindOfClass:[NSArray class]]) {
                    for (id obj in (NSArray *)innerObj) {
                        [array addObject:obj];
                    }
                } else {
                    [array addObject:innerObj];
                }
                [array addObject:value];
                [innerDictionary setObject:array forKey:keyValue];
                [dataDictionary setObject:innerDictionary forKey:key];
                continue;
            }
            
            [innerDictionary setObject:value forKey:keyValue];
            [dataDictionary setObject:innerDictionary forKey:key];
        }
    }
    
    NSArray *data = [dataDictionary allValues];
    data = [data sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [[obj1 valueForKey:keyOrder] integerValue] > [[obj2 valueForKey:keyOrder] integerValue];
    }];
    
    return data;
}

@end
