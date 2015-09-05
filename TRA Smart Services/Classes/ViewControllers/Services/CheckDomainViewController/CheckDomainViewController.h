//
//  CheckDomainViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "RatingView.h"

@interface CheckDomainViewController : BaseServiceViewController <UITextFieldDelegate, UITextViewDelegate, RatingViewDelegate>

@property (copy, nonatomic) NSString *domainName;
@property (copy, nonatomic) NSString *response;

@property (strong, nonatomic) NSArray *result;

@end
