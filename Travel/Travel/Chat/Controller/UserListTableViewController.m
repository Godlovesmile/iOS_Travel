//
//  UserListTableViewController.m
//  WeChat
//
//  Created by Alice on 16/3/16.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "UserListTableViewController.h"

#import "ChatViewController.h"

@interface UserListTableViewController ()<ChatDelegate,NSFetchedResultsControllerDelegate> {
    
    BOOL status[20];
}

//@property(nonatomic,strong)NSDictionary *dic;   //数据源

@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@end

@implementation UserListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  去除多余单元格的线条
    self.tableView.tableFooterView = [[UIView alloc] init];

    // 设置导航默认标题的颜色及字体大小
    NSDictionary *dic = @{
                          NSForegroundColorAttributeName : [UIColor blackColor],
                          
                          NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                          
                          };
    self.navigationController.navigationBar.titleTextAttributes = dic;
    
    self.title = @"联系人";
    
    //self.dataArray = [[NSMutableArray alloc]init];
    
    //[self getData];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
//    imageView.image = [UIImage imageNamed:@"kk@2x"];
//    imageView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:imageView];
}

- (void)dealloc {
    
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
//    __weak UserListTableViewController *weakSelf = self;
    //加载好友列表
//    [[XMPPManager shareManager] loadFriends:^(id result) {
//        
//        //回掉block之后,当前的result就有值了
//        weakSelf.dic = result;
//        
//        //刷新数据
//        [weakSelf.tableView reloadData];
//    }];
}

//使用CoreData获取好友列表
/*
- (void)getData{
    
    XMPPManager *manager = [XMPPManager shareManager];
    manager.chatDelegate = self;
    
    NSManagedObjectContext *context = [ manager.xmppRosterStorage mainThreadManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSError *error ;
    NSArray *friends = [context executeFetchRequest:request error:&error];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:friends];
}
 */

//注销
- (IBAction)logoutAction:(id)sender {
    
    __weak UserListTableViewController *weakSelf = self;
    //注销时应断开连接
    [[XMPPManager shareManager] logoutAction:^{
        
        //动画翻转到朋友列表界面
        UIViewController *viewCtrl = [weakSelf.storyboard instantiateInitialViewController];
        [UIView transitionWithView:weakSelf.view.window duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            weakSelf.view.window.rootViewController = viewCtrl;
        } completion:nil];
    }];
}

#pragma mark - XMPPUserCoreDataStorageObject
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil){
        return _fetchedResultsController;
    }
    
    //查询对象
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //拿到context
    NSManagedObjectContext *moc = [[XMPPManager shareManager].xmppRosterStorage mainThreadManagedObjectContext] ;
    
    //查询实体（去哪个对象查询）
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"XMPPGroupCoreDataStorageObject"
                                   inManagedObjectContext:moc];
    
    //查询结果排序对象（使用NSFetchedResultsController，NSFetchRequest 必须设置 NSSortDescriptor）
    /*
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"sectionNum" ascending:YES];
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    NSArray *sortDescriptors = @[sd1, sd2];
     */
    //查询结果排序对象（使用NSFetchedResultsController，NSFetchRequest 必须设置 NSSortDescriptor）
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sd1];

    
    //设置查询条件
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:10];
    
    //创建NSFetchedResultsController对象。因为Demo要显示section title，需要指定sectionNameKeyPath
    //sectionNameKeyPath 指定分组tableview的section name，且section name必须是entity里面的一个attribute
    //cacheName 缓存名字随意
    _fetchedResultsController = [[NSFetchedResultsController alloc]
                                 initWithFetchRequest:fetchRequest
                                 managedObjectContext:moc
                                 sectionNameKeyPath:@"name"
                                 cacheName:nil];
    
    //设置delegate能够监听数据库数据变化
    _fetchedResultsController.delegate = self;
    
    //查询数据
    [_fetchedResultsController performFetch:NULL];
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //数据入口
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //return [self.dataArray count];
    //return 1;
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (status[section] == 0) {
        return 0;
    }
    
//    NSArray *sections = self.fetchedResultsController.sections;
//    
//    if (section < [sections count]){
//        id <NSFetchedResultsSectionInfo> sectionInfo = sections[section];
//        return sectionInfo.numberOfObjects;
//    }
//
//    //获取分组名字
//    NSString *groupKey = [self.dic allKeys][section];
//    NSArray *userArr = self.dic[groupKey];
//    return userArr.count;
//    return [self.dataArray count];
    
    XMPPGroupCoreDataStorageObject *groupMO = self.fetchedResultsController.fetchedObjects[section];
    return groupMO.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserListTableViewCell" forIndexPath:indexPath];
    /*
    NSString *groupKey = [self.dic allKeys][indexPath.section];
    NSArray *allUserArr = self.dic[groupKey];
    UserModel *model = allUserArr[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"ylz.jpg"];
    cell.textLabel.text = model.username;
    cell.detailTextLabel.text = model.jid;
    
    //NSLog(@"jid = %@",model.jid);
     */
    
    //XMPPUserCoreDataStorageObject *object = [self.dataArray objectAtIndex:indexPath.row];
    /*
    XMPPUserCoreDataStorageObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = object.jidStr;
    cell.detailTextLabel.text = object.nickname;
    
    if (object.photo){
        cell.imageView.image = object.photo;
    }else{
        NSData *photoData = [[XMPPManager shareManager] photoDataForJID:object.jid];
        
        if (photoData){
            cell.imageView.image = [UIImage imageWithData:photoData];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"ylz.jpg"];
        }
    }
    */
    
    XMPPGroupCoreDataStorageObject *groupMO = self.fetchedResultsController.fetchedObjects[indexPath.section];
    XMPPUserCoreDataStorageObject *userMO = [groupMO.users allObjects][indexPath.row];
    
    //NSLog(@"%@ -- %d", userMO.jidStr, [userMO isOnline]);
    
    cell.textLabel.text = userMO.nickname;
    //cell.detailTextLabel.text = userMO.nickname;
    
    if (userMO.photo){
        cell.imageView.image = userMO.photo;
    }else{
        NSData *photoData = [[XMPPManager shareManager] photoDataForJID:userMO.jid];
        
        if (photoData){
            cell.imageView.image = [UIImage imageWithData:photoData];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"logo"];
        }
    }

    [cell layoutIfNeeded];

    //NSLog(@"objct = %@",object);
    /*
    NSString *name = [object displayName];
    
    NSLog(@"name = %@",name);
    
    if (!name) {
        name = [object nickname];
    }
    if (!name) {
        name = [object jidStr];
    }
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [[[object primaryResource] presence] status];
    cell.imageView.image = object.photo;
    //NSLog(@"image = %@",object.photo);
    NSLog(@"section = %@ , number = %@",object.sectionName,object.sectionNum);
    cell.tag = indexPath.row;*/
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *kCellHeaderViewID  = @"kUITableViewHeaderFooterViewID";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCellHeaderViewID];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kCellHeaderViewID];
        headerView.textLabel.font = [UIFont boldSystemFontOfSize:16];
        headerView.textLabel.textColor = [UIColor colorWithRed:0.210 green:0.538 blue:1.000 alpha:1.000];
        
        UIImage *image = [UIImage imageNamed:@"chat_bottom_textfield@2x"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 10, 30)];
        headerView.backgroundView = [[UIImageView alloc] initWithImage:image];
        
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [headerView addGestureRecognizer:tap];
        
    }
    
    
    //添加图标信息down_chat
    NSString *imageName = status[section] ? @"kk@2x" : @"left_chat@2x";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = CGRectMake(0, 22, 16, 16);
    imageView.tag = 1000;
    [headerView addSubview:imageView];
    

    
    /*
    NSArray *sectionArr = self.fetchedResultsController.sections;
    
    if (section < [sectionArr count]){
        id <NSFetchedResultsSectionInfo> sectionInfo = sectionArr[section];
        
        //从fetchedResultsController查询出来的数据 0表示在线，1表示离开，2表示离线
        int section = [sectionInfo.name intValue];
        switch (section){
            case 0:
                headerView.textLabel.text = @"在线";
                break;
            case 1:
                headerView.textLabel.text = @"离开";
                break;
            default:
                headerView.textLabel.text = @"离线";
        }
    }
    
    headerView.tag = 200+section;
     */
    XMPPGroupCoreDataStorageObject *groupMO = self.fetchedResultsController.fetchedObjects[section];
    headerView.textLabel.text = groupMO.name;
    headerView.textLabel.textColor = [UIColor blackColor];
    headerView.tag = 200+section;

    
    return headerView;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSInteger section = tap.view.tag - 200;
    
    //NSLog(@"–––––––%@–––––––",tap.view);
    //NSLog(@"-------%@-------",[tap.view viewWithTag:1000]);
    
    status[section] = !status[section];
    
    //down_chat
    NSString *imageName = status[section] ? @"kk@2x" : @"left_chat@2x";
    UIImageView *imageView = [tap.view viewWithTag:1000];
    imageView.image = [UIImage imageNamed:imageName];
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}


/*
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *kCellHeader = @"kCellHeader";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCellHeader];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kCellHeader];
        headerView.textLabel.font = [UIFont boldSystemFontOfSize:20];
        headerView.textLabel.textColor = [UIColor orangeColor];
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [headerView addGestureRecognizer:tap];
    }
    
    headerView.tag = 200 + section;
    
    //NSLog(@"headerView = %@",headerView);
    
    headerView.textLabel.text = [self.dic allKeys][section];
    
    //NSLog(@"text = %@",headerView.textLabel.text);
    
    return headerView;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    NSInteger section = tap.view.tag - 200;
    
    status[section] = !status[section];
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}*/

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    XMPPUserCoreDataStorageObject *userMO = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    XMPPGroupCoreDataStorageObject *groupMO = self.fetchedResultsController.fetchedObjects[indexPath.section];
    XMPPUserCoreDataStorageObject *userMO = [groupMO.users allObjects][indexPath.row];
    
    ChatViewController *msgViewCtrl = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:msgViewCtrl animated:YES];
    msgViewCtrl.hidesBottomBarWhenPushed = YES;
    msgViewCtrl.xmppUserObject = userMO;
}

//单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60;
}

#pragma mark - Chat Delegate
- (void)friendStatusChange:(XMPPManager *)appD Presence:(XMPPPresence *)presence {
    
    for (XMPPUserCoreDataStorageObject *object in self.dataArray) {
        if ([object.jidStr isEqualToString:presence.fromStr] || [object.jidStr isEqualToString:presence.from.bare]) {
            [[[[object primaryResource] presence] childAtIndex:0] setStringValue:presence.status];
        }
    }
    [self.tableView reloadData];
}

@end
