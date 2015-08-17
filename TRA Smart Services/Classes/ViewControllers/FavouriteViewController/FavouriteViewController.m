//
//  FavouriteViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "FavouriteViewController.h"
#import "Animation.h"

@interface FavouriteViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addFavouriteButton;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@end

@implementation FavouriteViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareAddFavouriteButton];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"text - %@", searchText);
}

#pragma mark - IBActions

- (IBAction)addFavouriteButtonPress:(id)sender
{
    
}

#pragma mark - Private

#pragma mark - UI

- (void)prepareAddFavouriteButton
{
    CGSize buttonSize = self.addFavouriteButton.frame.size;
    NSString *buttonTitle = dynamicLocalizedString(@"favourite.button.addFav.title");
    CGSize titleSize = [buttonTitle sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:12.f] }];
    UIImage *buttonImage = self.addFavouriteButton.imageView.image;
    CGSize buttonImageSize = buttonImage.size;
    
    CGFloat offsetBetweenImageAndText = 10; //vertical space between image and text
    
    [self.addFavouriteButton setImageEdgeInsets:UIEdgeInsetsMake((buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 - offsetBetweenImageAndText,
                                                (buttonSize.width - buttonImageSize.width) / 2,
                                                0,0)];
    [self.addFavouriteButton setTitleEdgeInsets:UIEdgeInsetsMake((buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 + buttonImageSize.height + offsetBetweenImageAndText,
                                                titleSize.width + [self.addFavouriteButton imageEdgeInsets].left > buttonSize.width ? -buttonImage.size.width  +  (buttonSize.width - titleSize.width) / 2 : (buttonSize.width - titleSize.width) / 2 - buttonImage.size.width,
                                                0,0)];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"favourite.title");
    [self.addFavouriteButton setTitle: dynamicLocalizedString(@"favourite.button.addFav.title") forState:UIControlStateNormal];
    self.informationLabel.text = dynamicLocalizedString(@"favourite.notification");
}

- (void)updateColors
{
    
}

@end
