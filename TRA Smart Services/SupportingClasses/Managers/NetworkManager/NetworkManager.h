//
//  BaseNetworkManager.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AFNetworkReachabilityManager.h"

typedef void(^ResponseBlock)(id response, NSError *error);

typedef NS_ENUM(NSUInteger, BlockingWebsite) {
    BlockingWebsiteUndefined,
    BlockingWebsiteWebURL,
    BlockingWebsiteWioioebURLooooBadKayName
};

@interface NetworkManager : NSObject

@property (assign, nonatomic) AFNetworkReachabilityStatus networkStatus;

+ (instancetype)sharedManager;

#pragma mark - Reachability

- (void)startMonitoringNetwork;
- (void)stopMonitoringNetwork;

#pragma mark - NoCRMServicesRequests

- (void)noCRMServiceGetDomainAvaliability:(NSString *)domainURL requestResult:(ResponseBlock)response;
- (void)noCRMServiceGetOwnerDetailsForDomain:(NSString *)domainURL requestResult:(ResponseBlock)domainOwnerResponse;
- (void)noCRMServiceGetDeviceWithBrandName:(NSString *)brandName modelName:(NSString *)modelName requestResult:(ResponseBlock)deviceDetailsRequest;
- (void)noCRMServiceGetAllDeviceWithModelName:(NSString *)modelName requestResult:(ResponseBlock)deviceDetailsRequest;
- (void)noCRMServiceCheckIMEI:(NSString *)imei requestResult:(ResponseBlock)deviceEMEICheckResult;
- (void)noCRMServicePoorCoverageReportFromUserEmail:(NSString *)userEmail deviceName:(NSString *)device userName:(NSString *)userName operator:(NSString *)operatorName signalValue:(NSUInteger)signalValue atLatitude:(CGFloat)latitude longtitude:(CGFloat)longtitude requestResult:(ResponseBlock)deviceEMEICheckResult;
- (void)noCRMServiceBlockWebsite:(NSString *)website blockType:(BlockingWebsite)blockType requestResult:(ResponseBlock)blockWebsiteRequestResult;
- (void)noCRMServiceServiceRating:(NSString *)serviceName serviceDescription:(NSString *)description serviceRating:(NSUInteger)rating requestResult:(ResponseBlock)serviceRatingRequestResult;
- (void)noCRMServiceSpamReportForNetName:(NSString *)netName sender:(NSString *)spammer dateSMS:(NSString *)date requestResult:(ResponseBlock)serviceSMSSpamReport;
- (void)noCRMServicePerformSearchRequest:(NSString *)searchString requestResult:(ResponseBlock)serviceSeachRequestResult;

@end