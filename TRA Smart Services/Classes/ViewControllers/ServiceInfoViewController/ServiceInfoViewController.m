//
//  ServiceInfoViewController.m
//  TRA Smart Services
//
//  Created by Admin on 18.08.15.
//

#import "ServiceInfoViewController.h"
#import "ServiceInfoCollectionViewCell.h"
#import "Animation.h"
#import "ServiceDetailedInfoViewController.h"

static NSUInteger const RowCount = 2;
static NSUInteger const ColumsCount = 5;

static NSString *const ServiceDetailsSegueIdentifier = @"serviceDetailsSegue";

@interface ServiceInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *fakeBackgroundImageView;

@property (strong, nonatomic) NSArray *dataSource;
@property (assign, nonatomic) BOOL isControllerPresented;

@property (strong, nonatomic) NSDictionary *currentServiceLocalizedDataSource;

@end

@implementation ServiceInfoViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.fakeBackground) {
        self.fakeBackgroundImageView.image = self.fakeBackground;
    }
    [self prepareDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reverseDataSourceIfNeeded];
    [self animateAppearence];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:ServiceDetailsSegueIdentifier sender:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ServiceInfoCollectionViewCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[ServiceInfoCollectionViewCell alloc] init];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat originY = self.collectionView.frame.origin.y;
    CGFloat collectionViewHeight = screenSize.height - originY;
    CGFloat collectionViewWidth = screenSize.width;
    CGFloat numbersOfRow = ColumsCount;
    CGFloat numbersOfColums = RowCount;
    CGFloat minimumSpacing = 10;
    CGFloat cellWidth = (collectionViewWidth - minimumSpacing * numbersOfColums) / numbersOfColums;
    CGFloat cellHeight = collectionViewHeight / numbersOfRow;
    
    if (self.dataSource.count % 2 && indexPath.row == self.dataSource.count - 1) {
        cellWidth = collectionViewWidth;
    }
    
    CGSize cellSize = CGSizeMake(cellWidth, cellHeight);
    return cellSize;
}

#pragma mark - IbActions

- (IBAction)closeButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Animations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ServiceDetailsSegueIdentifier]) {
        NSDictionary *dataSource = self.dataSource[((NSIndexPath *)[[self.collectionView indexPathsForSelectedItems] firstObject]).row];
        NSString *detailsText = [self.currentServiceLocalizedDataSource valueForKey:[dataSource valueForKey:@"serviceResponseKey"]];
        
        ServiceDetailedInfoViewController *serviceInfoController = segue.destinationViewController;
        serviceInfoController.fakeBackground = [AppHelper snapshotForView:self.navigationController.view];
        serviceInfoController.hidesBottomBarWhenPushed = YES;
        serviceInfoController.dataSource = dataSource;
        serviceInfoController.detailedInfoText = detailsText;
    }
}

#pragma mark - Superclass

- (void)localizeUI
{
    [self.collectionView reloadData];
}

- (void)updateColors
{
    self.backgroundView.backgroundColor = [[self.dynamicService currentApplicationColor] colorWithAlphaComponent:0.9f];
}

#pragma mark - Private

- (void)configureCell:(ServiceInfoCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedElement = self.dataSource[indexPath.row];
    cell.serviceInfoTitleLabel.text = dynamicLocalizedString([selectedElement valueForKey:@"serviceInfoItemName"]);
    cell.serviceInfologoImageView.image = [UIImage imageNamed:[selectedElement valueForKey:@"serviceInfoItemLogoName"]];
}

- (void)reverseDataSourceIfNeeded
{
    self.dataSource = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceInfoList" ofType:@"plist"]];
    if (self.dynamicService.language == LanguageTypeArabic) {
        self.dataSource = [self.dataSource reversedArrayByElementsInGroup:RowCount];
    }
}

- (void)animateAppearence
{
    if (!self.isControllerPresented) {
        [self.backgroundView.layer addAnimation:[Animation fadeAnimFromValue:0 to:1 delegate:nil] forKey:nil];
        self.isControllerPresented = YES;
    } else {
        [self.collectionView reloadData];
    }
}

- (void)prepareDataSource
{
    [AppHelper showLoader];
    NSString *languageCode = self.dynamicService.language == LanguageTypeArabic ? @"AR" : @"EN";
    NSString *serviceRequestName = [self serviceNameForCurrentService];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] traSSNoCRMServiceGetServiceAboutInfo:serviceRequestName languageCode:languageCode responseBlock:^(id response, NSError *error) {
        if (error) {
            [response isKindOfClass:[NSString class]] ? [AppHelper alertViewWithMessage:response] : [AppHelper alertViewWithMessage:error.localizedDescription];
        } else {
            weakSelf.currentServiceLocalizedDataSource = response;
        }
        [AppHelper hideLoader];
    }];    
}

- (NSString *)serviceNameForCurrentService
{
    NSString *serviceNameForRequest;
    switch (self.selectedServiceID) {
        case ServiceTypeGetDomainData: {
            serviceNameForRequest = ServiceTypeGetDomainDataStringName;
            break;
        }
        case ServiceTypeGetDomainAvaliability: {
            serviceNameForRequest = ServiceTypeGetDomainAvaliabilityStringName;
            break;
        }
        case ServiceTypeSearchMobileIMEI: {
            serviceNameForRequest = ServiceTypeSearchMobileIMEIStringName;
            break;
        }
        case ServiceTypeSearchMobileBrand: {
            serviceNameForRequest = ServiceTypeSearchMobileBrandStringName;
            break;
        }
        case ServiceTypeFeedback: {
            serviceNameForRequest = ServiceTypeFeedbackStringName;
            break;
        }
        case ServiceTypeSMSSpamReport: {
            serviceNameForRequest = ServiceTypeSMSSpamReportStringName;
            break;
        }
        case ServiceTypeHelpSalim: {
            serviceNameForRequest = ServiceTypeHelpSalimStringName;
            break;
        }
        case ServiceTypeVerification: {
            serviceNameForRequest = ServiceTypeVerificationStringName;
            break;
        }
        case ServiceTypeCoverage: {
            serviceNameForRequest = ServiceTypeCoverageStringName;
            break;
        }
        case ServiceTypeInternetSpeedTest: {
            serviceNameForRequest = ServiceTypeInternetSpeedTestStringName;
            break;
        }
        case ServiceTypeCompliantAboutServiceProvider: {
            serviceNameForRequest = ServiceTypeCompliantAboutServiceProviderTRAStringName;
            break;
        }
        case ServiceTypeSuggestion: {
            serviceNameForRequest = ServiceTypeSuggestionStringName;
            break;
        }
        case ServiceTypeCompliantAboutServiceProviderEnquires: {
            serviceNameForRequest = ServiceTypeCompliantAboutServiceProviderEnquiresStringName;
            break;
        }
        case ServiceTypeCompliantAboutServiceProviderTRA: {
            serviceNameForRequest = ServiceTypeCompliantAboutServiceProviderTRAStringName;
            break;
        }
    }
    return serviceNameForRequest;
}

@end
