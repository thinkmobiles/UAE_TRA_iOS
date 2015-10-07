//
//  CheckDomainViewController.h
//  TRA Smart Services
//
//  Created by Admin on 13.08.15.
//

@class WhoIsModel;

@interface CheckDomainViewController : BaseServiceViewController <UITextFieldDelegate, UITextViewDelegate>

@property (copy, nonatomic) NSString *domainName;
@property (copy, nonatomic) NSString *response;
@property (strong, nonatomic) WhoIsModel *whoIS;

@end
