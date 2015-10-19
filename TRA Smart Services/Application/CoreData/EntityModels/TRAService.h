//
//  TRAService.h
//  TRA Smart Services
//
//  Created by Admin on 26.08.15.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TRAService : NSManagedObject

@property (nonatomic, retain) NSString * serviceDescription;
@property (nonatomic, retain) NSData * serviceIcon;
@property (nonatomic, retain) NSString * serviceName;
@property (nonatomic, retain) NSNumber * serviceOrder;
@property (nonatomic, retain) NSNumber * serviceInternalID;
@property (nonatomic, retain) NSNumber * serviceIsFavorite;

@end
