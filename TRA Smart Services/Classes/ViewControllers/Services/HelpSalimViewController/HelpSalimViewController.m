//
//  HelpSalimViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "HelpSalimViewController.h"

@interface HelpSalimViewController ()

@property (weak, nonatomic) IBOutlet UITextField *urlToReportTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end

@implementation HelpSalimViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Help Salim Service";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self prepareUI];
}

#pragma mark - IBActions

- (IBAction)reportURlButtonTapped:(id)sender
{
    if (!self.urlToReportTextField.text.length || !self.commentTextView.text.length) {
        [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
        return;
    }
    [AppHelper showLoader];
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;

    [[NetworkManager sharedManager] traSSNoCRMServicePOSTHelpSalim:self.urlToReportTextField.text notes:self.commentTextView.text requestResult:^(id response, NSError *error) {
        if (error) {
            [AppHelper alertViewWithMessage:error.localizedDescription];
        } else {
            [AppHelper alertViewWithMessage:response];
        }
        
        [AppHelper hideLoader];
        
        weakSelf.urlToReportTextField.text = @"";
        weakSelf.commentTextView.text = @"";
    }];
}

#pragma mark - Private

- (void)prepareUI
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            subView.layer.cornerRadius = 8;
            subView.layer.borderColor = [UIColor defaultOrangeColor].CGColor;
            subView.layer.borderWidth = 1;
        }
    }
    
    self.commentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.commentTextView.layer.borderWidth = 1;
    self.commentTextView.layer.cornerRadius = 8;
}


@end
