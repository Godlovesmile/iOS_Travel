//
//  XMPPManager.h
//  WeChat
//
//  Created by Alice on 16/3/17.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatDelegate;

//#define kXMPPHostName @"127.0.0.1"
//#define kXMPPHostIP @"127.0.0.1"
//#define kXMPPHostIP @"192.168.2.1"

#define kXMPPHostName @"wxhl"
#define kXMPPHostIP @"218.241.181.202"
#define kXMPPHostPort 5222

//登录的block
typedef void(^LoginSuccessBlock)(void);
typedef void(^LoginFaileBlock)(NSString *);

//好友列表
typedef void(^FetchFriendBlock)(id result);

//注销成功
typedef void(^LogoutSuccessBlock)();

//闫理智

//注册成功
typedef void(^RegisterSuccessBlock)();

//区别登录和注册的枚举
typedef enum {
    
    kTypeLogin = 0,
    kTypeRegister = 1
    
}LoginType;

@interface XMPPManager : NSObject<XMPPStreamDelegate,ChatDelegate> {
    
    LoginType loginType;  //注册和登录
}

@property(nonatomic,strong)XMPPStream *stream;   //流对象

@property(nonatomic,copy)LoginSuccessBlock loginSuccessBlock;  //登录成功的block
@property(nonatomic,copy)LoginFaileBlock loginFaileBlock;      //登录失败的block
@property(nonatomic,copy)FetchFriendBlock fetchFriendBlock;    //获取好友列表的block
@property(nonatomic,copy)RegisterSuccessBlock registerSuccessBlock; //注册成功的block


//添加功能
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchivingModule;

//名片头像模块
@property (nonatomic, strong)XMPPvCardAvatarModule *xmppvCardAvatarModule;


@property (nonatomic,weak)id<ChatDelegate> chatDelegate;


@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *password;

//单例对象,创建流对象
+ (instancetype)shareManager;

//用户头像
-(NSData *)photoDataForJID:(XMPPJID *)jid;


//1.登录
- (void)loginWithUsername:(NSString *)name password:(NSString *)password success:(LoginSuccessBlock)sBlock faile:(LoginFaileBlock)fBlock;

//2.获取好友列表
- (void)loadFriends:(FetchFriendBlock)friendBlock;

//3.注销
- (void)logoutAction:(LogoutSuccessBlock)logoutSuccessBlock;

//4.注册
- (void)registerUser:(NSString *)username password:(NSString *)password successBlock:(RegisterSuccessBlock)rBlock;

//5.发消息
- (void)sendMessage:(NSString *)message toUser:(NSString *)jid;



@end


//自定义代理
@protocol ChatDelegate <NSObject>

-(void)friendStatusChange:(XMPPManager *)appD Presence:(XMPPPresence *)presence;
-(void)getNewMessage:(XMPPManager *)appD Message:(XMPPMessage *)message;

@end




