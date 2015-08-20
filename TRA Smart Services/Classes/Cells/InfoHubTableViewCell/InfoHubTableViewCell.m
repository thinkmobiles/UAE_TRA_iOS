//
//  InfoHubTableViewCell.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InfoHubTableViewCell.h"

@interface InfoHubTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageEuropeUI;
@property (weak, nonatomic) IBOutlet UILabel *textInfoEuropeUI;
@property (weak, nonatomic) IBOutlet UILabel *dateInfoEuropeUI;
@property (weak, nonatomic) IBOutlet UILabel *titleInfoEuropeUI;

@property (weak, nonatomic) IBOutlet UIImageView *imageArabicUI;
@property (weak, nonatomic) IBOutlet UILabel *textInfoArabicUI;
@property (weak, nonatomic) IBOutlet UILabel *dateInfoArabicUI;
@property (weak, nonatomic) IBOutlet UILabel *titleInfoArabicUI;

@end

@implementation InfoHubTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma Set Get Methods

- (UIImageView *)image
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return self.imageArabicUI;
    }
    return self.imageEuropeUI;
}

- (void)setImage:(UIImageView *)image
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        self.imageArabicUI = image;
    } else {
        self.imageEuropeUI = image;
    }
}

- (UILabel *)dateLabel
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return self.dateInfoArabicUI;
    }
    return self.dateInfoEuropeUI;
}

- (void)setDateLabel:(UILabel *)dateLabel
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        self.dateInfoArabicUI = dateLabel;
    } else {
        self.dateInfoEuropeUI = dateLabel;
    }
}

- (UILabel *)textInfoLabel
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return self.textInfoArabicUI;
    }
    return self.textInfoEuropeUI;
}

- (void)setTextInfoLabel:(UILabel *)textLabel
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        self.textInfoArabicUI = textLabel;
    } else {
        self.textInfoEuropeUI = textLabel;
    }
}

- (UILabel *)titleInfoLabel
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return self.titleInfoArabicUI;
    }
    return self.titleInfoEuropeUI;
}

- (void)setTitleInfoLabel:(UILabel *)titleLabel
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        self.titleInfoArabicUI = titleLabel;
    } else {
        self.titleInfoEuropeUI = titleLabel;
    }
}

@end
