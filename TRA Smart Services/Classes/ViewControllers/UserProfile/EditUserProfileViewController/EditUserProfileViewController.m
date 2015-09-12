//
//  EditUserProfileViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 10.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "EditUserProfileViewController.h"
#import "ServicesSelectTableViewCell.h"
#import "KeychainStorage.h"
#import "TextFieldNavigator.h"

static CGFloat const DefaultHeightForTableView = 26.f;

@interface EditUserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *emiratesLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetAddressLabel;

@property (weak, nonatomic) IBOutlet UIButton *changePhotoButton;

@property (weak, nonatomic) IBOutlet UITextField *firstNmaeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetAddressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *contactNumberTextfield;

@property (weak, nonatomic) IBOutlet UserProfileActionView *userActionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (strong, nonatomic) NSArray *dataSource;
@property (assign, nonatomic) CGPoint textFieldTouchPoint;
@property (strong, nonatomic) NSString *selectedEmirate;

@property (strong, nonatomic) ServicesSelectTableViewCell *headerCell;

@end

@implementation EditUserProfileViewController

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"userProfile.title");

    self.emiratesLabel.text = dynamicLocalizedString(@"editUserProfileViewController.emiratesLabel");
    self.contactNumberLabel.text = dynamicLocalizedString(@"editUserProfileViewController.contactnumberLabel");
    self.firstNameLabel.text = dynamicLocalizedString(@"editUserProfileViewController.firstNameLabel");
    self.lastNameLabel.text = dynamicLocalizedString(@"editUserProfileViewController.lastNameLabel");
    self.streetAddressLabel.text = dynamicLocalizedString(@"editUserProfileViewController.streetAddressLabel");
    [self.changePhotoButton setTitle:dynamicLocalizedString(@"editUserProfileViewController.changePhotoButtonTitle") forState:UIControlStateNormal];
    
    [self prepareDataSource];
    [self.tableView reloadData];
}

- (void)updateColors
{
    UIImage *backgroundImage = [UIImage imageNamed:@"fav_back_orange"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImageView.image = backgroundImage;
    [self addHexagonBorderForLayer:self.logoImageView.layer color:[UIColor whiteColor]];
}

- (void)setRTLArabicUI
{
    [self updateUIaligment:NSTextAlignmentRight];

    [self.userActionView setRTLStyle];
}

- (void)setLTREuropeUI
{
    [self updateUIaligment:NSTextAlignmentLeft];
    
    [self.userActionView setLTRStyle];
}

#pragma mark - Private

- (void)updateUIaligment:(NSTextAlignment)aligment
{
    self.emiratesLabel.textAlignment = aligment;
    self.contactNumberLabel.textAlignment = aligment;
    self.firstNameLabel.textAlignment = aligment;
    self.lastNameLabel.textAlignment = aligment;
    self.streetAddressLabel.textAlignment = aligment;
    self.firstNmaeTextfield.textAlignment = aligment;
    self.lastNameTextField.textAlignment = aligment;
    self.streetAddressTextfield.textAlignment = aligment;
    self.contactNumberTextfield.textAlignment = aligment;
}

- (void)prepareDataSource
{
    self.dataSource = @[
                        dynamicLocalizedString(@"editUserProfileViewController.dataSource.0element"),
                        dynamicLocalizedString(@"state.Abu.Dhabi"),
                        dynamicLocalizedString(@"state.Ajman"),
                        dynamicLocalizedString(@"state.Dubai"),
                        dynamicLocalizedString(@"state.Fujairah"),
                        dynamicLocalizedString(@"state.Ras"),
                        dynamicLocalizedString(@"state.Sharjan"),
                        dynamicLocalizedString(@"state.Quwain")
                        ];
}

- (void)prepareUI
{
    self.userActionView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.logoImageView.image = [UIImage imageNamed:@"test"];
    [self addHexagoneOnView:self.logoImageView];
}

- (void)fillData
{
    self.firstNmaeTextfield.text = [KeychainStorage userName];
}

#pragma mark - Drawing

- (void)addHexagoneOnView:(UIView *)view
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.layer.bounds;
    maskLayer.path = [AppHelper hexagonPathForView:view].CGPath;
    view.layer.mask = maskLayer;
}

- (void)addHexagonBorderForLayer:(CALayer *)layer color:(UIColor *)color
{
    CAShapeLayer *borderlayer = [CAShapeLayer layer];
    borderlayer.fillColor = [UIColor clearColor].CGColor;
    borderlayer.strokeColor = color ? color.CGColor : [[DynamicUIService service] currentApplicationColor].CGColor;
    borderlayer.lineWidth = 3.f;
    borderlayer.frame = layer.bounds;
    borderlayer.path = [AppHelper hexagonPathForRect:layer.bounds].CGPath;
    
    [layer addSublayer:borderlayer];
}

@end