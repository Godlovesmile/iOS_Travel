//
//  DataService.m
//  Movie
//
//  Created by Alice on 16/2/22.
//  Copyright © 2016年 ylz. All rights reserved.
//

#import "DataService.h"

@implementation DataService

+ (id)requestDataWithJsonFile:(NSString *)fileName {
    
    //–––––––––––––––––解析json数据–––––––––––––––––
    //本次使用的json数据是保存好的本地数据,不从网络加载
    
    //获取json数据的路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    //将json数据转换为二进制格式
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    //解析json数据
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return jsonData;
}
@end
