//
//  NetworkEndPoints.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//


#pragma mark - NoCRMServiceNetworkManager

static NSString *const NoCRMServiceNetworkManagerBaseURL = @"http://tma.tra.gov.ae/";

static NSString *const NoCRMGetAccesToken = @"tra_api/auth";
static NSString *const NoCRMDomainAvaliability = @"tra_api/service/dnslookup?access_token=";
static NSString *const NoCRMGetDeviceBrandModel = @"tra_api/service/getdevicebrandmodel";
static NSString *const NoCRMgetDeviceModelAll = @"tra_api/service/getdevicebrandmodel/all";
static NSString *const NoCRMDeviceIMEICheck = @"tra_api/service/isfakedevice";
static NSString *const NoCRMPoorCoverageReport = @"tra_api/service/signalcoverage/?access_token=";
static NSString *const NoCRMHelpSalimBlockWebsiteService = @"tra_api/service/blockwebsite/?access_token=";
static NSString *const NoCRMServiceRating = @"tra_api/service/servicerating?access_token=";
static NSString *const NoCRMSMSSpam = @"tra_api/service/insertsmsspam?access_token=";
static NSString *const NoCRMSearchRequest = @"tra_api/service/taggedsearch";
