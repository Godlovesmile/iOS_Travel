//
//  CountryDetailView.h
//  Travel
//
//  Created by Alice on 16/4/20.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TouristAttraction.h"

@interface CountryDetailView : UICollectionViewCell

@property(nonatomic,strong)UIImageView  *iconImage;

@property(nonatomic,strong)UILabel *cityName;

@property(nonatomic,retain)TouristAttraction  *tourist;

@end
