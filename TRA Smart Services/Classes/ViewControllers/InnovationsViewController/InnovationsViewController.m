//
//  InnovationsViewController.m
//  TRA Smart Services
//
//  Created by Admin on 29.09.15.
//

#import "InnovationsViewController.h"
#import "PlaceholderTextView.h"

@interface InnovationsViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *innovationsTitleTextField;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *publicLabel;
@property (weak, nonatomic) IBOutlet UILabel *privateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *optionsSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *infoIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *innovationsMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *attachButton;
@property (weak, nonatomic) IBOutlet UIView *containerInfoView;
@property (weak, nonatomic) IBOutlet UIView *containerMessageView;

@end

@implementation InnovationsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareUISwitchSettingViewController];
    [self selectOptionSwitch:self.optionsSwitch];
    [self prepareAttachButton];
}

#pragma mark - IBAction

- (IBAction)tapAttachButton:(id)sender
{
    [self selectImagePickerController];
}

- (void)selectOptionSwitch:(UISwitch *)opitonSwitch
{
    if (opitonSwitch.isOn) {
        self.privateLabel.textColor = [UIColor lightGrayColor];
        self.publicLabel.textColor = [self.dynamicService currentApplicationColor];
    } else {
        self.privateLabel.textColor = [self.dynamicService currentApplicationColor];
        self.publicLabel.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)sendInfo:(id)sender
{
    if (!self.innovationsTitleTextField.text.length || !self.descriptionTextView.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, TRAAnimationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
        });
        [self clearUI];
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
    self.title = dynamicLocalizedString(@"innovationsViewController.title");
    [self.submitButton setTitle:dynamicLocalizedString(@"innovationsViewController.submitButton") forState:UIControlStateNormal];
    self.innovationsTitleTextField.placeholder = dynamicLocalizedString(@"innovationsViewController.innovationsTitleTextField.placeholder");
    self.innovationsMessageLabel.text = dynamicLocalizedString(@"innovationsViewController.innovationsMessageLabel.text");
    self.descriptionTextView.placeholder = dynamicLocalizedString(@"innovationsViewController.descriptionTextView.placeholder");
}

- (void)updateColors
{
    [super updateColors];
    
    [super updateBackgroundImageNamed:@"fav_back_orange"];
    
    UIColor *color = [DynamicUIService service].currentApplicationColor;
    self.optionsSwitch.onTintColor = color;
    self.infoIconImageView.tintColor = color;
    self.attachButton.backgroundColor = [UIColor clearColor];
    self.attachButton.tintColor = color;
}

- (void)setRTLArabicUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentRight];
    [self transformUILayer:TRANFORM_3D_SCALE];
}

- (void)setLTREuropeUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentLeft];
    [self transformUILayer:CATransform3DIdentity];
}

#pragma mark - UIPreparation

- (void)prepareUISwitchSettingViewController
{
    [self.optionsSwitch addTarget:self action:@selector(selectOptionSwitch:) forControlEvents:UIControlEventValueChanged];
    
    [self prepareUISwitch:self.optionsSwitch];
}

- (void)prepareUISwitch:(UISwitch *) prepareSwitch
{
    prepareSwitch.backgroundColor = [UIColor grayBorderTextFieldTextColor];
    prepareSwitch.layer.cornerRadius = prepareSwitch.bounds.size.height / 2;
    prepareSwitch.tintColor = [UIColor grayBorderTextFieldTextColor];
}

- (void)clearUI
{
    self.innovationsTitleTextField.text = @"";
    self.descriptionTextView.text = @"";
    self.selectImage = nil;
    [self prepareAttachButton];
}

- (void)prepareAttachButton
{
    if (self.selectImage) {
        [self.attachButton setImage:[UIImage imageNamed:@"btn_attach_file"] forState:UIControlStateNormal];
    } else {
        [self.attachButton setImage:[UIImage imageNamed:@"btn_attach"] forState:UIControlStateNormal];
    }
}

#pragma mark - Private

- (void)updateUIElementsWithTextAlignment:(NSTextAlignment)alignment
{
    self.innovationsTitleTextField.textAlignment = alignment;
    self.descriptionTextView.textAlignment = alignment;
    self.innovationsMessageLabel.textAlignment = alignment;
}

- (void)transformUILayer:(CATransform3D)animCATransform3D
{
    self.containerInfoView.layer.transform = animCATransform3D;
    self.containerMessageView.layer.transform = animCATransform3D;
    self.innovationsMessageLabel.layer.transform = animCATransform3D;
    self.attachButton.layer.transform = animCATransform3D;
    self.privateLabel.layer.transform = animCATransform3D;
    self.publicLabel.layer.transform = animCATransform3D;
}

@end
