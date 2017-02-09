//
//  SearchViewController.m
//  Travel
//
//  Created by Alice on 16/2/28.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchCell.h"

#import "ResultViewController.h"

@interface SearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

//搜寻选项
@property (nonatomic,strong ) UICollectionView    *searchCV;

//选择按钮
@property (nonatomic,strong ) UISearchBar         *barSearch;

//查询的数据源
@property (nonatomic, retain) NSArray             *foreignArray;

@property (nonatomic, retain) NSArray             *inlandArray;


@end

@implementation SearchViewController

#pragma mark-----------------懒加载-----------------
- (UICollectionView *)searchCV {
    
    if (!_searchCV) {
        
        self.foreignArray = @[@"奈良市",@"札幌市",@"鹿儿岛县",@"小樽市",@"青森县",@"横滨市",@"镰仓市",@"广岛县",@"箱根町",@"泰国",@"韩国",@"美国",@"意大利",@"马来西亚",@"新加坡"];
        
        self.inlandArray = @[@"台湾",@"香港",@"厦门",@"北京",@"丽江",@"成都",@"上海",@"拉萨",@"西安",@"大理",@"三亚"];
        
        UICollectionViewFlowLayout *flowOut = [[UICollectionViewFlowLayout alloc] init];
        
        flowOut.minimumLineSpacing = kScreenWidth * 0.05;
        flowOut.minimumInteritemSpacing = kScreenWidth * 0.05;
        
        flowOut.sectionInset = UIEdgeInsetsMake(kScreenWidth * 0.1, 10, kScreenWidth * 0.1, 10);//分区内边距
        
        //itemSize 一行三列
        CGFloat itemWidth = (kScreenWidth - kScreenWidth * 0.2 - 20) / 3.0;
        CGFloat itemHeight = itemWidth / 2.5;
        
        flowOut.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        flowOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        flowOut.headerReferenceSize = CGSizeMake(kScreenWidth, kScreenWidth * 0.08);
        
        _searchCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0,  0, kScreenWidth, kScreenHeight) collectionViewLayout:flowOut];
        
        //设置数据源和代理
        _searchCV.dataSource = self;
        _searchCV.delegate = self;
        
        //注册
        [_searchCV registerClass:[SearchCell class] forCellWithReuseIdentifier:@"top"];
        
        [_searchCV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
        
        
        _searchCV.backgroundColor = [UIColor colorWithRed:0.0 / 255 green:190.9 / 255 blue:245.0 / 255 alpha:1.0];
        
    }
    return _searchCV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建搜寻列表
    [self.view addSubview:self.searchCV];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    //导航栏设置
    [self setupNavigation];
}

//设置导航栏
- (void)setupNavigation {
    
    //设置中间部位
    [self creataSearchBar];
    
    //设置右边部分
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 帮助事件
- (void)rightItemClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)creataSearchBar {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 120, 25)];
    self.barSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 120, 25)];
    self.barSearch.delegate = self;
    self.barSearch.layer.cornerRadius = 10;
    self.barSearch.placeholder = @"目的地 游记";
    self.barSearch.layer.masksToBounds = YES;
    self.barSearch.layer.borderWidth = 2;
    self.barSearch.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [titleView addSubview:self.barSearch];
    self.navigationItem.titleView = titleView;
    
    
}

#pragma mark------------CollectionView代理数据源---------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.foreignArray.count;
    }
    return self.inlandArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCell *top = [collectionView dequeueReusableCellWithReuseIdentifier:@"top" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        top.itemLabel.text = self.foreignArray[indexPath.item];
        
        //NSLog(@"top.itemLabel.text = %@",top.itemLabel.text);
    }else {
        top.itemLabel.text = self.inlandArray[indexPath.item];
        
        //NSLog(@"top.itemLabel.text = %@",top.itemLabel.text);
    }
    
    //top.backgroundColor = [UIColor yellowColor];
    return top;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.33, kScreenWidth * 0.1 - 10, kScreenWidth * 0.53, kScreenWidth * 0.1)];
    label.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        label.text = @"国外热门目的地";
        [headView addSubview:label];
    }else {
        label.text = @"国内热门目的地";
        [headView addSubview:label];
    }
    
    return headView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self.barSearch resignFirstResponder];
    //self.navigationItem.leftBarButtonItem.enabled = YES;
    
    NSString *searStr = NULL;
    if (indexPath.section == 0) {
        searStr = self.foreignArray[indexPath.row];
    } else {
        searStr = self.inlandArray[indexPath.row];
    }
    NSString *encodeSearStr = [searStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    ResultViewController *searResTVC = [[ResultViewController alloc] init];
    searResTVC.searchUrl = [NSString stringWithFormat:kSearchUrl, encodeSearStr];
    //GCZLog(@"%@", searResTVC.searchUrl);
    [self.navigationController pushViewController:searResTVC animated:YES];
}

#pragma mark ----------------SearchBar代理设置--------------

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(resignFirstResponderForSearchBar)];
//    //    [rightButton setTintColor:[UIColor whiteColor]];
//    self.navigationItem.rightBarButtonItem = rightButton;
//    //self.tableView.scrollEnabled = NO;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.searchCV.frame =  CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, kWidth, kHeight - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
//        [self.view.window addSubview:self.searchCV];
//    }];
//    self.navigationItem.leftBarButtonItem.enabled = NO;
//    
//}
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    
//    self.tableView.scrollEnabled = YES;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.searchCV.frame =  CGRectMake(0, - kHeight - 100, kWidth, kHeight - self.tabBarController.tabBar.frame.size.height);
//    }];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近"
//                                                                              style:(UIBarButtonItemStylePlain)
//                                                                             target:self
//                                                                             action:@selector(nearbyStoryWithRightButton)];
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
//    [self.barSearch resignFirstResponder];
//    
//    NSString *searchText = self.barSearch.text;
//    
//    NSString *encodeSearchText = [searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    
//    GCZSearchResultTVC *searResTVC = [[GCZSearchResultTVC alloc] init];
//    searResTVC.searchUrl = [NSString stringWithFormat:kSearchUrl, encodeSearchText];
//    [self.navigationController pushViewController:searResTVC animated:YES];
//    self.barSearch.text = nil;
//    self.navigationItem.leftBarButtonItem.enabled = YES;
//    
//    
//}
//
//- (void)resignFirstResponderForSearchBar {
//    self.tableView.scrollEnabled = YES;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.searchCV.frame =  CGRectMake(0, - kHeight - 100, kWidth, kHeight - self.tabBarController.tabBar.frame.size.height);
//    }];
//    self.barSearch.text = nil;
//    [self.barSearch resignFirstResponder];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近" style:(UIBarButtonItemStylePlain) target:self action:@selector(nearbyStoryWithRightButton)];
//    self.navigationItem.leftBarButtonItem.enabled = YES;
//}

@end
