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
    UIColor *color = [[DynamicUIService service] currentApplicationColor];
    [self.emiratesIDButton setTintColor:color];
    [self.fillFormButton setTintColor:color];
    [self.registerInformation setTextColor:color];
    [self.emiratesIDLabel setTextColor:color];
    [self.fillFormLabel setTextColor:color];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"res_img_bg"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImage.image = backgroundImage;
}

@end
