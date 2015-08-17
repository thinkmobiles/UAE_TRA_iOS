//
//  FavouriteViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "FavouriteViewController.h"
#import "FavouriteTableViewCell.h"
#import "Animation.h"

@interface FavouriteViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *placeHolderView;
@property (weak, nonatomic) IBOutlet UIButton *addFavouriteButton;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) BOOL removeProcessIsActive;

@end

@implementation FavouriteViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addGestureRecognizer];
    
    self.dataSource = [ @[@"", @"sdfsdf"] mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareAddFavouriteButton];
}

#pragma mark - IBActions

- (IBAction)addFavouriteButtonPress:(id)sender
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavouriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FavouriteEuropianTableViewCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[FavouriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FavouriteEuropianTableViewCellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ?;
}
- (void)configureCell:(FavouriteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = indexPath.row % 2 ? [UIColor redColor] : [UIColor greenColor];
    cell.logoImage = [UIImage imageNamed:@"tempImage"];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"text - %@", searchText);
}

#pragma mark - Private

#pragma mark - GestureRecognizer

- (void)addGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapGesture:)];
    [self.tableView addGestureRecognizer:longPressGesture];
}

- (void)longTapGesture:(UILongPressGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    FavouriteTableViewCell *selectedCell = (FavouriteTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    CGPoint locationInCell = [self.tableView convertPoint:location toView:selectedCell.contentView];
    
    CGRect longPressAcceptableRect = selectedCell.removeButton.frame;
    BOOL shouldProceedLongPress = CGRectContainsPoint(longPressAcceptableRect, locationInCell);
    
    static UIView *snapshotView;
    static NSIndexPath *sourceIndexPath;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (shouldProceedLongPress) {
                self.removeProcessIsActive = YES;
                sourceIndexPath = indexPath;
                snapshotView = [selectedCell snapshot];
                
                __block CGPoint center = selectedCell.center;
                snapshotView.center = center;
                snapshotView.alpha = 0.f;
                [self.tableView addSubview:snapshotView];
                
                [UIView animateWithDuration:0.25f animations:^{
                    center.y = location.y;
                    snapshotView.center = center;
                    snapshotView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshotView.alpha = 0.98f;
                    selectedCell.alpha = 0.0;
                } completion:^(BOOL finished) {
                    selectedCell.hidden = YES;
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (self.removeProcessIsActive) {
                CGPoint center = snapshotView.center;
                center.y = location.y;
                snapshotView.center = center;
                
                if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                    [self.dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                    [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    sourceIndexPath = indexPath;
                }
            }
            break;
        }
        default: {
            if (self.removeProcessIsActive) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
                cell.hidden = NO;
                cell.alpha = 0.0f;
                
                [UIView animateWithDuration:0.25 animations:^{
                    snapshotView.center = cell.center;
                    snapshotView.transform = CGAffineTransformIdentity;
                    snapshotView.alpha = 0.0f;
                    cell.alpha = 1.0;
                } completion:^(BOOL finished) {
                    sourceIndexPath = nil;
                    [snapshotView removeFromSuperview];
                    snapshotView = nil;
                }];
                self.removeProcessIsActive = NO;
            }
            break;
        }
    }
}

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
