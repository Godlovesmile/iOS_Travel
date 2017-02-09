//
//  City.h
//  TravelApp
//
//  Created by SZT on 15/12/23.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property(nonatomic,copy)NSString *comments_count;

@property(nonatomic,copy)NSString *cover;

@property(nonatomic,copy)NSString *cover_route_map_cover;

@property(nonatomic,copy)NSString *cover_s;

@property(nonatomic,copy)NSString *has_experience;

@property(nonatomic,copy)NSString *has_route_maps;

@property(nonatomic,copy)NSString *ID;

//@property(nonatomic,copy)NSString *location;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *name_en;

@property(nonatomic,copy)NSString *name_orig;

@property(nonatomic,copy)NSString *name_zh;

@property(nonatomic,copy)NSString *slug_url;

@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *url;

@property(nonatomic,copy)NSString *visited_count;

@property(nonatomic,copy)NSString *wish_to_go_count;

@end
