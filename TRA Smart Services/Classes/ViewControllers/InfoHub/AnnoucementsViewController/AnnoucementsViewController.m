//
//  AnnoucementsViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "AnnoucementsViewController.h"
#import "AnnoucementsTableViewCell.h"
#import "DetailsViewController.h"

@interface AnnoucementsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *filteredDataSource;

@end

static NSString *const SegueToDetailsViewControllerIdentifier = @"segueToDetailsViewController";
static CGFloat const AdditionalCellOffset = 20.0f;
static CGFloat const DefaultCellOffset = 24.0f;

@implementation AnnoucementsViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNibs];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnoucementsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[self cellUIIdentifier]];
    if (indexPath.row % 2) {
        cell.marginAnnouncementContainerConstraint.constant = DefaultCellOffset + AdditionalCellOffset;
    } else {
        cell.marginAnnouncementContainerConstraint.constant = DefaultCellOffset;
    }
    
    if (self.dynamicService.language == LanguageTypeArabic) {
        cell.annocementsDescriptionLabel.text = @"الخيل والليل والبيداء تعرفني والسيف والرمح والقرطاس و القلمصحبت في الفلوات الوحش منفردا حتى تعجب مني القور و الأكم        يا من يعز علينا ان نفارقهم وجداننا كل شيء بعدكم عدم ما كان أخلقنا منكم بتكرمة لو ان أمركم من أمرنا أمم إن كان سركم ما قال حاسدنا فما لجرح إذا أرضاكم ألم و بيننا لو رعيتم ذاك معرفة غن المعارف في اهل النهى ذمم";
        cell.annocementsDateLabel.text = @"قصيدة ابو الطيب المتنبي";
    } else {
        cell.annocementsDescriptionLabel.text = @"Regarding annoucement the start of a public consultations with all concerdned parties";
        cell.annocementsDateLabel.text = @"08/03/15";
    }
    
    UIImage *logo = [UIImage imageNamed:@"test"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        logo = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:logo];
    }
    cell.annoucementLogoImage = logo;
    cell.annocementsDescriptionLabel.tag = DeclineTagForFontUpdate;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self performSegueWithIdentifier:SegueToDetailsViewControllerIdentifier sender:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", searchText];
        NSArray *arraySort = [self.dataSource filteredArrayUsingPredicate:predicate];
        self.filteredDataSource = [[NSMutableArray alloc] initWithArray:arraySort];
    } else {
        self.filteredDataSource = [[NSMutableArray alloc] initWithArray:self.dataSource];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    [super localizeUI];
    
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"annoucements.title");
}

- (void)updateColors
{
    UIImage *backgroundImage = [UIImage imageNamed:@"fav_back_orange"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImageView.image = backgroundImage;
}

#pragma mark - Private

- (NSString *)cellUIIdentifier
{
    if (self.dynamicService.language == LanguageTypeArabic ) {
        return AnnoucementsTableViewCellArabicIdentifier;
    }
    return AnnoucementsTableViewCellEuropeIdentifier;
}

- (void)registerNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"AnnoucementsTableViewCellEuropeUI" bundle:nil] forCellReuseIdentifier:AnnoucementsTableViewCellEuropeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AnnoucementsTableViewCellArabicUI" bundle:nil] forCellReuseIdentifier:AnnoucementsTableViewCellArabicIdentifier];
}

@end
