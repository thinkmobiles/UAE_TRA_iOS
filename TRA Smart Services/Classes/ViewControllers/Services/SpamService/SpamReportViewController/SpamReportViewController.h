//
//  SpamRaportViewController.h
//  TRA Smart Services
//
//  Created by RomanVizenko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import <MessageUI/MessageUI.h>

typedef NS_ENUM(NSUInteger, SpamReportType) {
    SpamReportTypeSMS,
    SpamReportTypeWeb
};

@interface SpamReportViewController : BaseServiceViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate>

@property (assign, nonatomic) SpamReportType selectSpamReport;

@end
