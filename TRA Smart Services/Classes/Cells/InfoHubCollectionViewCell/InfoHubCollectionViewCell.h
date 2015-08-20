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

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
