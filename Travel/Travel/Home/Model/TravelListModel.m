//
//  TravelListModel.m
//  Travel
//
//  Created by Alice on 16/5/13.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "TravelListModel.h"

@implementation TravelListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"day_count"]) {
        self.day_count = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"view_count"]) {
        self.view_count = [NSString stringWithFormat:@"%@", value];
    }
}

@end
