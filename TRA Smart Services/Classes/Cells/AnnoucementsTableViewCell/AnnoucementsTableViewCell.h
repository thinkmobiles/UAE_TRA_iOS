//
//  AnnoucementsTableViewCell.h
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnoucementsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *annocementsImage;
@property (strong, nonatomic) IBOutlet UILabel *annocementsText;
@property (strong, nonatomic) IBOutlet UILabel *annocementsDate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *deltaConstraint;

@end
