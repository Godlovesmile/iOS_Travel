//
//  PlaceModel.m
//  Travel
//
//  Created by Alice on 16/5/13.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "PlaceModel.h"

@implementation PlaceModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(nonnull NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}


@end
