//
//  CheckIMEIViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BarcodeCodeReader.h"

@interface CheckIMEIViewController : BaseServiceViewController <BarcodeCodeReaderDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) BOOL needTransparentNavigationBar;

@property (strong, nonatomic) void (^didFinishWithResult)(NSString *result);

@end
