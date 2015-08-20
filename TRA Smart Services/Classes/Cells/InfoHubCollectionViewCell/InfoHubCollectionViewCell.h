//
//  InfoHubCollectionViewCell.h
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoHubCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *conteinerArabicUI;
@property (weak, nonatomic) IBOutlet UIView *conteinerEuropeUI;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end
