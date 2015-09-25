//
//  LocationManager.h
//
//
//  Created by Kirill Gorbushko on 06.02.15.
//  Copyright (c) 2015 Kirill Gorbushko. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void(^AccessResult)(BOOL result);
typedef void(^FetchedAddress)(NSString *);

@protocol LocationManagerDelegate <NSObject>

@optional
- (void)locationDidChangedTo:(CGFloat)longtitude lat:(CGFloat)latitude;
- (void)locationDidFailWithError:(NSError *)failError;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (weak, nonatomic) id <LocationManagerDelegate> delegate;

@property (assign, nonatomic, readonly) CGFloat currentLongtitude;
@property (assign, nonatomic, readonly) CGFloat currentLattitude;
@property (assign, nonatomic, readonly) BOOL isLocationCaptured;

+ (instancetype)sharedManager;

- (BOOL)isLocationServiceEnabled;
- (void)permissionRequest;

- (void)stopUpdatingLocation;
- (void)startUpdatingLocation;

- (void)fetchAddressWithLocation:(CLLocation *)location completionBlock:(FetchedAddress)completionBlock;

- (void)checkLocationPermissions:(AccessResult)result;

@end
