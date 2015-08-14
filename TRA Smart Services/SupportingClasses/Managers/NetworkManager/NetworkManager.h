//
//  BaseNetworkManager.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AFNetworkReachabilityManager.h"

typedef NS_ENUM(NSUInteger, ServiceType) {
    ServiceTypeGetDomainData = 0,
    ServiceTypeGetDomainAvaliability = 1,
    ServiceTypeSearchMobileIMEI = 2,
    ServiceTypeSearchMobileBrand = 3,
    ServiceTypeFeedback = 4,
    ServiceTypeSMSSpamReport = 5,
    ServiceTypeHelpSalim = 6,
    ServiceTypeVerification = 7,
    ServiceTypeCoverage = 8,
    ServiceTypeInternetSpeedTest = 9
};

typedef void(^ResponseBlock)(id response, NSError *error);

@interface NetworkManager : NSObject <NSStreamDelegate>

@property (assign, nonatomic) AFNetworkReachabilityStatus networkStatus;

+ (instancetype)sharedManager;

#pragma mark - Reachability

- (void)startMonitoringNetwork;
- (void)stopMonitoringNetwork;

#pragma mark - NoCRMServices

- (void)traSSNoCRMServiceGetDomainData:(NSString *)domainURL requestResult:(ResponseBlock)domainOwnerResponse;
- (void)traSSNoCRMServiceGetDomainAvaliability:(NSString *)domainURL requestResult:(ResponseBlock)domainAvaliabilityResponse;
- (void)traSSNoCRMServicePerformSearchByIMEI:(NSString *)mobileIMEI requestResult:(ResponseBlock)mobileIMEISearchResponse;
- (void)traSSNoCRMServicePerformSearchByMobileBrand:(NSString *)mobileBrand requestResult:(ResponseBlock)mobileBrandSearchResponse;
- (void)traSSNoCRMServicePOSTFeedback:(NSString *)feedback forSerivce:(NSString *)serviceName withRating:(NSUInteger)rating requestResult:(ResponseBlock)mobileBrandSearchResponse;
- (void)traSSNoCRMServicePOSTSMSSpamReport:(NSString *)spammerPhoneNumber phoneProvider:(NSString *)provider providerType:(NSString *)providerType notes:(NSString *)note requestResult:(ResponseBlock)SMSSpamReportResponse;
- (void)traSSNoCRMServicePOSTHelpSalim:(NSString *)urlAddress notes:(NSString *)comment requestResult:(ResponseBlock)helpSalimReportResponse;

- (void)traSSNoCRMServicePOSCompliantAboutServiceProvider:(NSString *)serviceProvider title:(NSString *)compliantTitle description:(NSString *)compliantDescription refNumber:(NSUInteger)number attachment:(UIImage *)compliantAttachmnet requestResult:(ResponseBlock)compliantAboutServiceProviderResponse;

#pragma mark - Temp

- (void)setBaseURL:(NSString *)baseURL;

@end