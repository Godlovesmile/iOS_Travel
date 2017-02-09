//
//  MessageModel.h
//  WeChat
//
//  Created by Alice on 16/3/21.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>

//枚举判断发消息类型
typedef enum {
    
    kMessageTypeOther,
    kMessageTypeMe
    
}MessageType;

@interface MessageModel : NSObject

@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,assign)MessageType type;
@property(nonatomic,assign)BOOL showTime;

//@property(nonatomic,strong)XMPPMessageArchiving_Message_CoreDataObject *object;
@property(nonatomic,strong)UIImage *img;    //图片

@property(nonatomic,strong)NSString *audio; //音频消息

@property(nonatomic,strong)NSString *audioPath; //音频路径

+ (instancetype)messageModelWithDic:(NSDictionary *)dic;

@end
