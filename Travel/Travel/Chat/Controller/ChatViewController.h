//
//  ChatViewController.h
//  WeChat
//
//  Created by Alice on 16/3/21.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "ViewController.h"

//#import "UserModel.h"

//#import "ChatVoiceRecorderVC.h"
//#import "VoiceConverter.h"

//#import "XMPPUserCoreDataStorageObject.h"

@interface ChatViewController : UIViewController

@property(nonatomic,copy)NSString *friendName;  //好友姓名

//@property(nonatomic,strong)UserModel *toUser;   //发送消息的对象

@property (nonatomic,strong) XMPPUserCoreDataStorageObject *xmppUserObject;

//@property (retain, nonatomic)  ChatVoiceRecorderVC  *recorderVC;

@end
