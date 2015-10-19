//
//  CheckIMEIViewController.h
//  TRA Smart Services
//
//  Created by Admin on 13.08.15.
//

#import "BarcodeCodeReader.h"

@interface CheckIMEIViewController : BaseServiceViewController <BarcodeCodeReaderDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) BOOL needTransparentNavigationBar;

@property (strong, nonatomic) void (^didFinishWithResult)(NSString *result);

@end
