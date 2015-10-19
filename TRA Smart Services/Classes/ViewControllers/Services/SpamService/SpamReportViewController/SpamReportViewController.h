//
//  SpamRaportViewController.h
//  TRA Smart Services
//
//  Created by Admin on 13.08.15.
//

#import <MessageUI/MessageUI.h>

typedef NS_ENUM(NSUInteger, SpamReportType) {
    SpamReportTypeSMS,
    SpamReportTypeWeb
};

@interface SpamReportViewController : BaseServiceViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate>

@property (assign, nonatomic) SpamReportType selectSpamReport;

@end
