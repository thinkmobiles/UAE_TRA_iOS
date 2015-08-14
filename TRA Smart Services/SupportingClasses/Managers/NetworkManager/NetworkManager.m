//
//  BaseNetworkManager.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"
#import "NetworkEndPoints.h"
#import <CoreTelephony/CoreTelephonyDefines.h>

@interface NetworkManager()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation NetworkManager

#pragma mark - Public

+ (instancetype)sharedManager
{
    static NetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:traSSNoCRMServiceBaseURL]];
    });
    return sharedManager;
}

#pragma mark - Public

#pragma mark - NoCRMServices

- (void)traSSNoCRMServiceGetDomainData:(NSString *)domainURL requestResult:(ResponseBlock)domainOwnerResponse
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", traSSNOCRMServiceGETDomainData, domainURL];
    [self.manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        domainOwnerResponse([responseDictionary valueForKey:@"urlData"], nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        domainOwnerResponse(nil, error);
    }];
}

- (void)traSSNoCRMServiceGetDomainAvaliability:(NSString *)domainURL requestResult:(ResponseBlock)domainAvaliabilityResponse
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", traSSNOCRMServiceGETDomainAvaliability, domainURL];
    [self.manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        domainAvaliabilityResponse([responseDictionary valueForKey:@"availableStatus"], nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        domainAvaliabilityResponse(nil, error);
    }];
}

- (void)traSSNoCRMServicePerformSearchByIMEI:(NSString *)mobileIMEI requestResult:(ResponseBlock)mobileIMEISearchResponse
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", traSSNOCRMServiceGETSearchMobileIMEI, mobileIMEI];
    [self.manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        mobileIMEISearchResponse(responseDictionary, nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        mobileIMEISearchResponse(nil, error);
    }];
}

- (void)traSSNoCRMServicePerformSearchByMobileBrand:(NSString *)mobileBrand requestResult:(ResponseBlock)mobileBrandSearchResponse
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", traSSNOCRMServiceGETSearchMobileBrand, mobileBrand];
    [self.manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        mobileBrandSearchResponse(responseDictionary, nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        mobileBrandSearchResponse(nil, error);
    }];
}

- (void)traSSNoCRMServicePOSTFeedback:(NSString *)feedback forSerivce:(NSString *)serviceName withRating:(NSUInteger)rating requestResult:(ResponseBlock)serviceFeedbackResponse
{
    NSDictionary *parameters = @{
                                 @"serviceName": serviceName,
                                 @"rate": @(rating),
                                 @"feedback": feedback.length ? feedback : @""
                                 };
    
    [self.manager POST:traSSNOCRMServicePOSTFeedBack parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        serviceFeedbackResponse(responseDictionary, nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        serviceFeedbackResponse(nil, error);
    }];
}

- (void)traSSNoCRMServicePOSTSMSSpamReport:(NSString *)spammerPhoneNumber phoneProvider:(NSString *)provider providerType:(NSString *)providerType notes:(NSString *)note requestResult:(ResponseBlock)SMSSpamReportResponse
{
    NSDictionary *parameters = @{
                                 @"phone": spammerPhoneNumber,
                                 @"phoneProvider": provider,
                                 @"providerType": providerType,
                                 @"description": note
                                 };
    
    [self.manager POST:traSSNOCRMServicePOSTSMSSPamReport parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        SMSSpamReportResponse([responseDictionary valueForKey:@"status"], nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        SMSSpamReportResponse(nil, error);
    }];
}

- (void)traSSNoCRMServicePOSTHelpSalim:(NSString *)urlAddress notes:(NSString *)comment requestResult:(ResponseBlock)helpSalimReportResponse
{
    NSDictionary *parameters = @{
                                 @"url" : urlAddress,
                                 @"description" : comment
                                 };
    
    [self.manager POST:traSSNOCRMServicePOSTHelpSalim parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        helpSalimReportResponse([responseDictionary valueForKey:@"status"], nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        helpSalimReportResponse(nil, error);
    }];
}

#pragma mark - LifeCycle

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        [self prepareNetworkManagerWithURL:baseURL];
    }
    return self;
}

#pragma mark - Reachability

- (void)startMonitoringNetwork
{
    __weak typeof(self) weakSelf = self;
    [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.networkStatus = status;
    }];
    [self.manager.reachabilityManager startMonitoring];
}

- (void)stopMonitoringNetwork
{
    [self.manager.reachabilityManager stopMonitoring];
}

#pragma mark - Private

#pragma mark - Preparation

- (void)prepareNetworkManagerWithURL:(NSURL *)baseURL
{
    self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    self.manager.securityPolicy = securityPolicy;
}

#pragma mark - Temp

- (void)setBaseURL:(NSString *)baseURL
{
    [self prepareNetworkManagerWithURL:[NSURL URLWithString:baseURL]];
}

@end