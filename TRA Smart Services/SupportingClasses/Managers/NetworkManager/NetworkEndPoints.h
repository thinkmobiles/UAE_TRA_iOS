//
//  NetworkEndPoints.h
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//

#pragma mark - NoCRMServices

static NSString *const traSSNoCRMServiceBaseURL =
@"http://mobws.tra.gov.ae";
//https://mobsrv.tra.gov.ae/

static NSString *const traSSNOCRMServiceGETDomainData = @"/checkWhois?checkUrl=";
static NSString *const traSSNOCRMServiceGETDomainAvaliability = @"/checkWhoisAvailable?checkUrl=";
static NSString *const traSSNOCRMServiceGETSearchMobileIMEI = @"/searchMobile?imei=";
static NSString *const traSSNOCRMServiceGETSearchMobileBrand = @"/searchMobileBrand?brand=";
static NSString *const traSSNOCRMServicePOSTFeedBack = @"/feedback";
static NSString *const traSSNOCRMServicePOSTSMSSPamReport = @"/complainSmsSpam";
static NSString *const traSSNOCRMServicePOSTSMSBlock = @"/complainSmsBlock";
static NSString *const traSSNOCRMServicePOSTHelpSalim = @"/sendHelpSalim";
static NSString *const traSSNOCRMServicePOSTCompliantServiceProvider = @"/complainServiceProvider";
static NSString *const traSSNOCRMServicePOSTCompliantAboutTRAService = @"/complainTRAService";
static NSString *const traSSNOCRMServicePOSTCompliantAboutEnquires = @"/complainEnquiries";
static NSString *const traSSNOCRMServicePOSTSendSuggestin = @"/sendSuggestion";
static NSString *const traSSNOCRMServicePOSTPoorCoverage = @"/sendPoorCoverage";
static NSString *const traSSNOCRMServiceGETFavoritesServices = @"/user/favorites";
static NSString *const traSSNOCRMServicePOSTAddServicesToFavorites = @"/user/favorites";
static NSString *const traSSNOCRMServiceDELETEServicesFromFavorites = @"/user/favorites";
static NSString *const traSSNOCRMServiceGETAllServicesNames = @"/service/serviceNames";
static NSString *const traSSNOCRMServiceGETAboutServiceInfo = @"/service/about?name=";
static NSString *const traSSNOCRMServiceGetTransactions = @"/crm/transactions";
static NSString *const traSSNOCRMServiceSearchTransactions = @"/crm/transactions?page=";
static NSString *const traSSNOCRMServicePostInnovation = @"/innovation";

static NSString *const traSSRegister = @"/crm/register";
static NSString *const traSSLogin = @"/crm/signIn";
static NSString *const traSSLogOut = @"/crm/signOut";
static NSString *const traSSProfile = @"/crm/profile";
static NSString *const traSSChangePassword = @"/crm/changePass";
static NSString *const traSSForgotPassword = @"/crm/forgotPass";
