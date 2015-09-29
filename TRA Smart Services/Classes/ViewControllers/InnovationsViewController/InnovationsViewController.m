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

@end

@implementation InnovationsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"innovationsViewController.title");
}

- (void)updateColors
{
    [super updateColors];
    
    [super updateBackgroundImageNamed:@"fav_back_orange"];
}


@end
