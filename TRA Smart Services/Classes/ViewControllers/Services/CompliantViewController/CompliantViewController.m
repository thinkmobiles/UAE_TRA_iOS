//
//  CompliantViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "CompliantViewController.h"
#import "NetworkManager.h"
#import "LoginViewController.h"

@interface CompliantViewController ()

@property (weak, nonatomic) IBOutlet UITextField *selectProviderTextField;
@property (weak, nonatomic) IBOutlet UITextField *compliantTitle;
@property (weak, nonatomic) IBOutlet UITextField *refNumber;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UIButton *compliantButton;
@property (weak, nonatomic) IBOutlet UITextView *compliantDescriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceTitleTextFieldConstraint;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) UIPickerView *selectProviderPicker;
@property (strong, nonatomic) NSArray *pickerSelectProviderDataSource;

@end

@implementation CompliantViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUIForCompliantType:self.type];
    [self configureSelectProviderTextFieldInputView];
    [self preparePickerDataSource];
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

- (IBAction)compliant:(id)sender
{
    [self.view endEditing:YES];
    if (!self.compliantDescriptionTextView.text.length ||
        !self.compliantTitle.text.length ||
        (self.type == ComplianTypeCustomProvider && (!self.selectProviderTextField.text.length || !self.refNumber.text.length))){
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        [AppHelper showLoader];
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTComplianAboutServiceProvider:self.selectProviderTextField.text title:self.compliantTitle.text description:self.compliantDescriptionTextView.text refNumber:[self.refNumber.text integerValue] attachment:self.selectImage complienType:self.type requestResult:^(id response, NSError *error) {
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

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger pickerRowsInComponent = 0;
    if (pickerView == self.selectProviderPicker) {
        pickerRowsInComponent = self.pickerSelectProviderDataSource.count;
    }
    return pickerRowsInComponent;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pickerTitle = @"";
    if (pickerView == self.selectProviderPicker) {
        pickerTitle = (NSString *)self.pickerSelectProviderDataSource[row];
    }
    return pickerTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.selectProviderPicker) {
        self.selectProviderTextField.text = self.pickerSelectProviderDataSource[row];
    }
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"compliantViewController.title");
    self.selectProviderTextField.placeholder = dynamicLocalizedString(@"compliantViewController.textField.providerText");
    self.compliantTitle.placeholder = dynamicLocalizedString(@"compliantViewController.textField.compliantTitle");
    self.refNumber.placeholder = dynamicLocalizedString(@"compliantViewController.textField.refNumber");
    self.descriptionLabel.text = dynamicLocalizedString(@"compliantViewController.descriptionLabel.text");
    [self.selectImageButton setTitle:dynamicLocalizedString(@"compliantViewController.selectImageButton.title") forState:UIControlStateNormal];
    [self.compliantButton setTitle:dynamicLocalizedString(@"compliantViewController.compliantButton.title") forState:UIControlStateNormal];
}

- (void)updateColors
{
    [super updateColors];
    
    self.compliantDescriptionTextView.textColor = [[DynamicUIService service] currentApplicationColor];
    self.compliantDescriptionTextView.layer.borderColor = [[DynamicUIService service] currentApplicationColor].CGColor;
    [AppHelper setStyleForLayer:self.compliantDescriptionTextView.layer];
}

#pragma mark - Private

- (void)updateUIForCompliantType:(ComplianType)type
{
    switch (type) {
        case ComplianTypeCustomProvider: {
            self.selectProviderTextField.hidden = NO;
            self.refNumber.hidden = NO;
            self.verticalSpaceTitleTextFieldConstraint.constant = 64.f;
            break;
        }
        case ComplianTypeEnquires:
        case ComplianTypeTRAService: {
            self.verticalSpaceTitleTextFieldConstraint.constant = 16.f;
            break;
        }
            
        default:
            break;
    }
}

- (void)preparePickerDataSource
{
    self.pickerSelectProviderDataSource = @[
                                         dynamicLocalizedString(@"providerType.Du"),
                                         dynamicLocalizedString(@"providerType.Etisalat"),
                                         dynamicLocalizedString(@"providerType.Yahsat")                                         ];
    [self.selectProviderPicker reloadAllComponents];
}

- (void)configureSelectProviderTextFieldInputView
{
    self.selectProviderPicker = [[UIPickerView alloc] init];
    self.selectProviderPicker.delegate = self;
    self.selectProviderPicker.dataSource = self;
    self.selectProviderTextField.inputView = self.selectProviderPicker;
}

@end
