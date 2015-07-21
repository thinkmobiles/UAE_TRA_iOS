//
//  LocationManager.m
//
//
//  Created by Kirill Gorbushko on 06.02.15.
//  Copyright (c) 2015 Kirill Gorbushko. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager() 

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationManager

#pragma mark - Public

+ (instancetype)sharedManager
{
    static LocationManager *sharedmanager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedmanager = [[LocationManager alloc] init];
    });
    return sharedmanager;
}

- (void)permissionRequest
{
    if ([[LocationManager sharedManager] isLocationServiceEnabled]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

- (BOOL)isLocationServiceEnabled
{
    return [CLLocationManager locationServicesEnabled];
}

- (void)stopUpdatingLocation
{
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)startUpdatingLocation
{
    if (self.locationManager) {
        _isLocationCaptured = NO;
        [self.locationManager startUpdatingLocation];
    }
}

- (void)fetchAddressWithLocation:(CLLocation *)location completionBlock:(FetchedAddress)completionBlock
{
    __block CLPlacemark* placemark;
    __block NSString *address = nil;
    
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error && placemarks.count) {
            placemark = [placemarks lastObject];
            address = [NSString stringWithFormat:@"%@, %@", placemark.name, placemark.country];
            completionBlock(address);
        }
    }];
}

+ (NSString *)GPSDataFromLocation:(CLLocationCoordinate2D)location latitudeRef:(NSString *)latitudeRef longtitudeRef:(NSString *)longtitudeRef
{
    int degrees = location.latitude;
    double decimal = fabs(location.latitude - degrees);
    int minutes = decimal * 60;
    NSString *latValue = [NSString stringWithFormat:@"%d°%@ %d'", degrees, latitudeRef, minutes];
    
    degrees = location.longitude;
    decimal = fabs(location.longitude - degrees);
    minutes = decimal * 60;
    NSString *longValue = [NSString stringWithFormat:@"%d°%@ %d'", degrees, longtitudeRef, minutes];
    
    NSString *GPS = [[latValue stringByAppendingString:@" "] stringByAppendingString:longValue];
    return GPS;
}

#pragma mark - Configuration

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepareLocationMamager];
    }
    return self;
}

- (void)prepareLocationMamager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLHeadingFilterNone;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    
    _currentLattitude = location.coordinate.latitude;
    _currentLongtitude = location.coordinate.longitude;
    _isLocationCaptured = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationDidChangedTo:lat:)]) {
        [self.delegate locationDidChangedTo:location.coordinate.longitude lat:location.coordinate.latitude];
    }
    [[LocationManager sharedManager] stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationDidFailWithError:)]) {
        [self.delegate locationDidFailWithError:error];
    }
}

@end
