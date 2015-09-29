//
//  ListOfMobileBrandTableViewCell.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 29.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
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
