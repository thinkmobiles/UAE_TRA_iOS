//
//  SelectRegisterViewController.m
//  TRA Smart Services
//
//  Created by Anatoliy Dalekorey on 9/15/15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SelectRegisterViewController.h"

@interface SelectRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
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
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName : self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:14.f] : [UIFont latoRegularWithSize:14.f],
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                      }];
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
    
    UIImage *backgroundImage = [UIImage imageNamed:@"res_img_bg"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImage.image = backgroundImage;
}

@end
