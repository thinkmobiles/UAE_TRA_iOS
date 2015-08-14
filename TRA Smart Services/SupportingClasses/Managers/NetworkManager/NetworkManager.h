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
    ServiceTypeInternetSpeedTest = 9,
    ServiceTypeCompliantAboutServiceProvider = 10,
    ServiceTypeSuggestion = 11
};

typedef NS_ENUM(NSUInteger, ComplianType) {
    ComplianTypeCustomProvider,
    ComplianTypeEnquires,
    ComplianTypeTRAService,
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
- (void)traSSNoCRMServicePOSTPoorCoverageAtLatitude:(CGFloat)latitude longtitude:(CGFloat)longtitude signalPower:(NSUInteger)signalLevel requestResult:(ResponseBlock)poorCoverageResponse;

- (void)traSSNoCRMServicePOSTComplianAboutServiceProvider:(NSString *)serviceProvider title:(NSString *)compliantTitle description:(NSString *)compliantDescription refNumber:(NSUInteger)number attachment:(UIImage *)compliantAttachmnet complienType:(ComplianType)type requestResult:(ResponseBlock)compliantAboutServiceProviderResponse;
- (void)traSSNoCRMServicePOSTSendSuggestion:(NSString *)suggestionTitle description:(NSString *)suggestionDescription attachment:(UIImage *)suggestionAttachment requestResult:(ResponseBlock)suggestionResponse;

- (void)traSSRegisterUsername:(NSString *)username password:(NSString *)password gender:(NSString *)gender phoneNumber:(NSString *)number requestResult:(ResponseBlock)registerResponse;
- (void)traSSLoginUsername:(NSString *)username password:(NSString *)password requestResult:(ResponseBlock)loginResponse;

#pragma mark - Temp

- (void)setBaseURL:(NSString *)baseURL;

@end