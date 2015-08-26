//
//  Constants.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#pragma mark - Defines

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#pragma mark - Messages

static NSString *const MessageNotImplemented = @"Not implemented";
static NSString *const MessageSuccess = @"Success";
static NSString *const MessageEmptyInputParameter = @"Please enter text in the text field";
static NSString *const MessageIncorrectRating = @"Incorrect rating format - shoul use only numbers";
static NSString *const MessageNoCameraPermissionGranted = @"This app requires access to your device's Camera's.\n\nPlease enable Camera access for this app in Settings / Privacy / Camera";
static NSString *const MessageNoLocationPermissionGranted = @"This app requires access to your device's Location's.\n\nPlease enable Location access for this app in Settings / Privacy / Location";
static NSString *const MessageNoLocationEnabledOnDevice = @"Location service disabled on your device. Please enable Location service and try again.";

static NSString *const MessageNoInternetConnection = @"No internetConnection Avaliable. Please check your network and try again.";

static NSString *const MessageArabicIncorrectDomainName = @"يرجى ادخال اسم نطاق صالح";
