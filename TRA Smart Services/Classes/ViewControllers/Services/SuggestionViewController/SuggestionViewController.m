//
//  SuggestionViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SuggestionViewController.h"
#import "NetworkManager.h"
#import "LoginViewController.h"

@interface SuggestionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *suggestionTitle;
@property (weak, nonatomic) IBOutlet UITextField *suggectionDescription;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UIButton *sendSuggestionButton;

@end

@implementation SuggestionViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self presentLoginIfNeeded];
}

#pragma mark - IABaction

- (IBAction)selectImage:(id)sender
{
    [self selectImagePickerController];
}

- (IBAction)suggection:(id)sender
{
    [self.view endEditing:YES];
    if (!self.suggestionTitle.text.length || !self.suggectionDescription.text.length){
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        [AppHelper showLoader];
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTSendSuggestion:self.suggestionTitle.text description:self.suggectionDescription.text attachment:self.selectImage requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
            } else {
                [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.success")];
            }
            [AppHelper hideLoader];
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"suggestionViewController.title");
    self.suggestionTitle.placeholder = dynamicLocalizedString(@"suggestionViewController.textField.suggestionTitle");
    self.suggectionDescription.placeholder = dynamicLocalizedString(@"suggestionViewController.textField.suggestionDescription");
    [self.selectImageButton setTitle:dynamicLocalizedString(@"suggestionViewController.selectImageButton.title") forState:UIControlStateNormal];
    [self.sendSuggestionButton setTitle:dynamicLocalizedString(@"suggestionViewController.sendSuggestionButton.title") forState:UIControlStateNormal];
}

- (void)updateColors
{
    for (UILabel *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            subView.textColor = [[DynamicUIService service] currentApplicationColor];
        }
    }
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [AppHelper setStyleForLayer:subView.layer];
            [(UIButton *)subView setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
        } else if ([subView isKindOfClass:[UITextField class]]) {
            [AppHelper setStyleForLayer:subView.layer];
            ((UITextField *)subView).textColor = [[DynamicUIService service] currentApplicationColor];
        }
    }
    
}

#pragma mark - Private

- (void)presentLoginIfNeeded
{
    if (![NetworkManager sharedManager].isUserLoggined) {
        UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
#ifdef __IPHONE_8_0
        viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
#endif
        __weak typeof(self) weakSelf = self;
        ((LoginViewController *)viewController.topViewController).didCloseViewController = ^() {
            if (![NetworkManager sharedManager].isUserLoggined) {
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            }
        };
        
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.navigationController presentViewController:viewController animated:NO completion:nil];
    }
}

@end
