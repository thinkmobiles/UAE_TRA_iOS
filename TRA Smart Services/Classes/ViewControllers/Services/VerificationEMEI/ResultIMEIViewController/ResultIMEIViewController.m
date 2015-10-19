//
//  ResultIMEIViewController.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 30.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "ResultIMEIViewController.h"

@interface ResultIMEIViewController ()

@property (weak, nonatomic) IBOutlet UILabel *resultSendIMEILabel;

@end

@implementation ResultIMEIViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareResultIMEILabel];
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"resultIMEIViewController.title");
}

- (void)updateColors
{
    [super updateBackgroundImageNamed:@"img_bg_service"];
}

- (void)setRTLArabicUI
{
    [super setRTLArabicUI];
    
    self.resultSendIMEILabel.textAlignment = NSTextAlignmentRight;
}

- (void)setLTREuropeUI
{
    [super setLTREuropeUI];

    self.resultSendIMEILabel.textAlignment = NSTextAlignmentLeft;
}

#pragma mark - Private

- (void)prepareResultIMEILabel
{
    self.resultSendIMEILabel.text = self.resultString.length ? self.resultString : dynamicLocalizedString(@"resultIMEIViewController.noDeviceDatabase");
}

@end
