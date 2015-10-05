//
//  BaseNetworkManager.h
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//

#import "AFNetworkReachabilityManager.h"
#import "TRALoaderViewController.h"
#import "UserModel.h"

static NSString *const ServiceTypeGetDomainDataStringName = @"whois";
static NSString *const ServiceTypeGetDomainAvaliabilityStringName = @"availability";
static NSString *const ServiceTypeSearchMobileIMEIStringName = @"verification";
static NSString *const ServiceTypeSearchMobileBrandStringName = @"mobile brand";
static NSString *const ServiceTypeFeedbackStringName = @"Rating service";
static NSString *const ServiceTypeSMSSpamReportStringName = @"report sms";
static NSString *const ServiceTypeHelpSalimStringName = @"help salim";
static NSString *const ServiceTypeVerificationStringName = @"verification";
static NSString *const ServiceTypeCoverageStringName = @"coverage";
static NSString *const ServiceTypeInternetSpeedTestStringName = @"";
static NSString *const ServiceTypeCompliantAboutServiceProviderStringName = @"complain about service provider";
static NSString *const ServiceTypeSuggestionStringName = @"suggestion";
static NSString *const ServiceTypeCompliantAboutServiceProviderEnquiresStringName = @"enquiries";
static NSString *const ServiceTypeCompliantAboutServiceProviderTRAStringName = @"complain about tra";

static NSString *const TESTBaseURLPathKey = @"TESTBaseURLPathKey";

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
    ServiceTypeSuggestion = 11,
    ServiceTypeCompliantAboutServiceProviderEnquires = 12,
    ServiceTypeCompliantAboutServiceProviderTRA = 13
};

typedef NS_ENUM(NSUInteger, ComplianType) {
    ComplianTypeCustomProvider = 0,
    ComplianTypeTRAService,
    ComplianTypeEnquires
};

typedef void(^ResponseBlock)(id response, NSError *error);

@interface NetworkManager : NSObject <NSStreamDelegate>

@property (assign, nonatomic) AFNetworkReachabilityStatus networkStatus;
@property (assign, nonatomic) __block BOOL isUserLoggined;

+ (instancetype)sharedManager;

- (void)cancelAllOperations;

#pragma mark - Reachability

- (void)startMonitoringNetwork;
- (void)stopMonitoringNetwork;

#pragma mark - NoCRMServices

- (void)traSSNoCRMServiceGetDomainData:(NSString *)domainURL requestResult:(ResponseBlock)domainOwnerResponse;
- (void)traSSNoCRMServiceGetDomainAvaliability:(NSString *)domainURL requestResult:(ResponseBlock)domainAvaliabilityResponse;
- (void)traSSNoCRMServicePerformSearchByIMEI:(NSString *)mobileIMEI requestResult:(ResponseBlock)mobileIMEISearchResponse;
- (void)traSSNoCRMServicePerformSearchByMobileBrand:(NSString *)mobileBrand requestResult:(ResponseBlock)mobileBrandSearchResponse;
- (void)traSSNoCRMServicePOSTFeedback:(NSString *)feedback forSerivce:(NSString *)serviceName withRating:(NSUInteger)rating requestResult:(ResponseBlock)mobileBrandSearchResponse;
- (void)traSSNoCRMServicePOSTSMSSpamReport:(NSString *)spammerPhoneNumber notes:(NSString *)note requestResult:(ResponseBlock)SMSSpamReportResponse;
- (void)traSSNoCRMServicePOSTSMSBlock:(NSString *)spammerPhoneNumber phoneProvider:(NSString *)provider providerType:(NSString *)providerType notes:(NSString *)note requestResult:(ResponseBlock)SMSSpamReportResponse;
- (void)traSSNoCRMServicePOSTHelpSalim:(NSString *)urlAddress notes:(NSString *)comment requestResult:(ResponseBlock)helpSalimReportResponse;
- (void)traSSNoCRMServicePOSTPoorCoverageAtLatitude:(CGFloat)latitude longtitude:(CGFloat)longtitude address:(NSString *)address signalPower:(NSUInteger)signalLevel requestResult:(ResponseBlock)poorCoverageResponse;
- (void)traSSNoCRMServicePOSTComplianAboutServiceProvider:(NSString *)serviceProvider title:(NSString *)compliantTitle description:(NSString *)compliantDescription refNumber:(NSUInteger)number attachment:(UIImage *)compliantAttachmnet complienType:(ComplianType)type requestResult:(ResponseBlock)compliantAboutServiceProviderResponse;
- (void)traSSNoCRMServicePOSTSendSuggestion:(NSString *)suggestionTitle description:(NSString *)suggestionDescription attachment:(UIImage *)suggestionAttachment requestResult:(ResponseBlock)suggestionResponse;
- (void)traSSNoCRMSErviceGetFavoritesServices:(ResponseBlock)favoriteServices;
- (void)traSSNoCRMServicePostAddServicesToFavorites:(NSArray *)serviceNames responce:(ResponseBlock)result;
- (void)traSSNoCRMServiceDeleteServicesFromFavorites:(NSArray *)serviceNames responce:(ResponseBlock)result;
- (void)traSSNoCRMServiceGetAllServicesNames:(ResponseBlock)result;
- (void)traSSNoCRMServiceGetServiceAboutInfo:(NSString *)serviceName languageCode:(NSString *)languageCode responseBlock:(ResponseBlock)aboutServiceInfoResponse;
- (void)traSSNoCRMServiceGetGetTransactions:(NSInteger)page count:(NSInteger)count orderAsc:(BOOL)orderArc responseBlock:(ResponseBlock)getTransactionResponse;

#pragma mark - User

- (void)traSSRegisterUsername:(NSString *)username password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName emiratesID:(NSString *)countryID state:(NSString *)state mobilePhone:(NSString *)mobile email:(NSString *)emailAddress requestResult:(ResponseBlock)registerResponse;
- (void)traSSLoginUsername:(NSString *)username password:(NSString *)password requestResult:(ResponseBlock)loginResponse;
- (void)traSSGetUserProfileResult:(ResponseBlock)profileResponse;
- (void)traSSUpdateUserProfile:(UserModel *)userProfile requestResult:(ResponseBlock)updateProfileResponse;
- (void)traSSChangePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword requestResult:(ResponseBlock)changePasswordResponse;
- (void)traSSLogout:(ResponseBlock)logoutResponse;

#pragma mark - Temp

- (void)setBaseURL:(NSString *)baseURL;

@end