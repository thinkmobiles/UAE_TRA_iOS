//
//  LocationManager.m
//
//
//  Created by Admin on 06.02.15.
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
#ifndef DEBUG
    SEC_IS_BEING_DEBUGGED_RETURN_NIL();
#endif
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
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)checkLocationPermissions:(AccessResult)result
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
        result(NO);
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager startUpdatingLocation];
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        result(YES);
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
    [self.locationManager requestWhenInUseAuthorization];
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
