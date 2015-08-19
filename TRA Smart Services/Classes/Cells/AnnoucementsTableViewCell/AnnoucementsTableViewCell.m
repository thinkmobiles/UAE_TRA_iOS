//
//  AnnoucementsTableViewCell.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "AnnoucementsTableViewCell.h"

@interface AnnoucementsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageArabicUI;
@property (weak, nonatomic) IBOutlet UILabel *textAnnocementsArabicUI;
@property (weak, nonatomic) IBOutlet UILabel *dateArabicUI;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deltaConstraintArabicUI;

@property (weak, nonatomic) IBOutlet UIImageView *imageEuropeUI;
@property (weak, nonatomic) IBOutlet UILabel *textAnnocementsEuropeUI;
@property (weak, nonatomic) IBOutlet UILabel *dateEuropeUI;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deltaConstraintEuropeUI;

@end

@implementation AnnoucementsTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

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

- (UILabel *)textAnnocementsLabel
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return self.textAnnocementsArabicUI;
    }
    return self.textAnnocementsEuropeUI;
}

- (void)setTextAnnocementsLabel:(UILabel *)textAnnocementsLabel
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        self.textAnnocementsArabicUI = textAnnocementsLabel;
    } else {
        self.textAnnocementsEuropeUI = textAnnocementsLabel;
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

- (NSLayoutConstraint *)deltaConstraint
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return self.deltaConstraintArabicUI;
    }
    return self.deltaConstraintEuropeUI;
}

- (void)setDeltaConstraint:(NSLayoutConstraint *)deltaConstraint
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        self.deltaConstraintArabicUI = deltaConstraint;
    } else {
        self.deltaConstraintEuropeUI = deltaConstraint;
    }
}

@end
