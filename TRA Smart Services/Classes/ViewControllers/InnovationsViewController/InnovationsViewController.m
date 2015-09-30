//
//  InnovationsViewController.m
//  TRA Smart Services
//
//  Created by  on 29.09.15.
//  Copyright © 2015 . All rights reserved.
//

#import "InnovationsViewController.h"
#import "PlaceholderTextView.h"

@interface InnovationsViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *innovationsTitleTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *innovationsMessageTextField;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *publicLabel;
@property (weak, nonatomic) IBOutlet UILabel *privateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *optionsSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *infoIconImageView;

@end

@implementation InnovationsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareUISwitchSettingViewController];
    [self selectOptionSwitch:self.optionsSwitch];
}

#pragma mark - IBAction

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
    TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, TRAAnimationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
    });
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"innovationsViewController.title");
    [self.submitButton setTitle:dynamicLocalizedString(@"innovationsViewController.submitButton") forState:UIControlStateNormal];
    self.innovationsTitleTextField.placeholder = dynamicLocalizedString(@"innovationsViewController.innovationsTitleTextField.placeholder");

    self.descriptionTextView.placeholder = dynamicLocalizedString(@"innovationsViewController.descriptionTextView.placeholder");
}

- (void)updateColors
{
    [super updateBackgroundImageNamed:@"fav_back_orange"];
    
    UIColor *color = [DynamicUIService service].currentApplicationColor;
    self.innovationsTitleTextField.bottomBorderColor = color;
    self.innovationsMessageTextField.bottomBorderColor = color;
    self.descriptionTextView.bottomBorderColor = color;
    self.submitButton.backgroundColor = color;
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

@end
