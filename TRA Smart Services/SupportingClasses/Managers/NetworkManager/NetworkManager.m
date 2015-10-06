//
//  BaseNetworkManager.m
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//

#import "NetworkManager.h"
#import "AFNetworking.h"
#import "NetworkEndPoints.h"
#import <CoreTelephony/CoreTelephonyDefines.h>
#import "TransactionModel.h"

static NSString *const ImagePrefixBase64String = @"data:image/png;base64,";
static NSString *const ResponseDictionaryErrorKey = @"error";
static NSString *const ResponseDictionarySuccessKey = @"success";

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

- (void)cancelAllOperations
{
    [self.manager.operationQueue cancelAllOperations];
}

#pragma mark - NoCRMServices

- (void)traSSNoCRMServiceGetDomainData:(NSString *)domainURL requestResult:(ResponseBlock)domainOwnerResponse
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", traSSNOCRMServiceGETDomainData, domainURL];
    [self performGET:requestURL withParameters:nil response:domainOwnerResponse];
}

- (void)traSSNoCRMServiceGetDomainAvaliability:(NSString *)domainURL requestResult:(ResponseBlock)domainAvaliabilityResponse
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", traSSNOCRMServiceGETDomainAvaliability, domainURL];
    [self performGET:requestURL withParameters:nil response:domainAvaliabilityResponse];
}

- (void)traSSNoCRMServicePerformSearchByIMEI:(NSString *)mobileIMEI requestResult:(ResponseBlock)mobileIMEISearchResponse
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", traSSNOCRMServiceGETSearchMobileIMEI, mobileIMEI];
    [self performGET:requestURL withParameters:nil response:mobileIMEISearchResponse];
}

- (void)traSSNoCRMServicePerformSearchByMobileBrand:(NSString *)mobileBrand requestResult:(ResponseBlock)mobileBrandSearchResponse
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", traSSNOCRMServiceGETSearchMobileBrand, mobileBrand];
    [self performGET:requestURL withParameters:nil response:mobileBrandSearchResponse];
}

- (void)traSSNoCRMServicePOSTFeedback:(NSString *)feedback forSerivce:(NSString *)serviceName withRating:(NSUInteger)rating requestResult:(ResponseBlock)serviceFeedbackResponse
{
    NSDictionary *parameters = @{
                                 @"serviceName": serviceName,
                                 @"rate": @(rating),
                                 @"feedback": feedback.length ? feedback : @""
                                 };
    [self performPOST:traSSNOCRMServicePOSTFeedBack withParameters:parameters response:serviceFeedbackResponse];
}

- (void)traSSNoCRMServicePOSTSMSSpamReport:(NSString *)spammerPhoneNumber notes:(NSString *)note requestResult:(ResponseBlock)SMSSpamReportResponse
{
    NSDictionary *parameters = @{
                                 @"phone": spammerPhoneNumber,
                                 @"description": note
                                 };
    [self performPOST:traSSNOCRMServicePOSTSMSSPamReport withParameters:parameters response:SMSSpamReportResponse];
}

- (void)traSSNoCRMServicePOSTSMSBlock:(NSString *)spammerPhoneNumber phoneProvider:(NSString *)provider providerType:(NSString *)providerType notes:(NSString *)note requestResult:(ResponseBlock)SMSBlockResponse
{
    NSDictionary *parameters = @{
                                 @"phone": spammerPhoneNumber,
                                 @"phoneProvider": provider,
                                 @"providerType": providerType,
                                 @"description": note
                                 };
    [self performPOST:traSSNOCRMServicePOSTSMSBlock withParameters:parameters response:SMSBlockResponse];
}

- (void)traSSNoCRMServicePOSTHelpSalim:(NSString *)urlAddress notes:(NSString *)comment requestResult:(ResponseBlock)helpSalimReportResponse
{
    NSDictionary *parameters = @{
                                 @"url" : urlAddress,
                                 @"description" : comment
                                 };
    [self performPOST:traSSNOCRMServicePOSTHelpSalim withParameters:parameters response:helpSalimReportResponse];
}

- (void)traSSNoCRMServicePOSTComplianAboutServiceProvider:(NSString *)serviceProvider title:(NSString *)compliantTitle description:(NSString *)compliantDescription refNumber:(NSUInteger)number attachment:(UIImage *)compliantAttachmnet complienType:(ComplianType)type requestResult:(ResponseBlock)compliantAboutServiceProviderResponse
{
    NSMutableDictionary *parameters = [ @{
                                          @"title" : compliantTitle,
                                          @"description" : compliantDescription
                                          } mutableCopy];
    
    if (type == ComplianTypeCustomProvider) {
        if ([serviceProvider isEqualToString:@"du"]) {
            [parameters setValue:serviceProvider forKey:@"serviceProvider"];
        } else {
            [parameters setValue:[serviceProvider capitalizedString] forKey:@"serviceProvider"];
        }
        [parameters setValue:@(number) forKey:@"referenceNumber"];
    }
    
    if (compliantAttachmnet) {
        NSData *imageData = UIImagePNGRepresentation(compliantAttachmnet);
        NSString *base64PhotoString = [imageData base64EncodedStringWithOptions:kNilOptions];
        base64PhotoString = [ImagePrefixBase64String stringByAppendingString:base64PhotoString];
        if (base64PhotoString.length) {
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
    [self performPOST:path withParameters:parameters response:compliantAboutServiceProviderResponse];
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
    [self performPOST:traSSNOCRMServicePOSTSendSuggestin withParameters:parameters response:suggestionResponse];
}

- (void)traSSNoCRMServicePOSTPoorCoverageAtLatitude:(CGFloat)latitude longtitude:(CGFloat)longtitude address:(NSString *)address signalPower:(NSUInteger)signalLevel requestResult:(ResponseBlock)poorCoverageResponse
{
    NSMutableDictionary *parameters = [ @{
                                          @"signalLevel" : @(signalLevel)
                                          } mutableCopy];
    
    if (latitude && longtitude) {
        [parameters setValue: @{
                                @"latitude" : @(latitude),
                                @"longitude" : @(longtitude)
                                }
                      forKey:@"location"];
    }
    
    if (address.length) {
        [parameters setValue:address forKey:@"address"];
    }
    [self performPOST:traSSNOCRMServicePOSTPoorCoverage withParameters:parameters response:poorCoverageResponse];
}

- (void)traSSNoCRMServicePostInnovationTitle:(NSString *)title message:(NSString *)message type:(NSNumber *)type responseBlock:(ResponseBlock)innovationResponse{
    NSDictionary *parameters = @{
                                 @"title" : title,
                                 @"message" : message,
                                 @"type" : type
                                 };
    [self performPOST:traSSNOCRMServicePostInnovation withParameters:parameters response:innovationResponse];
}

#pragma mark - Favourite

- (void)traSSNoCRMSErviceGetFavoritesServices:(ResponseBlock)favoriteServices
{
    [self performGET:traSSNOCRMServiceGETFavoritesServices withParameters:nil response:favoriteServices];
}

- (void)traSSNoCRMServicePostAddServicesToFavorites:(NSArray *)serviceNames responce:(ResponseBlock)result
{
    NSDictionary *parameters;
    if (serviceNames) {
        parameters = @{@"serviceNames" : serviceNames};
    } else {
        return;
    }
    [self performPOST:traSSNOCRMServicePOSTAddServicesToFavorites withParameters:parameters response:result];
}

- (void)traSSNoCRMServiceDeleteServicesFromFavorites:(NSArray *)serviceNames responce:(ResponseBlock)result
{
    NSDictionary *parameters;
    if (serviceNames) {
        parameters = @{@"serviceNames" : serviceNames};
    } else {
        return;
    }
    [self performDELETE:traSSNOCRMServiceDELETEServicesFromFavorites withParameters:parameters response:result];
}

- (void)traSSNoCRMServiceGetAllServicesNames:(ResponseBlock)result
{
    [self performGET:traSSNOCRMServiceGETAllServicesNames withParameters:nil response:result];
}

- (void)traSSNoCRMServiceGetServiceAboutInfo:(NSString *)serviceName languageCode:(NSString *)languageCode responseBlock:(ResponseBlock)aboutServiceInfoResponse
{
    NSString *requestURL = [NSString stringWithFormat:@"%@%@&lang=%@", traSSNOCRMServiceGETAboutServiceInfo, serviceName, languageCode];
    [self performGET:requestURL withParameters:nil response:aboutServiceInfoResponse];
}

- (void)traSSNoCRMServiceGetGetTransactions:(NSInteger)page count:(NSInteger)count orderAsc:(BOOL)orderArc responseBlock:(ResponseBlock)getTransactionResponse
{
    NSString *requestURL = [NSString stringWithFormat:@"%@", traSSNOCRMServiceGetTransactions];
    
    if (page && count) {
        NSString *pagesNumber = [NSString stringWithFormat:@"%i", (int)page];
        NSString *countElements = [NSString stringWithFormat:@"%i", (int)count];
//        requestURL = [NSString stringWithFormat:@"%@?page=%@&cout=%@&orderAsc=%@", traSSNOCRMServiceGetTransactions, pagesNumber, countElements, orderArc ? @"1" : @"0"];
        requestURL = [NSString stringWithFormat:@"%@?page=%@&cout=%@", traSSNOCRMServiceGetTransactions, pagesNumber, countElements]; //temp asc not work

    }
    
    [self.manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id value = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *responseTransactions = [[NSMutableArray alloc] init];
            
            for (NSDictionary *transActionDict in value) {
                TransactionModel *transactionModel = [[TransactionModel alloc] initWithDictionary:transActionDict];
                [responseTransactions addObject:transactionModel];
            }
            
            getTransactionResponse(responseTransactions, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        PerformFailureRecognition(operation, error, getTransactionResponse);
    }];
}

#pragma mark - UserInteraction

- (void)traSSRegisterUsername:(NSString *)username password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName emiratesID:(NSString *)countryID state:(NSString *)state mobilePhone:(NSString *)mobile email:(NSString *)emailAddress requestResult:(ResponseBlock)registerResponse
{
    NSDictionary *parameters = @{
                                 @"login" : username,
                                 @"pass" : password,
                                 @"first" : firstName,
                                 @"last" : lastName,
                                 @"emiratesId" : countryID,
                                 @"state" : state,
                                 @"mobile" : mobile,
                                 @"email" : emailAddress
                                 };
    [self performPOST:traSSRegister withParameters:parameters response:registerResponse];
}

- (void)traSSLoginUsername:(NSString *)username password:(NSString *)password requestResult:(ResponseBlock)loginResponse
{
    NSDictionary *parameters = @{
                                 @"login" : username,
                                 @"pass" : password
                                 };
    __weak typeof(self) weakSelf = self;
    [self.manager POST:traSSLogin parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        PerformSuccessRecognition(operation, responseObject, loginResponse);
        weakSelf.isUserLoggined = YES;
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        PerformFailureRecognition(operation, error, loginResponse);
    }];
}

- (void)traSSGetUserProfileResult:(ResponseBlock)profileResponse
{
    [self performGET:traSSProfile withParameters:nil response:profileResponse];
}

- (void)traSSUpdateUserProfile:(UserModel *)userProfile requestResult:(ResponseBlock)updateProfileResponse
{
    NSDictionary *parameters = @{
                                 @"first" : userProfile.firstName,
                                 @"last" : userProfile.lastName
                                 };
    
    [self performPUT:traSSProfile withParameters:parameters response:updateProfileResponse];
}

- (void)traSSChangePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword requestResult:(ResponseBlock)changePasswordResponse
{
    NSDictionary *parameters = @{
                                 @"oldPass" : oldPassword,
                                 @"newPass" : newPassword
                                 };
    [self performPUT:traSSChangePassword withParameters:parameters response:changePasswordResponse];
}

- (void)traSSForgotPasswordForEmail:(NSString *)email requestResult:(ResponseBlock)forgotPasswordResponse
{
    [self performPOST:traSSForgotPassword withParameters:@{@"email" : email} response:forgotPasswordResponse];
}

- (void)traSSLogout:(ResponseBlock)logoutResponse
{
    __weak typeof(self) weakSelf = self;
    [self.manager POST:traSSLogOut parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        PerformSuccessRecognition(operation, responseObject, logoutResponse);
        weakSelf.isUserLoggined = NO;
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        PerformFailureRecognition(operation, error, logoutResponse);
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

void(^PerformFailureRecognition)(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error, ResponseBlock handler) = ^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error, ResponseBlock handler) {
    NSString *responseString = dynamicLocalizedString(@"api.message.serverError");
    if (operation.responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:kNilOptions error:&error];
        id responsedObject = [response valueForKey:ResponseDictionaryErrorKey];
        if ([responsedObject isKindOfClass:[NSArray class]]){
            responseString = [(NSArray *)responsedObject firstObject];
        } else if ([responsedObject isKindOfClass:[NSString class]]){
            responseString = responsedObject;
        }
    }
    handler(responseString, error);
};

void(^PerformSuccessRecognition)(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject, ResponseBlock handler) = ^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject, ResponseBlock handler) {
    if (responseObject) {
        id value = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSString *info = dynamicLocalizedString(@"api.message.noDataFound");
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDictionary = value;
            if ([responseDictionary valueForKey:ResponseDictionarySuccessKey]) {
                info = [responseDictionary valueForKey:ResponseDictionarySuccessKey];
            } else if ([responseDictionary valueForKey:@"availableStatus"]) {
                info = [responseDictionary valueForKey:@"availableStatus"];
            } else if ([responseDictionary valueForKey:@"urlData"]) {
                info = [responseDictionary valueForKey:@"urlData"];
            } else {
                handler(responseDictionary, nil);
                return;
            }
            handler(info, nil);
        } else if ([value isKindOfClass:[NSArray class]]) {
            handler(value, nil);
        }
    } else {
        handler(dynamicLocalizedString(@"api.message.noDataFound"), nil);
    }
};

- (void)performPOST:(NSString *)path withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler
{
    [self.manager POST:path parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        PerformSuccessRecognition(operation, responseObject, completionHandler);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        PerformFailureRecognition(operation, error, completionHandler);
    }];
}

- (void)performPUT:(NSString *)path withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler
{
    [self.manager PUT:path parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        PerformSuccessRecognition(operation, responseObject, completionHandler);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        PerformFailureRecognition(operation, error, completionHandler);
    }];
}

- (void)performGET:(NSString *)path withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler
{
    NSString *stringCleanPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.manager GET:stringCleanPath parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
        PerformSuccessRecognition(operation, responseObject, completionHandler);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        PerformFailureRecognition(operation, error, completionHandler);
    }];
}

- (void)performDELETE:(NSString *)path withParameters:(NSDictionary *)parameters response:(ResponseBlock)completionHandler
{
    [self.manager DELETE:path parameters:parameters success:^(AFHTTPRequestOperation * __nonnull operation, id  __nonnull responseObject) {
        PerformSuccessRecognition(operation, responseObject, completionHandler);
    } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
        PerformFailureRecognition(operation, error, completionHandler);
    }];
}

#pragma mark - Preparation

- (void)prepareNetworkManagerWithURL:(NSURL *)baseURL
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:TESTBaseURLPathKey]) {
        NSString *path = [[NSUserDefaults standardUserDefaults] valueForKey:TESTBaseURLPathKey];
        if (path.length) {
            baseURL = [NSURL URLWithString:path];
        }
    }

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
    [[NSUserDefaults standardUserDefaults] setValue:baseURL forKey:TESTBaseURLPathKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self prepareNetworkManagerWithURL:[NSURL URLWithString:baseURL]];
}

@end