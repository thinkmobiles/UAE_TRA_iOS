//
//  SelectRegisterViewController.m
//  TRA Smart Services
//
//  Created by Admin on 9/15/15.
//

#import "SelectRegisterViewController.h"

@interface SelectRegisterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *registerInformation;
@property (weak, nonatomic) IBOutlet UIButton *emiratesIDButton;
@property (weak, nonatomic) IBOutlet UIButton *fillFormButton;
@property (weak, nonatomic) IBOutlet UILabel *emiratesIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *fillFormLabel;

@end

@implementation SelectRegisterViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
    [AppHelper titleFontForNavigationBar:self.navigationController.navigationBar];
}

#pragma mark - UI

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"register.title");
    self.registerInformation.text = dynamicLocalizedString(@"register.label.registerInfo");
    self.emiratesIDLabel.text = dynamicLocalizedString(@"register.label.emiratesID");
    self.fillFormLabel.text = dynamicLocalizedString(@"register.label.fillForm");
}

- (void)updateColors
{
    UIColor *color = [self.dynamicService currentApplicationColor];
    [self.emiratesIDButton setTintColor:color];
    [self.fillFormButton setTintColor:color];
    [self.registerInformation setTextColor:color];
    [self.emiratesIDLabel setTextColor:color];
    [self.fillFormLabel setTextColor:color];
    
    [super updateBackgroundImageNamed:@"res_img_bg"];
}

@end