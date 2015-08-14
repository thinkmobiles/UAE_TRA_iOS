//
//  NetworkEndPoints.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#pragma mark - NoCRMServices

static NSString *const traSSNoCRMServiceBaseURL = @"http://134.249.164.53:7791";

static NSString *const traSSNOCRMServiceGETDomainData = @"/checkWhois?checkUrl=";
static NSString *const traSSNOCRMServiceGETDomainAvaliability = @"/checkWhoisAvailable?checkUrl=";
static NSString *const traSSNOCRMServiceGETSearchMobileIMEI = @"/searchMobile?imei=";
static NSString *const traSSNOCRMServiceGETSearchMobileBrand = @"/searchMobileBrand?brand=";
static NSString *const traSSNOCRMServicePOSTFeedBack = @"/feedback";
static NSString *const traSSNOCRMServicePOSTSMSSPamReport = @"/complainSmsSpam";
static NSString *const traSSNOCRMServicePOSTHelpSalim = @"/sendHelpSalim";
static NSString *const traSSNOCRMServicePOSTCompliantServiceProvider = @"/complainServiceProvider";