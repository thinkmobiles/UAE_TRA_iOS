//
//  CoreDataManager.m
//  TRA Smart Services
//
//  Created by Admin on 19.09.15.
//

#import "CoreDataManager.h"
#import "TRAService.h"

static NSString *const FetchRequestAllService = @"AllService";
static NSString *const FetchRequestFavouriteService = @"FavouriteService";

static NSString *const CoreDataEntityNameTRAService = @"TRAService";

@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Public

+ (instancetype)sharedManager
{
#ifndef DEBUG
    SEC_IS_BEING_DEBUGGED_RETURN_NIL();
#endif
    static CoreDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CoreDataManager alloc] init];
        [sharedManager saveFavoriteListToDB];
    });
    return sharedManager;
}

#pragma mark - Public

- (NSArray *)fetchServiceList
{
    NSFetchRequest *fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:FetchRequestAllService];
    NSError *error;
    NSArray *result = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
#if DEBUG
    if (error) {
        DLog(@"Cant fetch data from DB: %@\n%@",error.localizedDescription, error.userInfo);
    }
#endif
    return result;
}

- (NSArray *)fetchFavouriteServiceList
{
    NSFetchRequest *fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:FetchRequestFavouriteService];
    NSError *error;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
#if DEBUG
    if (error) {
        DLog(@"Cant fetch data from DB: %@\n%@",error.localizedDescription, error.userInfo);
    }
#endif
    return result;
}

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

#pragma mark - Private

- (void)saveFavoriteListToDB
{
    NSArray *data = [self fetchServiceList];
    
    if (!data.count) {
        NSArray *speedAccessServices = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SpeedAccessServices" ofType:@"plist"]];
        NSMutableArray *otherServices = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OtherServices" ofType:@"plist"]];
        
        [otherServices addObjectsFromArray:speedAccessServices];
        
        for (NSDictionary *dic in otherServices) {
            if (![[dic valueForKey:@"serviceName"] isEqualToString:@"speedAccess.service.name.-1"]) { //temp while not all data avaliable
                NSEntityDescription *traServiceEntity = [NSEntityDescription entityForName:CoreDataEntityNameTRAService inManagedObjectContext:self.managedObjectContext];
                TRAService *service = [[TRAService alloc] initWithEntity:traServiceEntity insertIntoManagedObjectContext:self.managedObjectContext];
                
                service.serviceIsFavorite = @(NO);
                service.serviceName = [dic valueForKey:@"serviceName"];
                if ([dic valueForKey:@"serviceDisplayLogo"]) {
                    service.serviceIcon = UIImageJPEGRepresentation([UIImage imageNamed:[dic valueForKey:@"serviceDisplayLogo"]], 1.0);
                }
                service.serviceDescription = @"No decription provided";
                service.serviceInternalID = @([[dic valueForKey:@"serviceID"] integerValue]);
            }
        }
    }
    
    [self.managedObjectContext save:nil];
}

#pragma mark - CoreDataStack

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TRAService" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TRAService.sqlite"];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

@end