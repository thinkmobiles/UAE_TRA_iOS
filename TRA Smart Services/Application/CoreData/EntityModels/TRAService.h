//
//  TRAService.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 17.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TRAService : NSManagedObject

@property (nonatomic, retain) NSString * serviceName;
@property (nonatomic, retain) NSString * serviceDescription;
@property (nonatomic, retain) NSData * serviceIcon;
@property (nonatomic, retain) NSNumber * serviceOrder;

@end
