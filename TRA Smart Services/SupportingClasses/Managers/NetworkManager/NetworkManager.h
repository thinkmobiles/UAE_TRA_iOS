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

typedef NS_ENUM(NSUInteger, SocketRequestType) {
    SocketRequestTypeUndefined,
    SocketRequestTypeDomainData,
    SocketRequestTypeDomainAvaliability
};

@protocol NetworkManagerDelegate <NSObject>

@required
- (void)networkManagerDidReceiveResponseType:(SocketRequestType)responseType response:(id)response error:(NSError *)responseError;

@end

@interface NetworkManager : NSObject <NSStreamDelegate>

@property (assign, nonatomic) AFNetworkReachabilityStatus networkStatus;
@property (weak, nonatomic) id <NetworkManagerDelegate> delegate;

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

@end