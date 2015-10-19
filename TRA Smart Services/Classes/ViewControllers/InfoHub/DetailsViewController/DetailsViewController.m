//
//  DetailsViewController.m
//  TRA Smart Services
//
//  Created by Admin on 18.08.15.
//

#import "DetailsViewController.h"
#import "RTLController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DetailsViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RTLController *rtl = [[RTLController alloc] init];
    [rtl disableRTLForView:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self dispalyInformations];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    [AppHelper titleFontForNavigationBar:self.navigationController.navigationBar];
    self.title = dynamicLocalizedString(@"details.title");
}

- (void)updateColors
{
    if (self.dynamicService.language == LanguageTypeArabic) {
        self.authorLabel.textColor = [UIColor lightGrayTextColor];
        self.sourceLabel.textColor = [self.dynamicService currentApplicationColor];
    } else {
        self.authorLabel.textColor = [self.dynamicService currentApplicationColor];
        self.sourceLabel.textColor = [UIColor lightGrayTextColor];
    }
    self.titleImageView.backgroundColor = [self.dynamicService currentApplicationColor];
}

- (void)setLTREuropeUI
{
    [self changeElementsAligment:NSTextAlignmentLeft];
    [self exchangeLabelsText];
}

- (void)setRTLArabicUI
{
    [self changeElementsAligment:NSTextAlignmentRight];
    [self exchangeLabelsText];
}

#pragma mark - Private

- (void)exchangeLabelsText
{
    NSString *buffer = self.authorLabel.text;
    self.authorLabel.text = self.sourceLabel.text;
    self.sourceLabel.text = buffer;
}

- (void)changeElementsAligment:(NSTextAlignment)textAlignment
{
    self.descriptionTextView.textAlignment = textAlignment;
    self.dateLabel.textAlignment = textAlignment;
    self.screenTitleLabel.textAlignment = textAlignment;
}

- (void)dispalyInformations
{
    self.dateLabel.text = self.titlaDate ? [AppHelper detailedDateStringFrom:self.titlaDate] : @"";
    self.screenTitleLabel.text = self.titleText.length ? self.titleText : @"All Mobiles phone devices with a fraduent IMEI number  will caease to wotk wihint the";
    NSString *content =  @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \nDuis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. \nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. \nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in";

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = 24.f;
    style.alignment = self.dynamicService.language == LanguageTypeArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:self.contentText.length ? [self.contentText string] : content attributes:@{
                                                                                               NSFontAttributeName : self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:12.f] : [UIFont latoRegularWithSize:12.f],
                                                                                               NSParagraphStyleAttributeName : style} ];
    self.descriptionTextView.attributedText = text;

    self.sourceLabel.text = self.sourceText;
    self.authorLabel.text = self.aboutText;
    UIImage *logo = self.logoImage ? self.logoImage : [UIImage imageNamed:@"demo"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        logo = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:logo];
    }

    self.titleImageView.image = logo;
}

@end