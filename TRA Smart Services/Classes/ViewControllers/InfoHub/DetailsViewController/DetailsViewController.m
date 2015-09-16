//
//  DetailsViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
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
    [self setPrepareTitleLabel:dynamicLocalizedString(@"details.title")];
}

- (void)updateColors
{
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        self.authorLabel.textColor = [UIColor lightGrayTextColor];
        self.sourceLabel.textColor = [[DynamicUIService service] currentApplicationColor];
    } else {
        self.authorLabel.textColor = [[DynamicUIService service] currentApplicationColor];
        self.sourceLabel.textColor = [UIColor lightGrayTextColor];
    }
    
    self.titleImageView.backgroundColor = [[DynamicUIService service] currentApplicationColor];
}

- (void)setLTREuropeUI
{
    self.descriptionTextView.textAlignment = NSTextAlignmentLeft;
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    self.screenTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self exchangeLabelsText];
}

- (void)setRTLArabicUI
{
    self.descriptionTextView.textAlignment = NSTextAlignmentRight;
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.screenTitleLabel.textAlignment = NSTextAlignmentRight;
    
    [self exchangeLabelsText];
}

- (void)exchangeLabelsText
{
    NSString *buffer = self.authorLabel.text;
    self.authorLabel.text = self.sourceLabel.text;
    self.sourceLabel.text = buffer;
}

#pragma mark - Private

- (void)setPrepareTitleLabel:(NSString *)title
{
    UILabel *titleView = [[UILabel alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = title;
    titleView.textAlignment = NSTextAlignmentCenter;
    
    titleView.font = [DynamicUIService service].language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:14.f] : [UIFont latoRegularWithSize:14.f];
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

- (void)dispalyInformations
{
    self.dateLabel.text = self.titlaDate ? [AppHelper detailedDateStringFrom:self.titlaDate] : @"";
    self.screenTitleLabel.text = self.titleText.length ? self.titleText : @"All Mobiles phone devices with a fraduent IMEI number  will caease to wotk wihint the";
    NSString *content =  @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \nDuis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. \nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. \nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in";

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = 24.f;
    style.alignment = [DynamicUIService service].language == LanguageTypeArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:self.contentText.length ? [self.contentText string] : content attributes:@{
                                                                                               NSFontAttributeName : [DynamicUIService service].language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:12.f] : [UIFont latoRegularWithSize:12.f],
                                                                                               NSParagraphStyleAttributeName : style} ];
    self.descriptionTextView.attributedText = text;

    self.sourceLabel.text = self.sourceText;
    self.authorLabel.text = self.aboutText;
    UIImage *logo = self.logoImage ? self.logoImage : [UIImage imageNamed:@"demo"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        logo = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:logo];
    }

    self.titleImageView.image = logo;
}

@end
