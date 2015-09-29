//
//  CoreDataManager.h
//  TRA Smart Services
//
//  Created by Admin on 19.09.15.
//

#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedManager;

- (void)saveContext;

- (NSArray *)fetchServiceList;
- (NSArray *)fetchFavouriteServiceList;

@end
