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

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
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
    
    [self fillWithdemoData];
    
    RTLController *rtl = [[RTLController alloc] init];
    [rtl disableRTLForView:self.view];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    [self setTitleForDetailsScreen:dynamicLocalizedString(@"details.title")];
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

- (void)setTitleForDetailsScreen:(NSString *)title
{
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = title;
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

- (void)fillWithdemoData
{
    self.dateLabel.text = [AppHelper detailedDateStringFrom:[NSDate date]];
    self.screenTitleLabel.text = @"All Mobiles phone devices with a fraduent IMEI number  will caease to wotk wihint the";
    NSString *content = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \nDuis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. \nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. \nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in";

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = 24.f;
    style.alignment = [DynamicUIService service].language == LanguageTypeArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:content attributes:@{
                                                                                               NSFontAttributeName : [DynamicUIService service].language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:12.f] : [UIFont latoRegularWithSize:12.f],
                                                                                               NSParagraphStyleAttributeName : style} ];
    self.descriptionTextView.attributedText = text;

    self.sourceLabel.text = @"tra.gov.ae";
    self.authorLabel.text = @"Federal Authority";
    self.titleImageView.image = [UIImage imageNamed:@"demo"];
}

@end
