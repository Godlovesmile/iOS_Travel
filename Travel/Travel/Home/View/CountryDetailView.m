//
//  CountryDetailView.m
//  Travel
//
//  Created by Alice on 16/4/20.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "CountryDetailView.h"

@implementation CountryDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.iconImage = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        self.iconImage.layer.cornerRadius = 30;
        self.iconImage.layer.masksToBounds = YES;
        self.iconImage.backgroundColor = [UIColor lightGrayColor];
        //self.iconImage.
        [self.contentView addSubview:self.iconImage];
        
        //NSLog(@"self.frame = %@",NSStringFromCGRect(self.contentView.frame));
        CGFloat width = self.contentView.frame.size.width;
        CGFloat cityNameY = self.contentView.frame.size.height - 20;
        self.cityName = [[UILabel alloc] initWithFrame:CGRectMake(0, cityNameY, width, 20)];
        self.cityName.font = [UIFont boldSystemFontOfSize:12];
        self.cityName.textColor = [UIColor whiteColor];
        self.cityName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.cityName];
    }
    return self;
}

- (void)setTourist:(TouristAttraction *)tourist {
    
    _tourist = tourist;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:tourist.cover]];
    self.cityName.text = tourist.name;
}

@end
