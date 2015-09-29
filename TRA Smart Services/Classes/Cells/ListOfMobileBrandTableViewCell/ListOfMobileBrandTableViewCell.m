//
//  ListOfMobileBrandTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 29.09.15.
//

#import "ListOfMobileBrandTableViewCell.h"

@implementation ListOfMobileBrandTableViewCell

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self prepareHexagonLayer];
}

#pragma mark - Private

- (void)prepareHexagonLayer
{
  //  [AppHelper addHexagonBorderForLayer:self. View.layer color:[[DynamicUIService service] currentApplicationColor] width:1.0f];
}

@end
