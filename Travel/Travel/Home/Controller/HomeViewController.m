//
//  HomeViewController.m
//  Travel
//
//  Created by Alice on 16/2/27.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "HomeViewController.h"

#import "SearchBar.h"

#import "SearchViewController.h"

#import "BaseNavigationController.h"

#import "City.h"

#import "CityCell.h"

#import "TouristAttraction.h"

#import "CountryDetailView.h"

#import "AttractionDetailViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    int flag;  //标记作为进入程序第一次选中
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

//数据源
//table
@property(nonatomic,retain)NSMutableArray *allModelsArray;
//collection
@property(nonatomic,retain)NSMutableArray  *allAttractions;

@property(nonatomic,copy)NSString   *next;

@property(nonatomic,assign)NSInteger  currentCount;

@end

@implementation HomeViewController

//懒加载
-(NSMutableArray *)allAttractions{
    if (!_allAttractions) {
        _allAttractions = [[NSMutableArray alloc]init];
    }
    return _allAttractions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.next = @"0";
    
    //加载数据
    [self loadTableData];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_rightbottom_highlighted@2x"]];
    
    //tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //无分割线
    
    //collectionView
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //注册collectionCell
    [self.collectionView registerClass:[CountryDetailView class] forCellWithReuseIdentifier:@"collectionCellID"];
    
    //创建子控件
    [self createUI];
    
    /*
    City *city = self.allModelsArray[0];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self jsonOfTouristAttraction:city.type withID:city.ID];
    }];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentCount = 0;
        [self jsonOfTouristAttraction:city.type withID:city.ID];
    }];*/

}

- (void)createUI {

    //search控件
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake((kScreenWidth-250)/2, 80, 250, 30);
    //searchBtn.backgroundColor = [UIColor orangeColor];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchbar_input_bg@2x"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"icon_search_left"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索目的地" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
}

//加载tableView数据
- (void)loadTableData {
    
    [NetworkManager GET:@"http://api.breadtrip.com/destination/index_places/8/" success:^(id response) {
        
        self.allModelsArray = [NSMutableArray array];
        
        NSDictionary *rootDict = (NSDictionary *)response;
        NSArray *rootArray = rootDict[@"data"];
        for (NSDictionary *dict in rootArray) {
            City *city = [[City alloc]init];
            [city setValuesForKeysWithDictionary:dict];
            [self.allModelsArray addObject:city];
        }
        
        [self.tableView reloadData];
        [self.collectionView reloadData];
        //[self.tableView.mj_header endRefreshing];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil   message:@"网络不给力" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

//加载collectionView数据
- (void)loadCollectionData:(NSString *)type withID:(NSString *)ID {
    
    self.allAttractions = [NSMutableArray array];
    [NetworkManager GET:[NSString stringWithFormat:@"http://api.breadtrip.com/destination/place/%@/%@/pois/all/",type,ID] success:^(id response) {
        
        NSDictionary *rootDicts = (NSDictionary *)response;
        NSArray *rootArray = rootDicts[@"items"];
        for (NSDictionary *dict in rootArray) {
            TouristAttraction *touristAttraction = [[TouristAttraction alloc]init];
            [touristAttraction setValuesForKeysWithDictionary:dict];
            [self.allAttractions addObject:touristAttraction];
        }
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"loadImage" object:nil];
        //刷新collectionView
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        
    }];
}

#pragma mark - 帮助方法
- (void)searchClick {
    
    GKLog(@"点击查询");
    SearchViewController *searchCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    BaseNavigationController *navigationCtrl = [[BaseNavigationController alloc] initWithRootViewController:searchCtrl];
    //searchCtrl.view.backgroundColor = [UIColor cyanColor];
    [self presentViewController:navigationCtrl animated:YES completion:nil];
}

- (void)AlertDismiss:(UIAlertController *)alert {
    
    [alert dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataSource
//分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//组中有多少单元格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allModelsArray.count;
}

//自定义cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = @"cellID";
    CityCell *cityCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cityCell == nil) {
        cityCell = [[CityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    City *city = self.allModelsArray[indexPath.row];
    cityCell.city = city;
    
    //第一个cell的状态
    if (indexPath.row == 0 && flag == 0) {
        
        cityCell.selected = YES;
        cityCell.cityName.textColor = [UIColor whiteColor];
        flag++;
        
        //开始给collectionView赋初始化值
        City *city = self.allModelsArray[0];
        [self loadCollectionData:city.type withID:city.ID];
        //[self jsonOfTouristAttraction:city.type withID:city.ID];
    }
    
    return cityCell;
}

#pragma mark - UITableViewDelegate
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

//cell是否选中,改变字体的颜色
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row != 0) {
        CityCell *firstCell = [[tableView visibleCells] firstObject];
        firstCell.selected = NO;
        firstCell.cityName.textColor = [UIColor redColor];
    }
    cell.cityName.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //选中后的cell应该显示界面数据
    City *city = self.allModelsArray[indexPath.row];
    [self loadCollectionData:city.type withID:city.ID];
    //[self jsonOfTouristAttraction:city.type withID:city.ID];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.cityName.textColor = [UIColor redColor];
    
    //刷新滚动到最顶部
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //NSLog(@"allAttractions = %ld",self.allAttractions.count);
    return self.allAttractions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CountryDetailView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCellID" forIndexPath:indexPath];
    cell.tourist = self.allAttractions[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (self.collectionView.width - 20 * 3) / 2;
    CGSize itemSize = CGSizeMake(width, width);
    return itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 12, 10, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AttractionDetailViewController *attractionCtrl = [[AttractionDetailViewController alloc] init];
    TouristAttraction *tourist = self.allAttractions[indexPath.item];
    attractionCtrl.touristAttraction = tourist;
    
    [self presentViewController:attractionCtrl animated:YES completion:nil];
}
@end
