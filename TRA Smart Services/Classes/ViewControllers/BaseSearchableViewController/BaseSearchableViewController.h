//
//  BaseSearchableViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 17.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

@interface BaseSearchableViewController : BaseDynamicUIViewController <UISearchBarDelegate>

@property (strong, nonatomic) UILabel *searchanbeleViewControllerTitle;

- (void)localizeUI;

@end
