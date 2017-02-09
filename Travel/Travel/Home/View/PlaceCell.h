//
//  PlaceCell.h
//  Travel
//
//  Created by Alice on 16/5/13.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlaceModel.h"

@interface PlaceCell : UITableViewCell

@property (nonatomic,strong) PlaceModel *placeModel;

@property (nonatomic,strong) UILabel *countryLabel;

@property (nonatomic,strong) UILabel *provinceLabel;

@end
