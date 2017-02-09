//
//  TravelListModel.h
//  Travel
//
//  Created by Alice on 16/5/13.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelListModel : NSObject

@property (nonatomic,strong) NSString *city;

@property (nonatomic,strong) NSString *url;

@property (nonatomic,strong) NSString *country;

@property (nonatomic,strong) NSString *desc;

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSString *cover;

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSString *sub_title;

@property (nonatomic,strong) NSString *cover_mask;

@property (nonatomic,strong) NSString *cover_image;

@property (nonatomic,strong) NSString *cover_image_default;

@property (nonatomic,strong) NSString *first_day;

@property (nonatomic,strong) NSString *index_title;

@property (nonatomic,strong) NSString *index_cover;

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *popular_place_str;

@property (nonatomic,strong) NSString *view_count;

@property (nonatomic,strong) NSString *day_count;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *mileage;

@property (nonatomic,strong) NSDictionary *user;

@property (nonatomic,strong) NSString *recommendations;

@property (nonatomic,strong) NSString *trackpoints_thumbnail_image;

@property (nonatomic,strong) NSString *text;

@property (nonatomic,strong) NSString *local_time;

@property (nonatomic,strong) NSString *photo_1600;

@property (nonatomic,strong) NSString *photo_height;

@property (nonatomic,strong) NSString *photo_width;

@property (nonatomic,strong) NSString *html_url;

@property (nonatomic,strong) NSString *date;

@property (nonatomic,strong) NSString *day;

@property (nonatomic,strong) NSString *spot_id;

@property (nonatomic,strong) NSDictionary *poi;

@property (nonatomic,strong) NSString *recommended;

@end
