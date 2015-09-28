//
//  SearchMobileBrandNameViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 25.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SearchMobileBrandNameViewController.h"

@interface SearchMobileBrandNameViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *brandNameTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextView *resultInfoTextView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation SearchMobileBrandNameViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = dynamicLocalizedString(@"searchMobileBrandNameViewController.title");
}

#pragma mark - IBActions

- (IBAction)searchButtonTapped:(id)sender
{
    if (self.brandNameTextField.text.length) {
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        [self.view endEditing:YES];
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] traSSNoCRMServicePerformSearchByMobileBrand:self.brandNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:((NSString *)response).length ? response : error.localizedDescription];
            } else {
                [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
                NSString *string = @"";
                for (NSDictionary *dic in response) {
                    if ([string isEqualToString:@""]) {
                        string = [string stringByAppendingString:@"Approved Device Information\n\n"];
                    }
                    string = [string stringByAppendingString:[dic valueForKey:@"marketingName"]];
                    string = [string stringByAppendingString:@"\n"];
                }
                weakSelf.resultInfoTextView.text = string;
                weakSelf.resultInfoTextView.textAlignment = NSTextAlignmentCenter;
            }
        }];
    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"searchMobileBrandNameViewController.title");
    [self.searchButton setTitle:dynamicLocalizedString(@"searchMobileBrandNameViewController.searchButton") forState:UIControlStateNormal];
}

- (void)updateColors
{
    [super updateColors];
}

- (void)setRTLArabicUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentRight];
}

- (void)setLTREuropeUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentLeft];
}

#pragma mark - Private

- (void)prepareUI
{
    self.searchButton.layer.cornerRadius = 8;
    self.searchButton.layer.borderWidth = 1;
}

- (void)updateUIElementsWithTextAlignment:(NSTextAlignment)alignment
{
    self.brandNameTextField.textAlignment = alignment;
    self.resultInfoTextView.textAlignment = alignment;
    [self.resultInfoTextView setNeedsDisplay];
}

@end