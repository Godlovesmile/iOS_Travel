//
//  ChatViewController.m
//  WeChat
//
//  Created by Alice on 16/3/21.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "ChatViewController.h"

#import "MessageModel.h"

#import "CellFrameModel.h"

#import "MessageCell.h"

#import "XMPPMessage+Tools.h"

#import "RecordTools.h"



#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kToolBarHeight 44
#define kTextFeildHeight 30

static NSString *cellID = @"cell";

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ChatDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    UITableView *_chatView;
    UIImageView *_toolBar;
    UITextField *_textField;
    
    NSMutableArray *_cellFrameDatas;
    
    //键盘高度
    CGFloat keyboardHeight;
    
    XMPPManager *manager;
    
    UIImagePickerController *picker;
    
    UIImageView *bgView;   //底部工具栏
    
}

//CoreData数据源
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,copy)NSString *originWav;

@property (nonatomic, strong) NSString *toJIDString;
@property (nonatomic, strong) XMPPJID *toJID;

//录音文本
@property(nonatomic,strong)UITextField *recordText;

@end

@implementation ChatViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hiddenTabBar" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showTabBar" object:nil];
    //NSLog(@"%s",__FUNCTION__);
}

//懒加载,创建录音文本
- (UITextField *)recordText {
    
    if (_recordText == nil) {
        
        _recordText = [[UITextField alloc] init];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _recordText.inputView = btn;
        
        [btn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
        
        [bgView addSubview:_recordText];
    }
    return _recordText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.hidesBottomBarWhenPushed = YES;
    //NSLog(@"hidden = %d",self.hidesBottomBarWhenPushed);
    
    // 设置导航默认标题的颜色及字体大小
    NSDictionary *dic = @{
                          NSForegroundColorAttributeName : [UIColor blackColor],
                          
                          NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                          
                          };
    self.navigationController.navigationBar.titleTextAttributes = dic;

    
    //发通知隐藏底部状态栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabBar" object:nil];
    
    //self.title = self.friendName;
    self.title = self.xmppUserObject.displayName;
    self.dataArray = [NSMutableArray array];
    self.title = self.xmppUserObject.displayName;
    self.toJIDString = self.xmppUserObject.jidStr;
    self.toJID = self.xmppUserObject.jid;
    

    //测试获取消息
    [self getMessageData];
    
    //1.加载数据
    [self loadData];

    //2.tableView
    [self createTableView];
    
    //3.工具栏
    [self createToolBar];
    
    //注册cell
    [_chatView registerClass:[MessageCell class] forCellReuseIdentifier:cellID];
    
    //系统键盘通知事件
    //键盘是窗口来管理
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardChange:) name:@"UIKeyboardWillShowNotification" object:nil];
    
    //程序进入滚动到消息最低部
    //NSLog(@"%ld",_cellFrameDatas.count);
    
    //NSLog(@"count = %d",_cellFrameDatas.count);
    if (_cellFrameDatas.count > 1) {
        
        [self viewscrollerToLast];
    }
    
    /*
     Available in iOS 7.0 and later.
     简单点说就是automaticallyAdjustsScrollViewInsets根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的 inset,设置为no，不让viewController调整，我们自己修改布局即可
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //接收发送的消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMsg:)
                                                 name:@"Alice"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //退出聊天界面时
    //发通知显示底部状态栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBar" object:nil];
}

#pragma mark - 帮助方法
//程序进入时,滚动到最后一行
- (void)viewscrollerToLast {
    
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count-1 inSection:0];
    [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//消息数据的处理
- (void)handleMessage:(NSString *)msg type:(BOOL)type image:(UIImage *)img audio:(NSString *)audio{
    
    //1.获取时间
    NSDate *sendDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *locationStr = [dateFormatter stringFromDate:sendDate];
    
    //2.创建一个MessageModel类
    MessageModel *message = [[MessageModel alloc] init];
    message.text = msg;
    message.img = img;
    message.audio = audio;
    message.time = locationStr;
    message.type = type;
    
    //3.创建一个CellFrameMode类
    CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
    CellFrameModel *lastCellFrame = [_cellFrameDatas lastObject];
    message.showTime = ![lastCellFrame.message.time isEqualToString:message.time];
    cellFrame.message = message;
    
    //4.添加进去,并且刷新数据
    [_cellFrameDatas addObject:cellFrame];
    [_chatView reloadData];
    
    //5.自动滚动最后一行
    [self viewscrollerToLast];
}

//收到好友消息
- (void)receiveMsg:(NSNotification *)notification {
    
    NSDictionary *msg = notification.userInfo;
    NSString *text = msg[@"text"];
    [self handleMessage:text type:0 image:nil audio:nil];
    
    //[_chatView reloadData];
}

//键盘弹出事件
- (void)keyboardChange:(NSNotification *)notification {
    
    //获取键盘高度
    NSDictionary *userinfo = notification.userInfo;
    NSValue *value = userinfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect keyboardRect = [value CGRectValue];
    keyboardHeight = keyboardRect.size.height;
    
    _toolBar.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    //_chatView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    _chatView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - kToolBarHeight - 64 - keyboardHeight);
    [_chatView reloadData];
    if (_cellFrameDatas.count > 1) {
        
        [self viewscrollerToLast];
    }

}

//1.加载数据
- (void)loadData {
    
    _cellFrameDatas = [NSMutableArray array];

    for (XMPPMessageArchiving_Message_CoreDataObject *object in self.dataArray) {
        

        if ([object.bareJidStr isEqualToString:self.toJIDString]) {
            
            //NSLog(@"bareJidStr = %@",object.bareJidStr);
            //NSLog(@"toJIDString = %@",self.toJIDString);
            
            // 如果存进去了，就把字符串转化成简洁的节点后保存
            if ([object.message saveAttachmentJID:self.toJID.bare timestamp:object.timestamp]) {
                object.messageStr = [object.message compactXMLString];
                
                [[XMPPManager shareManager].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext save:NULL];
            }

            
            NSMutableDictionary *messageDic = [NSMutableDictionary dictionary];
            //对于不同消息,区别:文字信息;图片信息;语音信息
            NSString *path = [object.message pathForAttachment:self.toJID.bare timestamp:object.timestamp];

            if ([object.body isEqualToString:@"image"]) {
                
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                [messageDic setValue:image forKey:@"img"];

            }else if ([object.body hasPrefix:@"audio"]) {
                
                NSString *newstr = [object.body substringFromIndex:6];
                //NSLog(@"newstr = %@",newstr);
                
                //NSLog(@"path = %@",path);
                [messageDic setValue:newstr forKey:@"audio"];
                [messageDic setValue:path forKey:@"audioPath"];

            }else {
                
                [messageDic setValue:object.body forKey:@"text"];
            }
            
            
            //拼接时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"MM-dd hh:mm"];
            NSString *timeStr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:object.timestamp]];
            //NSLog(@"我是时间:timeStr = %@",timeStr);
            [messageDic setValue:timeStr forKey:@"time"];
            //发消息的类型
            NSNumber *typeNumber = [NSNumber numberWithBool:object.isOutgoing];
            //NSLog(@"typeNumber = %@",typeNumber);
            [messageDic setValue:typeNumber forKey:@"type"];
            
            
            MessageModel *message = [MessageModel messageModelWithDic:messageDic];
            CellFrameModel *lastFrame = [_cellFrameDatas lastObject];
            CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
            message.showTime = ![message.time isEqualToString:lastFrame.message.time];
            cellFrame.message = message;
            [_cellFrameDatas addObject:cellFrame];
        }
    }
    
    [_chatView reloadData];
}

//加载数到的数据源
- (void)getData {
    
    _cellFrameDatas = [NSMutableArray array];
    
    for (XMPPMessageArchiving_Message_CoreDataObject *object in self.dataArray) {
        
        
        if (![object.bareJidStr isEqualToString:self.toJIDString]) {
            
            //NSLog(@"bareJidStr = %@",object.bareJidStr);
            //NSLog(@"toJIDString = %@",self.toJIDString);
            
            // 如果存进去了，就把字符串转化成简洁的节点后保存
            if ([object.message saveAttachmentJID:self.toJID.bare timestamp:object.timestamp]) {
                object.messageStr = [object.message compactXMLString];
                
                [[XMPPManager shareManager].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext save:NULL];
            }
            
            
            NSMutableDictionary *messageDic = [NSMutableDictionary dictionary];
            //对于不同消息,区别:文字信息;图片信息;语音信息
            NSString *path = [object.message pathForAttachment:self.toJID.bare timestamp:object.timestamp];
            
            if ([object.body isEqualToString:@"image"]) {
                
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                [messageDic setValue:image forKey:@"img"];
                
            }else if ([object.body hasPrefix:@"audio"]) {
                
                NSString *newstr = [object.body substringFromIndex:6];
                //NSLog(@"newstr = %@",newstr);
                
                //NSLog(@"path = %@",path);
                [messageDic setValue:newstr forKey:@"audio"];
                [messageDic setValue:path forKey:@"audioPath"];
                
            }else {
                
                [messageDic setValue:object.body forKey:@"text"];
            }
            
            
            //拼接时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"MM-dd hh:mm"];
            NSString *timeStr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:object.timestamp]];
            //NSLog(@"我是时间:timeStr = %@",timeStr);
            [messageDic setValue:timeStr forKey:@"time"];
            //发消息的类型
            NSNumber *typeNumber = [NSNumber numberWithBool:object.isOutgoing];
            //NSLog(@"typeNumber = %@",typeNumber);
            [messageDic setValue:typeNumber forKey:@"type"];
            
            
            MessageModel *message = [MessageModel messageModelWithDic:messageDic];
            CellFrameModel *lastFrame = [_cellFrameDatas lastObject];
            CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
            message.showTime = ![message.time isEqualToString:lastFrame.message.time];
            cellFrame.message = message;
            [_cellFrameDatas addObject:cellFrame];
        }
    }
    
    [_chatView reloadData];
}

//2.tableView
- (void)createTableView {
    
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    UITableView *chatView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - kToolBarHeight - 64) style:UITableViewStylePlain];
    chatView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    chatView.delegate = self;
    chatView.dataSource = self;
    chatView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //chatView.allowsSelection = NO;
    _chatView = chatView;
    
    [self.view addSubview:_chatView];
}

//3.工具栏
- (void)createToolBar {
    
    //工具栏背景
    bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0, kScreenHeight - kToolBarHeight, kScreenWidth, kToolBarHeight);
    bgView.image = [UIImage imageNamed:@"chat_bottom_bg"];
    bgView.userInteractionEnabled = YES;
    _toolBar = bgView;
    [self.view addSubview:_toolBar];
    
    //发送声音按钮
    UIButton *sendSoundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendSoundBtn.frame = CGRectMake(0, 0, kToolBarHeight, kToolBarHeight);
    [sendSoundBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
    //[sendSoundBtn addTarget:self action:@selector(beginAudio) forControlEvents:UIControlEventTouchDown];
    [sendSoundBtn addTarget:self action:@selector(setRecord) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sendSoundBtn];
    
    //添加按扭
    UIButton *addMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addMoreBtn.frame = CGRectMake(kScreenWidth - kToolBarHeight, 0, kToolBarHeight, kToolBarHeight);
    [addMoreBtn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [addMoreBtn addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addMoreBtn];
    
    //表情按钮
    UIButton *expressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    expressBtn.frame = CGRectMake(kScreenWidth - 2 * kToolBarHeight, 0, kToolBarHeight, kToolBarHeight);
    [expressBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [bgView addSubview:expressBtn];
    
    //输入框
    /*
     enablesReturnKeyAutomatically 默认为No,如果设置为Yes,文本框中没有输入任何字符的话，右下角的返回按钮是disabled的。
     */
    UITextField *textField = [[UITextField alloc] init];
    textField.returnKeyType = UIReturnKeySend;
    textField.background = [UIImage imageNamed:@"chat_bottom_textfield"];
    textField.enablesReturnKeyAutomatically = YES;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    textField.leftViewMode = UITextFieldViewModeAlways;   //UITextField 的左边view 出现模式
    textField.frame = CGRectMake(kToolBarHeight, (kToolBarHeight - kTextFeildHeight) * 0.5, kScreenWidth - 3 * kToolBarHeight, kTextFeildHeight);
    textField.delegate = self;
    _textField = textField;
    [_toolBar addSubview:_textField];
}

#pragma mark - 点击按钮响应事件的方法
//设置发送语音的按钮
- (void)setRecord {
    // 切换焦点，弹出录音按钮
    [self.recordText becomeFirstResponder];
}

//长按收集语音信息
- (void)startRecord {
    NSLog(@"开始录音");
    [[RecordTools sharedRecorder] startRecord];
}

//松开发送语音信息
- (void)stopRecord {
    NSLog(@"停止录音");
    [[RecordTools sharedRecorder] stopRecordSuccess:^(NSURL *url, NSTimeInterval time) {
        
        // 发送声音数据
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *bodyName = [NSString stringWithFormat:@"%.1f秒",time];
        [self sendMessageWithData:data bodyName:[NSString stringWithFormat:@"audio:%.1f秒", time]];

        //发送音频消息成功更新UI界面
        [self handleMessage:nil type:1 image:nil audio:bodyName];
        
    } andFailed:^{
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"时间太短" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}

//发送图片
- (void)sendPhoto {
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _cellFrameDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.cellFrame = _cellFrameDatas[indexPath.row];
    
    //cell选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellFrameModel *cellFrameModel = _cellFrameDatas[indexPath.row];
    
    //NSLog(@"height = %f",cellFrameModel.cellHeight);
    return cellFrameModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中了");
    
    //发送之后重新加载数据刷新页面,这样audioPath中才有值
    [self getMessageData];
    [self loadData];
    [_chatView reloadData];
    
    //[_chatView reloadData];
    
    //选中之后判断是否存在录音文件,若存在即播放
    CellFrameModel *cellFrameModel = _cellFrameDatas[indexPath.row];
    MessageModel *msgModel = cellFrameModel.message;
    
    NSLog(@"audioPath = %@",msgModel.audioPath );
    
    if (msgModel.audioPath != nil) {   //路径存在,播放
        
        NSLog(@"开始播放!!!");
        // 如果单例的块代码中包含self，一定使用weakSelf
        //__weak SXChatCell *weakSelf = self;
        [[RecordTools sharedRecorder] playPath:msgModel.audioPath completion:^{
            //weakSelf.messageLabel.textColor = [UIColor whiteColor];
            NSLog(@"播放完成!!!");
        }];
    }
    //收回键盘
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    //_chatView.transform = CGAffineTransformIdentity;
    _chatView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - kToolBarHeight - 64);
    _toolBar.transform = CGAffineTransformIdentity;
    [self.view endEditing:YES];
    [UIView commitAnimations];
}


#pragma mark - UITextField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //发送消息
    //NSLog(@"toJIDString = %@",self.toJIDString);
    
    [[XMPPManager shareManager] sendMessage:textField.text toUser:self.toJIDString];
    
    
    //测试发送消息的CoreData
    [self getMessageData];

    //[self handleMessage:textField.text type:1 image:nil];
    [self handleMessage:textField.text type:1 image:nil audio:nil];
    
    //6.清空输入框
    textField.text = @"";
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    _chatView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - kToolBarHeight - 64);
    _toolBar.transform = CGAffineTransformIdentity;
    [self.view endEditing:YES];
    
    [UIView commitAnimations];
}

#pragma mark - 测试
- (void)getMessageData {
    
    manager = [XMPPManager shareManager];
    manager.chatDelegate = self;
    
    NSManagedObjectContext *context = [manager.xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error ;
    NSArray *messages = [context executeFetchRequest:request error:&error];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:messages];
}

#pragma mark - ChatDelegate
- (void)getNewMessage:(XMPPManager *)appD Message:(XMPPMessage *)message {
    
    //收到信息调用代理
    NSLog(@"收到信息的代理方法!");
    
    //[self getMessageData];
    //[self loadData];

    //[_chatView reloadData];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *data = UIImagePNGRepresentation(image);
    //发送图片消息
    [self sendMessageWithData:data bodyName:@"image"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //选择完照片之后,隐藏状态标签栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabBar" object:nil];
    
    //发送图片之后在本地更新UI界面
    //[self handleMessage:nil type:1 image:image];
    [self handleMessage:nil type:1 image:image audio:nil];
    
    //[self getMessageData];
    //[self loadData];
}

#pragma mark - 自定义方法
//发送图片,音频消息消息
- (void)sendMessageWithData:(NSData *)data bodyName:(NSString *)name {
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.toJID];
    
    [message addBody:name];
    
    // 转换成base64的编码
    NSString *base64str = [data base64EncodedStringWithOptions:0];
    
    // 设置节点内容
    XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64str];
    
    // 包含子节点
    [message addChild:attachment];
    
    // 发送消息
    [[XMPPManager shareManager].stream sendElement:message];
}
@end
