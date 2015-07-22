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
@property (copy, nonatomic) NSString *noCRMAccessToken;

@end

@implementation NetworkManager

#pragma mark - Public

+ (instancetype)sharedManager
{
    static NetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:NoCRMServiceNetworkManagerBaseURL]];
    });
    return sharedManager;
}

#pragma mark - Public

#pragma mark - NoCRMServicesRequests

- (void)noCRMServiceGetDomainAvaliability:(NSString *)domainURL requestResult:(ResponseBlock)domainAvaliabilityResponse
{
    void (^PerformRequest)() = ^(){
        NSString *requestURL = [NSString stringWithFormat:@"%@%@", NoCRMDomainAvaliability, self.noCRMAccessToken];
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *parameters = @{
                                     @"WebURL" : domainURL,
                                     @"ReqType" : @"avaliability"
                                     };
        [self.manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            domainAvaliabilityResponse(responseDictionary, nil);
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            domainAvaliabilityResponse(nil, error);
        }];
    };
    
    if (!self.noCRMAccessToken.length) {
        [[NetworkManager sharedManager] performNoCRMAuthorization:^(BOOL success) {
            if (success) {
                PerformRequest();
            }
        }];
    } else {
        PerformRequest();
    }
}

- (void)noCRMServiceGetOwnerDetailsForDomain:(NSString *)domainURL requestResult:(ResponseBlock)domainOwnerResponse
{
    void (^PerformRequest)() = ^(){
        NSString *requestURL = [NSString stringWithFormat:@"%@%@", NoCRMDomainAvaliability, self.noCRMAccessToken];
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *parameters = @{
                                     @"WebURL" : domainURL,
                                     @"ReqType" : @"whois"
                                     };
        [self.manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            domainOwnerResponse(responseDictionary, nil);
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            domainOwnerResponse(nil, error);
        }];
    };
    
    if (!self.noCRMAccessToken.length) {
        [[NetworkManager sharedManager] performNoCRMAuthorization:^(BOOL success) {
            if (success) {
                PerformRequest();
            }
        }];
    } else {
        PerformRequest();
    }
}

- (void)noCRMServiceGetDeviceWithBrandName:(NSString *)brandName modelName:(NSString *)modelName requestResult:(ResponseBlock)deviceDetailsRequest
{
    void (^PerformRequest)() = ^(){
        NSString *requestURL = [NSString stringWithFormat:@"%@/%@/%@?access_token=%@", NoCRMGetDeviceBrandModel, brandName, modelName, self.noCRMAccessToken];
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [self.manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            deviceDetailsRequest(responseDictionary, nil);
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            deviceDetailsRequest(nil, error);
        }];
    };
    
    if (!self.noCRMAccessToken.length) {
        [[NetworkManager sharedManager] performNoCRMAuthorization:^(BOOL success) {
            if (success) {
                PerformRequest();
            }
        }];
    } else {
        PerformRequest();
    }
}

- (void)noCRMServiceGetAllDeviceWithModelName:(NSString *)modelName requestResult:(ResponseBlock)allDeviceDetailsRequest
{
    void (^PerformRequest)() = ^(){
        NSString *requestURL = [NSString stringWithFormat:@"%@/%@?access_token=%@", NoCRMgetDeviceModelAll, modelName, self.noCRMAccessToken];
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            allDeviceDetailsRequest(responseDictionary, nil);
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            allDeviceDetailsRequest(nil, error);
        }];
    };
    
    if (!self.noCRMAccessToken.length) {
        [[NetworkManager sharedManager] performNoCRMAuthorization:^(BOOL success) {
            if (success) {
                PerformRequest();
            }
        }];
    } else {
        PerformRequest();
    }
}

- (void)noCRMServiceCheckIMEI:(NSString *)imei requestResult:(ResponseBlock)deviceEMEICheckResult
{
    void (^PerformRequest)() = ^(){
        NSDictionary *parameters = @{
                                     @"IMEI" : imei
                                   };
        
        [self.manager POST:NoCRMDeviceIMEICheck parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            deviceEMEICheckResult(responseDictionary, nil);
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            deviceEMEICheckResult(nil, error);
        }];
    };
    
    if (!self.noCRMAccessToken.length) {
        [[NetworkManager sharedManager] performNoCRMAuthorization:^(BOOL success) {
            if (success) {
                PerformRequest();
            }
        }];
    } else {
        PerformRequest();
    }
}

- (void)noCRMServicePoorCoverageReportFromUserEmail:(NSString *)userEmail deviceName:(NSString *)device userName:(NSString *)userName operator:(NSString *)operatorName signalValue:(NSUInteger)signalValue atLatitude:(CGFloat)latitude longtitude:(CGFloat)longtitude requestResult:(ResponseBlock)deviceEMEICheckResult
{
    void (^PerformRequest)() = ^(){
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        if (latitude && longtitude) {
            [parameters setValue:@(latitude) forKey:@"LocLAT"];
            [parameters setValue:@(longtitude) forKey:@"LocLON"];
        }
        if (userEmail.length && signalValue && device.length && operatorName.length && userName.length) {
            [parameters setValue:userEmail forKey:@"Email"];
            [parameters setValue:device forKey:@"Mobile"];
            [parameters setValue:userName forKey:@"Name"];
            [parameters setValue:operatorName forKey:@"MobOp"];
            [parameters setValue:@(signalValue) forKey:@"SignalAtPos"];
        } 
        
        NSString *requestURL = [NSString stringWithFormat:@"%@%@", NoCRMPoorCoverageReport, self.noCRMAccessToken];
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.manager POST:NoCRMDeviceIMEICheck parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            deviceEMEICheckResult(responseDictionary, nil);
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            deviceEMEICheckResult(nil, error);
        }];
    };
    
    if (!self.noCRMAccessToken.length) {
        [[NetworkManager sharedManager] performNoCRMAuthorization:^(BOOL success) {
            if (success) {
                PerformRequest();
            }
        }];
    } else {
        PerformRequest();
    }
}

- (void)noCRMServiceBlockWebsite:(NSString *)website blockType:(BlockingWebsite)blockType requestResult:(ResponseBlock)blockWebsiteRequestResult
{
    void (^PerformRequest)() = ^(){
        
        NSDictionary *parameters;
        if (blockType == BlockingWebsiteWebURL) {
            parameters = @{
                           @"WebURL" : website
                           };
        } else if (blockType == BlockingWebsiteWioioebURLooooBadKayName) {
            parameters = @{
                           @"WioioebURLooooBadKayName" : website
                           };
        }
        
        NSString *requestURL = [NSString stringWithFormat:@"%@%@", NoCRMHelpSalimBlockWebsiteService, self.noCRMAccessToken];
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        [self.manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            blockWebsiteRequestResult(responseDictionary, nil);
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            blockWebsiteRequestResult(nil, error);
        }];
    };
    
    if (!self.noCRMAccessToken.length) {
        [[NetworkManager sharedManager] performNoCRMAuthorization:^(BOOL success) {
            if (success) {
                PerformRequest();
            }
        }];
    } else {
        PerformRequest();
    }
}

- (void)noCRMServiceServiceRating:(NSString *)serviceName serviceDescription:(NSString *)description serviceRating:(NSUInteger)rating requestResult:(ResponseBlock)serviceRatingRequestResult
{
    void (^PerformRequest)() = ^(){
        
        NSDictionary *parameters = @{
                                     @"serviceType" : serviceName,
                                     @"description" : description,
                                     @"rating" : @(rating)
                                     };
        
        NSString *requestURL = [NSString stringWithFormat:@"%@%@", NoCRMServiceRating, self.noCRMAccessToken];
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            serviceRatingRequestResult(responseDictionary, nil);
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            serviceRatingRequestResult(nil, error);
        }];
    };
    
    if (!self.noCRMAccessToken.length) {
        [[NetworkManager sharedManager] performNoCRMAuthorization:^(BOOL success) {
            if (success) {
                PerformRequest();
            }
        }];
    } else {
        PerformRequest();
    }
}

- (void)noCRMServiceSpamReportForNetName:(NSString *)netName sender:(NSString *)spammer dateSMS:(NSString *)date requestResult:(ResponseBlock)serviceSMSSpamReport
{
    void (^PerformRequest)() = ^(){
        
        NSDictionary *parameters = @{
                                     @"NetName" : netName,
                                     @"Sender" : spammer,
                                     @"DateSms" : date
                                     };
        
        NSString *requestURL = [NSString stringWithFormat:@"%@%@", NoCRMSMSSpam, self.noCRMAccessToken];
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            serviceSMSSpamReport(responseDictionary, nil);
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            serviceSMSSpamReport(nil, error);
        }];
    };
    
    if (!self.noCRMAccessToken.length) {
        [[NetworkManager sharedManager] performNoCRMAuthorization:^(BOOL success) {
            if (success) {
                PerformRequest();
            }
        }];
    } else {
        PerformRequest();
    }
}

- (void)noCRMServicePerformSearchRequest:(NSString *)searchString requestResult:(ResponseBlock)serviceSeachRequestResult
{
    void (^PerformRequest)() = ^(){
        
        NSString *requestURL = [NSString stringWithFormat:@"%@/%@?access_token=%@", NoCRMSearchRequest, searchString, self.noCRMAccessToken];
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            serviceSeachRequestResult(responseDictionary, nil);
        } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
            serviceSeachRequestResult(nil, error);
        }];
    };
    
    if (!self.noCRMAccessToken.length) {
        [[NetworkManager sharedManager] performNoCRMAuthorization:^(BOOL success) {
            if (success) {
                PerformRequest();
            }
        }];
    } else {
        PerformRequest();
    }
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

- (void)performNoCRMAuthorization:(void(^)(BOOL success))completed
{
    [self.manager POST:NoCRMGetAccesToken parameters:@{@"imei" : @"anonymous"} success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        self.noCRMAccessToken = [response valueForKey:@"access_token"];
        completed(self.noCRMAccessToken.length);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        completed(self.noCRMAccessToken.length);
    }];
}

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

@end