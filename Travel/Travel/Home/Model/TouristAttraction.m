//
//  TouristAttraction.m
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "TouristAttraction.h"

@implementation TouristAttraction

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"description"]) {
        _descript = value;
    }else if ([key isEqualToString:@"id"]){
        _ID = value;
    }else if ([key isEqualToString:@"visited_count"]){
        _visited_count = [NSString stringWithFormat:@"%@",value];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

@end
