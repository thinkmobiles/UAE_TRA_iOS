//
//  DetailsViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *detailsText;
@property (weak, nonatomic) IBOutlet UILabel *detailsTitleDate;
@property (weak, nonatomic) IBOutlet UILabel *detailsTitleText;

@end

@implementation DetailsViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self sourceDatail];
}

#pragma mark - Private

- (void)setTitleNavigationBar:(NSString *)title
{
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = title;
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

- (void) sourceDatail
{
    self.detailsText.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation t et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in";
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    [self setTitleNavigationBar:dynamicLocalizedString(@"details.title")];
}

- (void)updateColors
{
    
}

- (void)setLTREuropeUI
{
    self.detailsText.textAlignment = NSTextAlignmentLeft;
    self.detailsTitleDate.textAlignment = NSTextAlignmentLeft;
    self.detailsTitleText.textAlignment = NSTextAlignmentLeft;
}

- (void)setRTLArabicUI
{
    self.detailsText.textAlignment = NSTextAlignmentRight;
    self.detailsTitleDate.textAlignment = NSTextAlignmentRight;
    self.detailsTitleText.textAlignment = NSTextAlignmentRight;
}

@end
