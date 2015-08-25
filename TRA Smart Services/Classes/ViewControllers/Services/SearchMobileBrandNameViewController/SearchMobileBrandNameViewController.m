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
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
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
                [AppHelper alertViewWithMessage:error.localizedDescription];
            } else {
                weakSelf.resultInfoTextView.text = response;
            }
            [AppHelper hideLoader];
            weakSelf.brandNameTextField.text = @"";
        }];
    } else {
        [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Private

- (void)prepareUI
{
    self.searchButton.layer.cornerRadius = 8;
    self.searchButton.layer.borderColor = [UIColor defaultOrangeColor].CGColor;
    self.searchButton.layer.borderWidth = 1;
}

@end
