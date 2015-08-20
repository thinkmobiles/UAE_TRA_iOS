//
//  InfoHubTableViewCell.h
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoHubTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *textInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleInfoLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deltaConsrtraintEuropeUI;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deltaConsrtraintArabicUI;
@property (weak, nonatomic) IBOutlet UIView *conteinerEuropeUI;
@property (weak, nonatomic) IBOutlet UIView *conteinerArabicUI;

@end
