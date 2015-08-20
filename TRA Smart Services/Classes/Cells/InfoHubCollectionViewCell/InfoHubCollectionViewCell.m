//
//  InfoHubCollectionViewCell.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InfoHubCollectionViewCell.h"

@interface InfoHubCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateEuropeUI;
@property (weak, nonatomic) IBOutlet UILabel *textEuropeUI;
@property (weak, nonatomic) IBOutlet UIImageView *imageEuropeUI;

@property (weak, nonatomic) IBOutlet UILabel *dateArabicUI;
@property (weak, nonatomic) IBOutlet UILabel *textArabicUI;
@property (weak, nonatomic) IBOutlet UIImageView *imageArabicUI;


@end

@implementation InfoHubCollectionViewCell

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
        return self.dateArabicUI;
    }
    return self.dateEuropeUI;
}

- (void)setDateLabel:(UILabel *)dateLabel
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        self.dateArabicUI = dateLabel;
    } else {
        self.dateEuropeUI = dateLabel;
    }
}

- (UILabel *)textLabel
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return self.textArabicUI;
    }
    return self.textEuropeUI;
}

- (void)setTextLabel:(UILabel *)textLabel
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        self.textArabicUI = textLabel;
    } else {
        self.textEuropeUI = textLabel;
    }
}

@end
