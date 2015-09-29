//
//  SpamSelectionViewController.m
//  TRA Smart Services
//
//  Created by Admin on 23.09.15.
//

#import "SpamSelectionViewController.h"
#import "ServiceHeaderView.h"
#import "SpamReportViewController.h"
#import "SpamListViewController.h"

static NSString *const SpamListSegueIdentifier = @"spamListSegueIdentifier";
static NSString *const ReportSpamSMSSegueIdentifier = @"reportSpamSMSSegueIdentifier";
static NSString *const ReportSpamWebSegueIdentifier = @"reportSpamWebSegueIdentifier";

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
    self.conteinerServiceSelectionView.delegate = self;
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
    [self performSegueWithIdentifier:ReportSpamSMSSegueIdentifier sender:self];
}

- (void)buttonReportWEBDidTapped
{
    [self performSegueWithIdentifier:ReportSpamWebSegueIdentifier sender:self];
}

- (void)buttonViewMyListDidTapped
{
    [self performSegueWithIdentifier:SpamListSegueIdentifier sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ReportSpamSMSSegueIdentifier]) {
        [self prepareSMSSpamReportViewControllerWithSegue:segue];
    } else if ([segue.identifier isEqualToString:ReportSpamWebSegueIdentifier]) {
        [self prepareWebSpamReportViewControllerWithSegue:segue];
    }
    else if ([segue.identifier isEqualToString:SpamListSegueIdentifier]) {
        [self prepareSpamListViewControllerWithSegue:segue];
    }
}

- (void)prepareSMSSpamReportViewControllerWithSegue:(UIStoryboardSegue *)segue
{
    SpamReportViewController *spamReportViewController = segue.destinationViewController;
    spamReportViewController.selectSpamReport = SpamReportTypeSMS;
}

- (void)prepareWebSpamReportViewControllerWithSegue:(UIStoryboardSegue *)segue
{
    SpamReportViewController *spamReportViewController = segue.destinationViewController;
    spamReportViewController.selectSpamReport = SpamReportTypeWeb;
}

- (void)prepareSpamListViewControllerWithSegue:(UIStoryboardSegue *)segue
{
    SpamListViewController *spamListViewController = segue.destinationViewController;
    __weak typeof(self) weakSelf = self;
    spamListViewController.shouldNavigateToSpamReport = ^() {
        [weakSelf performSegueWithIdentifier:ReportSpamSMSSegueIdentifier sender:weakSelf];
    };
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
