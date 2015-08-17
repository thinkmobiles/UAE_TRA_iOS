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

@property (strong, nonatomic) CALayer *arcLayer;
@property (strong, nonatomic) CALayer *shadowDeleteButtonLayer;

@end

@implementation FavouriteViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addGestureRecognizer];
    
    self.dataSource = [ @[@"", @"sdfsdf", @"sdfsdf", @"sdfsdf"] mutableCopy];
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
    static NSIndexPath *itemToDeleteIndexPath;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (shouldProceedLongPress) {
                
                [self drawDeleteArea];
                
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
                    snapshotView.transform = CGAffineTransformMakeScale(0.95, 0.95);
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
                if ([self isCellInRemoveAreaWithCenter:center]) {
                    [self selectDeleteArea:YES];
                } else {
                    [self selectDeleteArea:NO];
                }
            }
            break;
        }
        default: {
            if (self.removeProcessIsActive) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
                cell.hidden = NO;
                cell.alpha = 0.0f;
                
                if ([self isCellInRemoveAreaWithCenter:snapshotView.center]) {
                    [self.dataSource removeObjectAtIndex:sourceIndexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[sourceIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    sourceIndexPath = nil;
                    [snapshotView removeFromSuperview];
                    snapshotView = nil;
                } else {
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
                [self removeDeleteArea];
            }
            break;
        }
    }
}

- (BOOL)isCellInRemoveAreaWithCenter:(CGPoint)center
{
    BOOL isInRemoveArea = NO;
    
    CGFloat heightOFDeleteRect = [UIScreen mainScreen].bounds.size.height * 0.185f;
    CGFloat startY = self.tableView.bounds.size.height - heightOFDeleteRect;
    if (center.y > startY) {
        isInRemoveArea = YES;
    }
    return isInRemoveArea;
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

#pragma mark - Drawings

- (void)drawDeleteArea
{
    self.arcLayer = [CALayer layer];
    self.arcLayer.frame = self.tableView.bounds;
    self.arcLayer.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3f].CGColor;
    self.arcLayer.masksToBounds = YES;
    
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    
    CGFloat heightOfScreen = [UIScreen mainScreen].bounds.size.height;
    CGFloat startY = heightOfScreen - heightOfScreen * 0.165 - ((UITabBarController *)[AppHelper rootViewController]).tabBar.frame.size.height;
    
    CGFloat arcHeight = 35.f;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat arcRadius = arcHeight / 2 + (width * width)/ (8 * arcHeight);
    
    [bezier moveToPoint:CGPointMake(0, startY)];
    [bezier addArcWithCenter:CGPointMake(width / 2, startY + arcRadius - heightOfScreen * 0.165) radius:arcRadius startAngle:0 endAngle:180 clockwise:YES];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.arcLayer.bounds;
    maskLayer.path = bezier.CGPath;
    maskLayer.shouldRasterize = YES;
    maskLayer.rasterizationScale = [UIScreen mainScreen].scale * 2.;
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    self.arcLayer.mask = maskLayer;
    
    CALayer *contentLayer = [CALayer layer];
    CGFloat contentHeight = 50.f;
    CGFloat contentWidth = 44.f;
    contentLayer.backgroundColor = [UIColor redColor].CGColor;
    CGRect contentLayerRect = CGRectMake(width / 2 - contentWidth / 2, startY - (heightOfScreen * 0.165) / 2 , contentWidth, contentHeight);
    contentLayer.frame = contentLayerRect;
    
    CGRect centerRect = CGRectMake(contentLayerRect.size.width * 0.25, contentLayerRect.size.height * 0.25, contentLayerRect.size.width * 0.5, contentLayerRect.size.height * 0.5);
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = centerRect;
    imageLayer.backgroundColor = [UIColor clearColor].CGColor;
    imageLayer.contents =(__bridge id __nullable)([UIImage imageNamed:@"garbagecan12"]).CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    
    [contentLayer addSublayer:imageLayer];
    
    CAShapeLayer *hexMaskLayer = [CAShapeLayer layer];
    hexMaskLayer.frame = contentLayer.bounds;
    hexMaskLayer.path = [AppHelper hexagonPathForRect:contentLayer.bounds].CGPath;
    contentLayer.mask = hexMaskLayer;
    
    CGFloat shadowOffset = 5.f;
    CGRect shadowRect = CGRectMake(contentLayerRect.origin.x - shadowOffset, contentLayerRect.origin.y - shadowOffset, contentLayerRect.size.width + shadowOffset * 2, contentLayerRect.size.height + shadowOffset * 2);
    self.shadowDeleteButtonLayer = [CALayer layer];
    self.shadowDeleteButtonLayer.frame = shadowRect;
    [self.shadowDeleteButtonLayer setShadowPath:[AppHelper hexagonPathForRect:self.shadowDeleteButtonLayer.bounds].CGPath];
    [self.shadowDeleteButtonLayer setShadowOffset:CGSizeMake(0, 0)];
    [self.shadowDeleteButtonLayer setShadowRadius:5.f];
    [self.shadowDeleteButtonLayer setShadowOpacity:0.2f];
    
    [self.arcLayer addSublayer:contentLayer];
    [self.arcLayer insertSublayer:self.shadowDeleteButtonLayer below:contentLayer];

    [self.tableView.layer addSublayer:self.arcLayer];

    
    
    CGPoint endPoint = self.arcLayer.position;
    self.arcLayer.position = CGPointMake(self.arcLayer.position.x, self.arcLayer.position.y + self.arcLayer.bounds.size.height / 2);
    CABasicAnimation *positionAmimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAmimation.fromValue = [NSValue valueWithCGPoint:self.arcLayer.position ];
    positionAmimation.toValue = [NSValue valueWithCGPoint:endPoint];
    positionAmimation.duration = 0.15;
    
    
    CGPoint endValueForDeleteIcon = self.shadowDeleteButtonLayer.position;
    CGPoint startPoint = CGPointMake(self.arcLayer.position.x, self.arcLayer.position.y + self.arcLayer.bounds.size.height);
    CGPoint midPoint = CGPointMake(endValueForDeleteIcon.x, endValueForDeleteIcon.y - 40);

    self.shadowDeleteButtonLayer.position = startPoint;
    contentLayer.position = startPoint;
    
    CAKeyframeAnimation * springAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    springAnim.values = @[
                          [NSValue valueWithCGPoint:startPoint],
                          [NSValue valueWithCGPoint:midPoint],
                          [NSValue valueWithCGPoint:endValueForDeleteIcon]
                          ];
    springAnim.duration = 0.3f;
    springAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.arcLayer addAnimation:positionAmimation forKey:nil];
    self.arcLayer.position = endPoint;
    
    [self.shadowDeleteButtonLayer addAnimation:springAnim forKey:nil];
    [contentLayer addAnimation:springAnim forKey:nil];
    self.shadowDeleteButtonLayer.position = endValueForDeleteIcon;
    contentLayer.position = endValueForDeleteIcon;
}

- (void)removeDeleteArea
{
    [self.arcLayer removeFromSuperlayer];
    [self.shadowDeleteButtonLayer removeFromSuperlayer];
}

- (void)selectDeleteArea:(BOOL)select
{
    self.shadowDeleteButtonLayer.shadowOpacity = select ? 0.02f : 0.2f;
    self.arcLayer.backgroundColor = select ? [[UIColor redColor] colorWithAlphaComponent:0.7f].CGColor : [[UIColor redColor] colorWithAlphaComponent:0.3f].CGColor;
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
