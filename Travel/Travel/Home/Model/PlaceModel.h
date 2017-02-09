//
//  PlaceModel.h
//  Travel
//
//  Created by Alice on 16/5/13.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceModel : NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *icon;

@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSDictionary *province;

@property (nonatomic,strong) NSDictionary *country;

@end
