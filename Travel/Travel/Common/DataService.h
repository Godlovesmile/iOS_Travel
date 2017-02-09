//
//  DataService.h
//  Movie
//
//  Created by Alice on 16/2/22.
//  Copyright © 2016年 ylz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject

+ (id)requestDataWithJsonFile:(NSString *)fileName;

@end
