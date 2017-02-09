//
//  CityCell.m
//  TravelApp
//
//  Created by SZT on 15/12/23.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "CityCell.h"
//#import "MainScreenBound.h"

#define kCellWidth  kWidth
#define kCellHeight  200

#define kIconImageW  self.contentView.frame.size.width
#define kIconImageH  78
#define kIconImageX 0
#define kIconImageY 0

#define kCityNameW  80
#define kCityNameH  30
#define kCityNameX  (kIconImageW-kCityNameW)/2
#define kCityNameY  (kIconImageH-kCityNameH)/2


@implementation CityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //NSLog(@"width = %f",self.contentView.frame.size.width);
        self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
        [self.contentView addSubview:self.iconImage];
        
        //NSLog(@"kCityNameX = %f",kCityNameX);
        //NSLog(@"contentFrame = %@",NSStringFromCGRect(self.contentView.frame));
        //NSLog(@"iconImageFrame = %@",NSStringFromCGRect(self.iconImage.frame));
        self.cityName = [[UILabel alloc]initWithFrame:CGRectMake(18, 20, kCityNameW, kCityNameH)];
        //self.cityName.center = self.iconImage.center;
        self.cityName.font = [UIFont boldSystemFontOfSize:17];
        self.cityName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.cityName];
        //NSLog(@"cityName = %@",NSStringFromCGRect(self.cityName.frame));
    }
    return self;
}

//注意点:这儿用来布局自定义cell不同的属性值
- (void)setCity:(City *)city
{
    if (_city != city) {
        _city = city;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:city.cover]];
        self.cityName.text = city.name_zh;
        self.cityName.textColor = [UIColor redColor];
        //NSLog(@"text = %@",self.cityName.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
