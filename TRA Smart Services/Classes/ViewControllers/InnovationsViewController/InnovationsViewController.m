//
//  InnovationsViewController.m
//  TRA Smart Services
//
//  Created by  on 29.09.15.
//  Copyright © 2015 . All rights reserved.
//

#import "InnovationsViewController.h"

@interface InnovationsViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *innovationsTitleTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *innovationsMessageTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation InnovationsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

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


@end
