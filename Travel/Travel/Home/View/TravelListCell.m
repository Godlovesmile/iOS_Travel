//
//  TravelListCell.m
//  Travel
//
//  Created by Alice on 16/5/13.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "TravelListCell.h"

@implementation TravelListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kCellBackGroundColor;
        
    }
    return self;
    
}

//设置推荐旅游产品
- (void)setRecommendProductsWithImageModel:(TravelListModel *)model {
    
    [self cellRemoveSubViews];
    UIImageView *backImageView = [self setCellImageView];
    [backImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    
    UIView *blackView = [[UIView alloc] initWithFrame:backImageView.frame];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.2;
    blackView.layer.masksToBounds = YES;
    blackView.layer.cornerRadius = 10;
    [self.contentView addSubview:blackView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    textLabel.center = backImageView.center;
    textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:26];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor whiteColor];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    CGPoint center = textLabel.center;
    center.y += 25;
    subTitleLabel.center = center;
    subTitleLabel.textColor = [UIColor whiteColor];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.font = [UIFont systemFontOfSize:14];
    
    subTitleLabel.text = model.sub_title;
    textLabel.text = model.title;
    
    [self.contentView addSubview:textLabel];
    [self.contentView addSubview:subTitleLabel];
}

//设置热门游记
- (void)setHotTravelWithImageModel:(TravelListModel *)model {
    
    [self cellRemoveSubViews];
    UIImageView *backImageView = [self setCellImageView];
    UILabel *textLabel = [self setCellLabel];
    
    [backImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_default]];
    textLabel.text = model.name;
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    CGRect rect = textLabel.frame;
    rect.origin.y += 20;
    rect.origin.x += 10;
    dateLabel.frame = rect;
    
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [self.contentView addSubview:dateLabel];
    
    UILabel *countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 20, 200, 20)];
    countryLabel.textColor = [UIColor whiteColor];
    countryLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    
    if ([model.popular_place_str isEqualToString: @""]) {
        countryLabel.text = @"中国";
        
    } else {
        countryLabel.text = model.popular_place_str;
        
    }
    [self.contentView addSubview:countryLabel];
    
    UIImageView *barView = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x - 10, rect.origin.y + 10, 3, 25)];
    barView.backgroundColor = [UIColor whiteColor];
    barView.layer.masksToBounds = YES;
    barView.layer.cornerRadius = 2;
    [self.contentView addSubview:barView];
    if (model.first_day != NULL) {
        dateLabel.text = [NSString stringWithFormat:@"%@ %@天 %@浏览", model.first_day, model.day_count, model.view_count];
        
    } else {
        dateLabel.text = [NSString stringWithFormat:@"%@天 %@浏览", model.day_count, model.view_count];
        CGRect rect = barView.frame;
        rect.size.height /= 2;
        barView.frame = rect;
    }
    
}


//
- (UIImageView *)setCellImageView {
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenWidth * 0.6)];
    [self setImageViewLayer:backImageView];
    [self.contentView addSubview:backImageView];
    return backImageView;
}

- (UILabel *)setCellLabel {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth - 30, 30)];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    textLabel.numberOfLines = 0;
    [self.contentView addSubview:textLabel];
    return textLabel;
}


- (UIImageView *)setImageViewLayer:(UIImageView *)imageView {
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 10;
    return imageView;
}

- (void)cellRemoveSubViews {
    NSArray *subArray = self.contentView.subviews;
    for (id view in subArray) {
        [view removeFromSuperview];
    }
    
}
@end
