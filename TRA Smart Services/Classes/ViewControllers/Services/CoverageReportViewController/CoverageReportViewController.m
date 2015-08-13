//
//  CoverageReportViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "CoverageReportViewController.h"

@interface CoverageReportViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation CoverageReportViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Coverage Report";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [LocationManager sharedManager].delegate = self;
    [[LocationManager sharedManager] startUpdatingLocation];
    [AppHelper showLoader];
}

#pragma mark - LocationManagerDelegate

- (void)locationDidChangedTo:(CGFloat)longtitude lat:(CGFloat)latitude
{
    self.infoLabel.text = @"Fetching location";
    [self.activityIndicator startAnimating];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
    __weak typeof(self) weakSelf = self;
    [[LocationManager sharedManager] fetchAddressWithLocation:loc completionBlock:^(NSString *address) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.infoLabel.text = address;
            [weakSelf.activityIndicator stopAnimating];
        });
        [AppHelper hideLoader];
    }];
}

- (void)locationDidFailWithError:(NSError *)failError
{
    [AppHelper hideLoader];

}

@end
