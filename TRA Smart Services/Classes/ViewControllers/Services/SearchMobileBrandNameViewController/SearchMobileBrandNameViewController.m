//
//  SearchMobileBrandNameViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 25.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SearchMobileBrandNameViewController.h"

@interface SearchMobileBrandNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *brandNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultInfoTextView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation SearchMobileBrandNameViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareUI];
    self.title = dynamicLocalizedString(@"searchMobileBrandNameViewController.title");
}

#pragma mark - IBActions

- (IBAction)searchButtonTapped:(id)sender
{
    if (self.brandNameTextField.text.length) {
        [AppHelper showLoader];
        [self.view endEditing:YES];
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] traSSNoCRMServicePerformSearchByMobileBrand:self.brandNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
            } else {
                NSString *string = @"";
                for (NSDictionary *dic in response) {
                    string = [string stringByAppendingString:[NSString stringWithFormat:@"response - %@ \n", dic]];
                }
                weakSelf.resultInfoTextView.text = string;
            }
            [AppHelper hideLoader];
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
    self.brandNameTextField.layer.borderColor = [self.dynamicService currentApplicationColor].CGColor;
    self.brandNameTextField.textColor = [self.dynamicService currentApplicationColor];
    
    [self.searchButton setTitleColor:[self.dynamicService currentApplicationColor] forState:UIControlStateNormal];
    self.searchButton.layer.borderColor = [self.dynamicService currentApplicationColor].CGColor;
}

#pragma mark - Private

- (void)prepareUI
{
    self.searchButton.layer.cornerRadius = 8;
    self.searchButton.layer.borderWidth = 1;
    
    self.brandNameTextField.layer.cornerRadius = 8;
    self.brandNameTextField.layer.borderWidth = 1;
}

@end
