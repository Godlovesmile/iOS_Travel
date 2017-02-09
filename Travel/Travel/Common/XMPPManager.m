//
//  XMPPManager.m
//  WeChat
//
//  Created by Alice on 16/3/17.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "XMPPManager.h"

static XMPPManager *instance = nil;

@implementation XMPPManager

//单例对象,创建流对象
+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[[self class] alloc] init];
        [instance setupStream];
    });
    return instance;
}

//用户头像
-(NSData *)photoDataForJID:(XMPPJID *)jid
{
    return [self.xmppvCardAvatarModule photoDataForJID:jid];
}


//创建流
- (void)setupStream {
    
    //创建
    self.stream = [[XMPPStream alloc] init];
    [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //配置
    [self.stream setHostName:kXMPPHostIP];
    [self.stream setHostPort:kXMPPHostPort];
    
    
    //添加
    self.xmppReconnect = [[XMPPReconnect alloc]init];
    [self.xmppReconnect activate:self.stream];
    
    self.xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
    self.xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:self.xmppRosterStorage];
    [self.xmppRoster activate:self.stream];
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    self.xmppMessageArchivingModule = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:self.xmppMessageArchivingCoreDataStorage];
    [self.xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [self.xmppMessageArchivingModule activate:self.stream];
    [self.xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - Custom Method
//1.登录
- (void)loginWithUsername:(NSString *)name password:(NSString *)password success:(LoginSuccessBlock)sBlock faile:(LoginFaileBlock)fBlock {
    
    self.username = name;
    self.password = password;
    self.loginSuccessBlock = sBlock;
    self.loginFaileBlock = fBlock;
    
    //1.连接服务器
    [self connect];
}

//2.获取好友列表
- (void)loadFriends:(FetchFriendBlock)friendBlock {
    
    
    //注意格式一定要写对
    /*
     <!-- 7.客户端请求通讯录信息 -->
     <iq from='guojing@wxhl' type='get' id='roster_1'>
     <query xmlns='jabber:iq:roster'/>      <!-- iq 信息有多种，根据命名空间来区分-->
     </iq>
     
     type 属性，说明了该 iq 的类型为 get，与 HTTP 类似，向服务器端请求信息
     from 属性，消息来源，这里是你的 JID
     id 属性，标记该请求 ID，当服务器处理完毕请求 get 类型的 iq 后，响应的 result 类型 iq 的 ID 与 请求 iq 的 ID 相同
     */
    
    //保存block
    self.fetchFriendBlock = friendBlock;
    
    //拼接XML
    XMPPJID *myJID = self.stream.myJID;
    NSXMLElement *iqElement = [NSXMLElement elementWithName:@"iq"];
    [iqElement addAttributeWithName:@"type" stringValue:@"get"];
    [iqElement addAttributeWithName:@"from" stringValue:myJID.description];
    [iqElement addAttributeWithName:@"id" stringValue:@"12345"];
    //xmlns为xml命名空间
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    
    //NSXMLElement *query = [XMPPElement elementWithName:@"query"];
    //[iqElement addChild:query];
    //[iqElement addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:roster"];
    [iqElement addChild:query];

    [self.stream sendElement:iqElement];
}

//3.注销
- (void)logoutAction:(LogoutSuccessBlock)logoutSuccessBlock {
    
    //告诉服务器修改状态
    [self goOffline];
    //断开连接
    [self.stream disconnect];
    //回掉block
    if (logoutSuccessBlock) {
        logoutSuccessBlock();
    }
}

//4.注册
- (void)registerUser:(NSString *)username password:(NSString *)password successBlock:(RegisterSuccessBlock)rBlock {
    
    self.registerSuccessBlock = rBlock;
    self.username = username;
    self.password = password;
    
    //注册之前也要建立连接
    [self connect];
    
    //进行注册
    loginType = kTypeRegister;
    [self xmppStreamDidConnect:self.stream];
}

//5.发消息
/*
 <message to='huangrong@wxhl' from='guojing@wxhl' type='chat' xml:lang='en'>
 <body>蛋定</body>
 </message>
 */
- (void)sendMessage:(NSString *)message toUser:(NSString *)jid {
    if (message.length == 0) {
        return;
    }
    
    //创建发送消息的xml格式
    /*
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    [msg addAttributeWithName:@"to" stringValue:jid];
    [msg addAttributeWithName:@"from" stringValue:self.stream.myJID.full];
    [msg addAttributeWithName:@"type" stringValue:@"chat"];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body" stringValue:message];
    [msg addChild:body];
     */
    XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
    XMPPMessage *xmppMessage = [XMPPMessage messageWithType:@"chat" to:xmppJID];
    [xmppMessage addBody:message];
    
    [self.stream sendElement:xmppMessage];
}


#pragma mark - 帮助方法
//连接服务器
- (void)connect {
    
    XMPPJID *jid = [XMPPJID jidWithUser:self.username domain:kXMPPHostName resource:@"iOS客户端"];
    [self.stream setMyJID:jid];
    
    NSError *error = nil;
    BOOL result = [self.stream connectWithTimeout:60 error:&error];
    if (result) {
        NSLog(@"连接发送成功");
    }else {
        NSLog(@"连接发送失败: %@",error);
    }
}

//上线
- (void)goOnline {
    
    /*
     此处也可以自己构建在线状态的xml文件:
     //Presence元素
     DDXMLElement *presence = [DDXMLElement elementWithName:@"presence"];
     
     if (showStr!=nil) {
     DDXMLElement *show = [DDXMLElement elementWithName:@"show" stringValue:showStr];
     [presence addChild:show];
     }
     
     if (statusStr != nil) {
     DDXMLElement *status = [DDXMLElement elementWithName:@"status" stringValue:statusStr];
     [presence addChild:status];
     }
     
     //发送元素
     [self.stream sendElement:presence];
     */
    
    XMPPPresence *presence = [XMPPPresence presence];   //上线默认的类型是:available
    [self.stream sendElement:presence];
}

//下线
- (void)goOffline {
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.stream sendElement:presence];
}

#pragma mark - XMPPStreamDelegate
//将要连接
- (void)xmppStreamWillConnect:(XMPPStream *)sender {
 
    NSLog(@"将要连接");
}

//连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"连接成功");
    
    if (loginType == kTypeLogin) {   //登录认证
        
        //连接成功之后,进行验证登录
        NSError *error = nil;
        BOOL result = [self.stream authenticateWithPassword:self.password error:&error];
        if (result) {
            NSLog(@"验证发送成功");
        }
        
    }else {
        
        //注册
        [self.stream registerWithPassword:self.password error:nil];
    }
}

//认证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"验证成功");
    
    //用户名,密码验证成功之后,调用block执行,进行登录操作
    if (_loginSuccessBlock) {
    
        self.loginSuccessBlock();
    }
    
    //上线
    [self goOnline];
    
    //解决方法一:
    //解决视图切换不释放,是由于在block内部使用了全局变量,造成引用计数加一
    //self.loginFaileBlock = nil;
    //self.loginSuccessBlock = nil;
}

//认证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    
    //断开连接
    [self.stream disconnect];
    
    if (_loginFaileBlock) {
        _loginFaileBlock(@"认证失败!!!");
    }
}

//连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender {
    
    if (_loginFaileBlock) {
        
        _loginFaileBlock(@"连接超时");
    }
}

//好友上线的提示(出席),包括自己
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence {
    
    NSLog(@"已经出席!!!");
}

//已经收到了Info/Query信息(方法多次调用)
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    
    //NSLog(@"iq = %@",iq);
    
    /*
     注意点:若此处使用到CoreData,直接return就行,不需要解析
     */
    
    return NO;
    
    /*
     获取到iq格式:
     <iq xmlns="jabber:client" type="result" id="12345" to="alice@127.0.0.1/iOS客户端">
         <query xmlns="jabber:iq:roster">
     
             <item jid="ylz02@127.0.0.1" name="ylz02" subscription="to">
                <group>朋友</group>
             </item>
     
             <item jid="ylz@127.0.0.1" name="ylz" subscription="both">
                <group>朋友</group>
             </item>
     
             <item jid="ylz01@127.0.0.1" name="ylz01" subscription="both">
               <group>盆友</group>
             </item>
     
         </query>
     </iq>
     */
    
    //解析xml
    /*
     最后解析的数据源格式:
     {
     "好友" :
     [
     "user1",
     "user2",
     "user3"
     ],
     "联系人列表" :
     [
     "user1",
     "user2"
     ]
     }
     */
    
    //整理数据的思路是和项目一影院界面数据的整合是一样的
//    if([iq isResultIQ]) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        //query
//        NSXMLElement *query = [iq childElement];
//        //item
//        for (NSXMLElement *item in [query children]) {
//            NSString *jid = [item attributeStringValueForName:@"jid"];
//            if (!jid || [jid isEqualToString:@""]) {
//                continue;
//            }
//            NSString *name = [item attributeStringValueForName:@"name"];
//            name = name ? name : @"";
//            
//            //user
//            UserModel *model = [[UserModel alloc] init];
//            model.jid = jid;
//            model.username = name;
//            
//            //group
//            for (NSXMLElement *group in [item children]) {
//                
//                NSString *groupStr = [group stringValue];
//                
//                NSMutableArray *mArr = dic[groupStr];
//                if (!mArr) {
//                    mArr = [NSMutableArray array];
//                    [dic setObject:mArr forKey:groupStr];
//                }
//                
//                [mArr addObject:model];
//            }
//            
//        }
//        
//        NSLog(@"dic = %@",dic);
        /*
         整合之后的数据形式:
         dic = {
         "\U670b\U53cb" =     (
         "<UserModel: 0x7ff0d062aca0>",
         "<UserModel: 0x7ff0d060f0b0>"
         );
         "\U76c6\U53cb" =     (
         "<UserModel: 0x7ff0d0629900>"
         );
         }
         */
        
        //拿到数据时候回掉block
        
        //NSLog(@"fetchFriendBlock = %@",self.fetchFriendBlock);
        
        //block一定要先判断再去调用,防止block为空;此代理方法就是多次调用的
//        if (self.fetchFriendBlock) {
//            
//            self.fetchFriendBlock(dic);
//        }
//    }
//    
//    return YES;
}

//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    
    NSLog(@"注册成功");
    
    //回掉注册成功之后的block
    if (self.registerSuccessBlock) {
        
        self.registerSuccessBlock();
    }
    
    //注册成功,断开连接,进入登录页面,
    //注册成功时,修改状态
    loginType = kTypeLogin;
}

//注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error {
    
    [self.stream disconnect];
    NSLog(@"注册失败");
}

//已经发送消息
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {

    NSLog(@"已经发送消息");
    
    //NSLog(@"message = %@",message);
//    if ([self.chatDelegate respondsToSelector:@selector(getNewMessage:Message:)]) {
//        
//        //NSLog(@"self.chatDelegate = %@",self.chatDelegate);
//        [self.chatDelegate getNewMessage:self Message:message];
//    }
}

//已经收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    /*
     收到消息格式:
     <message xmlns="jabber:client" type="chat" id="purplee813c9cb" to="whj@wxhl/72a0b968" from="yanzi@wxhl/wxhl">
     <body>jhkshs</body>
     </message>
     */
    
    
    
    NSLog(@"收到消息");
    //NSLog(@"message = %@",message);
    
    
    if ([message isChatMessageWithBody]) {
        NSString *body = [message body];
        XMPPJID *fromJID = message.from;
        NSString *fromUser = fromJID.user;
        
        NSDictionary *msg = @{
                              @"fromUser" : fromUser,
                              @"text" : body,
                              };
        //发送通知,将消息传递
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Alice" object:nil userInfo:msg];
    }
    
    
   if ([self.chatDelegate respondsToSelector:@selector(getNewMessage:Message:)]) {
    
    //NSLog(@"self.chatDelegate = %@",self.chatDelegate);
        [self.chatDelegate getNewMessage:self Message:message];
    }

}


//原始地址： XMPPFrameWork IOS 开发（五）获取好友信息和添加删除好友
//好友列表和好友名片
//[_xmppRoster fetchRoster];//获取好友列表
//
////获取到一个好友节点
//- (void)xmppRoster:(XMPPRoster *)sender didRecieveRosterItem:(NSXMLElement *)item
//
////获取完好友列表
//- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
//
////到服务器上请求联系人名片信息
//- (void)fetchvCardTempForJID:(XMPPJID *)jid;
//
////请求联系人的名片，如果数据库有就不请求，没有就发送名片请求
//- (void)fetchvCardTempForJID:(XMPPJID *)jid ignoreStorage:(BOOL)ignoreStorage;
//
////获取联系人的名片，如果数据库有就返回，没有返回空，并到服务器上抓取
//- (XMPPvCardTemp *)vCardTempForJID:(XMPPJID *)jid shouldFetch:(BOOL)shouldFetch;
//
////更新自己的名片信息
//- (void)updateMyvCardTemp:(XMPPvCardTemp *)vCardTemp;
//
////获取到一盒联系人的名片信息的回调
//- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
//        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
//                     forJID:(XMPPJID *)jid
//
//添加好友
////name为用户账号
//- (void)XMPPAddFriendSubscribe:(NSString *)name
//{
//    //XMPPHOST 就是服务器名，  主机名
//    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,XMPPHOST]];
//    //[presence addAttributeWithName:@"subscription" stringValue:@"好友"];
//    [xmppRoster subscribePresenceToUser:jid];
//    
//}
//
////收到添加好友的请求
//- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
//{
//    //取得好友状态
//    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
//    //请求的用户
//    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
//    NSLog(@"presenceType:%@",presenceType);
//    
//    NSLog(@"presence2:%@  sender2:%@",presence,sender);
//    
//    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
//    //接收添加好友请求
//    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
//    
//}
//
//删除好友
////删除好友，name为好友账号
//- (void)removeBuddy:(NSString *)name
//{
//    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,XMPPHOST]];
//    
//    [self xmppRoster] removeUser:jid];
//}

@end
