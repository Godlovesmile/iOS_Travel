//
//  MessageModel.m
//  WeChat
//
//  Created by Alice on 16/3/21.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+ (instancetype)messageModelWithDic:(NSDictionary *)dic {

    MessageModel *message = [[self alloc] init];
    message.text = dic[@"text"];
    message.time = dic[@"time"];
    message.type = [dic[@"type"] intValue];
    message.img = dic[@"img"];
    message.audio = dic[@"audio"];
    message.audioPath = dic[@"audioPath"];
    
    return message;
}
@end
