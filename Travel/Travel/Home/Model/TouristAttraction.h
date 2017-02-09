//
//  TouristAttraction.h
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>


//推荐地点
@interface TouristAttraction : NSObject

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *arrival_type;
@property(nonatomic,copy)NSString *category;
@property(nonatomic,copy)NSString *cover;
@property(nonatomic,copy)NSString *cover_route_map_cover;
@property(nonatomic,copy)NSString *cover_s;
@property(nonatomic,copy)NSString *currency;

@property(nonatomic,copy)NSString *date_added;
@property(nonatomic,copy)NSString *descript;

@property(nonatomic,copy)NSString *fee;

@property(nonatomic,copy)NSString *has_experience;

@property(nonatomic,copy)NSString *has_route_maps;
@property(nonatomic,copy)NSString *icon;

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *is_nearby;

@property(nonatomic,retain)NSDictionary  *location;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *name_en;
@property(nonatomic,copy)NSString *opening_time;

@property(nonatomic,copy)NSString *popularity;
@property(nonatomic,copy)NSString *rating_users;
@property(nonatomic,copy)NSString *recommended;
@property(nonatomic,copy)NSString *recommended_reason;
@property(nonatomic,copy)NSString *slug_url;
@property(nonatomic,copy)NSString *spot_region;
@property(nonatomic,copy)NSString *tel;


@property(nonatomic,copy)NSString *timezone;

@property(nonatomic,retain)NSArray  *tips;
@property(nonatomic,copy)NSString *tips_count;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *verified;
@property(nonatomic,copy)NSString *visited_count;
@property(nonatomic,copy)NSString *website;
@property(nonatomic,copy)NSString *wish_to_go_count;



@end
