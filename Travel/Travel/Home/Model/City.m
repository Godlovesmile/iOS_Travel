//
//  City.m
//  TravelApp
//
//  Created by SZT on 15/12/23.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "City.h"

@implementation City


- (void)setValue:(id)value forKey:(NSString *)key {
    
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }else if ([key isEqualToString:@"type"]) {
        _type = [NSString stringWithFormat:@"%@",value];
    }else if ([key isEqualToString:@"visited_count"]) {
        _visited_count = [NSString stringWithFormat:@"%@",value];
    }else if ([key isEqualToString:@"wish_to_go_count"]) {
        _wish_to_go_count = [NSString stringWithFormat:@"%@",value];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
