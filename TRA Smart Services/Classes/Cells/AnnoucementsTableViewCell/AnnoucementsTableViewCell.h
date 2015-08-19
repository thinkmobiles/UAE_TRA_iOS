//
//  AnnoucementsTableViewCell.h
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnoucementsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *conteinerEuropeUI;
@property (weak, nonatomic) IBOutlet UIView *conteinerArabicUI;

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *textAnnocementsLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *deltaConstraint;

@end
