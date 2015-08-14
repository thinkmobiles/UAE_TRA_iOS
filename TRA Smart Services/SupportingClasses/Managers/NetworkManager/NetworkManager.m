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

static NSString *const ImagePrefixBase64String = @"data:image/png;base64,";

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

- (void)traSSNoCRMServicePOSTComplianAboutServiceProvider:(NSString *)serviceProvider title:(NSString *)compliantTitle description:(NSString *)compliantDescription refNumber:(NSUInteger)number attachment:(UIImage *)compliantAttachmnet complienType:(ComplianType)type requestResult:(ResponseBlock)compliantAboutServiceProviderResponse
{
    NSMutableDictionary *parameters = [ @{
                                          @"title" : compliantTitle,
                                          @"description" : compliantDescription
                                          } mutableCopy];
    
    if (type == ComplianTypeCustomProvider) {
        [parameters setValue:serviceProvider forKey:@"serviceProvider"];
        [parameters setValue:@(number) forKey:@"referenceNumber"];
    }
    
    if (compliantAttachmnet) {
        NSData *imageData = UIImagePNGRepresentation(compliantAttachmnet);
        NSString *base64PhotoString = [imageData base64EncodedStringWithOptions:kNilOptions];
        base64PhotoString = [ImagePrefixBase64String stringByAppendingString:base64PhotoString];
        if (imageData) {
            [parameters setValue:base64PhotoString forKey:@"attachment"];
        }
    }
    
    NSString *path;
    switch (type) {
        case ComplianTypeCustomProvider:{
            path = traSSNOCRMServicePOSTCompliantServiceProvider;
            break;
        }
        case ComplianTypeEnquires: {
            path = traSSNOCRMServicePOSTCompliantAboutEnquires;
            break;
        }
        case ComplianTypeTRAService: {
            path = traSSNOCRMServicePOSTCompliantAboutTRAService;
            break;
        }
    }
    
    [self.manager POST:path parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        compliantAboutServiceProviderResponse([responseDictionary valueForKey:@"status"], nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        compliantAboutServiceProviderResponse(nil, error);
    }];
}

- (void)traSSNoCRMServicePOSTSendSuggestion:(NSString *)suggestionTitle description:(NSString *)suggestionDescription attachment:(UIImage *)suggestionAttachment requestResult:(ResponseBlock)suggestionResponse
{
    NSMutableDictionary *parameters = [ @{
                                          @"title" : suggestionTitle,
                                          @"description" : suggestionDescription
                                          } mutableCopy];
    
    if (suggestionAttachment) {
        NSData *imageData = UIImagePNGRepresentation(suggestionAttachment);
        NSString *base64PhotoString = [imageData base64EncodedStringWithOptions:kNilOptions];
        base64PhotoString = [ImagePrefixBase64String stringByAppendingString:base64PhotoString];
        if (imageData) {
            [parameters setValue:base64PhotoString forKey:@"attachment"];
        }
    }
    
    [self.manager POST:traSSNOCRMServicePOSTSendSuggestin parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        suggestionResponse([responseDictionary valueForKey:@"status"], nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        suggestionResponse(nil, error);
    }];
}

- (void)traSSNoCRMServicePOSTPoorCoverageAtLatitude:(CGFloat)latitude longtitude:(CGFloat)longtitude address:(NSString *)address signalPower:(NSUInteger)signalLevel requestResult:(ResponseBlock)poorCoverageResponse
{
    NSMutableDictionary *parameters = [ @{
                                          @"signalLevel" : @(signalLevel)
                                          } mutableCopy];
    
    if (latitude && longtitude) {
        [parameters setValue: @{
                                @"latitude" : @(latitude),
                                @"longtitude" : @(longtitude)
                                }
                      forKey:@"location"];
    }
    
    if (address.length) {
        [parameters setValue:address forKey:@"address"];
    }
    
    [self.manager POST:traSSNOCRMServicePOSTPoorCoverage parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        poorCoverageResponse([responseDictionary valueForKey:@"status"], nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        poorCoverageResponse(nil, error);
    }];
}

#pragma mark - UserInteraction

- (void)traSSRegisterUsername:(NSString *)username password:(NSString *)password gender:(NSString *)gender phoneNumber:(NSString *)number requestResult:(ResponseBlock)registerResponse
{
    NSDictionary *parameters = @{
                                 @"login" : username,
                                 @"pass" : password,
                                 @"gender" : gender,
                                 @"phone" : number
                                 };
    
    [self.manager POST:traSSRegister parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        registerResponse([responseDictionary valueForKey:@"succeess"], nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        NSString *responseString;
        if (operation.responseObject) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:kNilOptions error:&error];
            responseString = [response valueForKey:@"error"];
        }

        registerResponse(responseString, error);
    }];
}

- (void)traSSLoginUsername:(NSString *)username password:(NSString *)password requestResult:(ResponseBlock)loginResponse
{
    NSDictionary *parameters = @{
                                 @"login" : username,
                                 @"pass" : password
                                 };
    
    [self.manager POST:traSSRegister parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        loginResponse([responseDictionary valueForKey:@"status"], nil);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        loginResponse(nil, error);
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