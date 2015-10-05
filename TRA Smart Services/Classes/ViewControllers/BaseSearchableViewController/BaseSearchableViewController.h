//
//  BaseSearchableViewController.h
//  TRA Smart Services
//
//  Created by Admin on 17.08.15.
//

@interface BaseSearchableViewController : BaseDynamicUIViewController <UISearchBarDelegate>

@property (strong, nonatomic) UILabel *searchanbeleViewControllerTitle;

- (void)localizeUI;
- (BOOL)isSearchBarActive;

@end
