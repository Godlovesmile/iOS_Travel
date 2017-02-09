//
//  CityCell.h
//  TravelApp
//
//  Created by SZT on 15/12/23.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface CityCell : UITableViewCell

@property(nonatomic,strong)UIImageView  *iconImage;

@property(nonatomic,strong)UILabel *cityName;

@property(nonatomic,retain)City  *city;

@end
