//
//  TravelListCell.h
//  Travel
//
//  Created by Alice on 16/5/13.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TravelListModel.h"

@interface TravelListCell : UITableViewCell

- (void)setRecommendProductsWithImageModel:(TravelListModel *)model;

- (void)setHotTravelWithImageModel:(TravelListModel *)model;

@end
