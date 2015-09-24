//
//  SpamSelectionViewController.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 23.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "SpamSelectionViewController.h"
#import "ServiceHeaderView.h"
#import "ServiceSelectionView.h"

@interface SpamSelectionViewController ()

@property (weak, nonatomic) IBOutlet ServiceHeaderView *conteinerServiceHeaderView;
@property (weak, nonatomic) IBOutlet ServiceSelectionView *conteinerServiceSelectionView;

@end

@implementation SpamSelectionViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareXibsImages];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareNavigationBar];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"spamSelectionViewController.title");
    [self prepareServiceHeaderViewLocalization];
    [self prepareServiceSelectionViewLocalization];
}

- (void)updateColors
{
    [super updateBackgroundImageNamed:@"img_bg_service"];
    [self.conteinerServiceSelectionView updateUIColor];
    [self.conteinerServiceHeaderView updateUIColor];
}

#pragma mark - ServiceSelectionViewDelegate

- (void)buttonReportSMSDidTapped
{
    
}

- (void)buttonReportWEBDidTapped
{
    
}

- (void)buttonViewMyListDidTapped
{
    
}

#pragma mark - Private

- (void)prepareServiceHeaderViewLocalization
{
    self.conteinerServiceHeaderView.serviceHeaderLabel.text = dynamicLocalizedString(@"spamSelectionViewController.serviceHeaderLabel");
}

- (void)prepareServiceSelectionViewLocalization
{
    self.conteinerServiceSelectionView.reportSMSLabel.text = dynamicLocalizedString(@"spamSelectionViewController.serviceSelectionView.reportSMSLabel");
    self.conteinerServiceSelectionView.reportWEBLabel.text = dynamicLocalizedString(@"spamSelectionViewController.serviceSelectionView.reportWEBLabel");
    self.conteinerServiceSelectionView.viewMyListLabel.text = dynamicLocalizedString(@"spamSelectionViewController.serviceSelectionView.viewMyListLabel");
}

- (void)prepareXibsImages
{
    self.conteinerServiceSelectionView.serviceNameReportSMSImage = [UIImage imageNamed:@"ic_report"];
    self.conteinerServiceSelectionView.serviceNameReportWEBImage = [UIImage imageNamed:@"ic_rep_web"];
    self.conteinerServiceSelectionView.serviceNameViewMyListImage = [UIImage imageNamed:@"ic_view"];
    self.conteinerServiceHeaderView.serviceHeaderImage = [UIImage imageNamed:@"ic_mail_serv"];
}

- (void)prepareNavigationBar
{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [AppHelper titleFontForNavigationBar:self.navigationController.navigationBar];
    self.navigationController.navigationBar.translucent = YES;
}

@end
