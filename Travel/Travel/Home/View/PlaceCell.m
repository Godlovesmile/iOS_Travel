//
//  PlaceCell.m
//  Travel
//
//  Created by Alice on 16/5/13.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "PlaceCell.h"

@implementation PlaceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 120, 44)];
        [self.contentView addSubview:self.countryLabel];
        
        self.provinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, kScreenWidth - 140, 44)];
        self.provinceLabel.textColor = [UIColor grayColor];
        self.provinceLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.provinceLabel];
    }
    return self;
    
}

- (void)setPlaceModel:(PlaceModel *)placeModel {
    
    if (_placeModel != placeModel) {
        _placeModel = placeModel;
        
        if (placeModel.province[@"name_en"] == NULL && placeModel.province[@"name"] != NULL) {
            self.provinceLabel.text = placeModel.province[@"name"];
        } else if (placeModel.province[@"name_en"] != NULL) {
            self.provinceLabel.text = placeModel.province[@"name_en"];
        } else {
            self.provinceLabel.text = placeModel.name;
        }
        if (placeModel.country[@"name_orig"]  == NULL) {
            self.countryLabel.text = placeModel.name;
        } else {
            self.countryLabel.text = placeModel.country[@"name_orig"];
        }
    }
}

@end
