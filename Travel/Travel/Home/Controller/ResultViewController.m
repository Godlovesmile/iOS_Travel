//
//  ResultViewController.m
//  Travel
//
//  Created by Alice on 16/5/13.
//  Copyright © 2016年 Alice. All rights reserved.
//

#import "ResultViewController.h"

#import "PlaceCell.h"

#import "TravelListCell.h"

#import "NetworkManager.h"

#import "PlaceModel.h"

#import "TravelListModel.h"

@interface ResultViewController ()

@property (nonatomic,retain) NSMutableArray *placeArray;

@property (nonatomic,retain) NSMutableArray *storyArray;

@end

@implementation ResultViewController

#pragma mark ----------------懒加载---------------
- (NSMutableArray *)placeArray {
    if (!_placeArray) {
        _placeArray = [[NSMutableArray alloc] init];
    }
    return _placeArray;
}

- (NSMutableArray *)storyArray {
    
    if (!_storyArray) {
        _storyArray = [[NSMutableArray alloc] init];
    }
    return _storyArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //加载数据
    [self setSearchData];
    
    //注册单元格
    [self.tableView registerClass:[PlaceCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[TravelListCell class] forCellReuseIdentifier:@"travelCell"];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"leftArrow@2x.jpg"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                                                   style:(UIBarButtonItemStylePlain)
                                                                  target:self
                                                                  action:@selector(backToRootController)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)backToRootController {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark--------------------------设置数据---------------------
- (void)setSearchData {
    
    [NetworkManager GET:self.searchUrl success:^(id response) {
        NSDictionary *dataDic = response[@"data"];
        NSArray *placesArray = dataDic[@"places"];
        for (NSDictionary *dic in placesArray) {
            PlaceModel *model = [[PlaceModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.placeArray addObject:model];
        }
        NSArray *tripArray = dataDic[@"trips"];
        for (NSDictionary *dic in tripArray) {
            TravelListModel *tripModel = [[TravelListModel alloc] init];
            [tripModel setValuesForKeysWithDictionary:dic];
            [self.storyArray addObject:tripModel];
        }
        
        [self.tableView reloadData];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.placeArray.count;
    } else {
        return self.storyArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else {
        return kScreenWidth * 0.7;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.center = CGPointMake(kScreenWidth / 2, 30);
    if (section == 0) {
        titleLabel.text = @"目的地";
    } else {
        titleLabel.text = @"游记故事";
    }
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        PlaceModel *model = self.placeArray[indexPath.row];
        cell.placeModel = model;
        return cell;
    } else {
        TravelListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"travelCell" forIndexPath:indexPath];
        TravelListModel *tripModel = self.storyArray[indexPath.row];
        [cell setHotTravelWithImageModel:tripModel];
        return cell;
    }
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CountryDetailViewController *countryVC = [[CountryDetailViewController alloc] init];
        GCZPlaceModel *model = self.placeArray[indexPath.row];
        City *city = [[City alloc] init];
        city.type = model.type;
        city.ID = model.ID;
        countryVC.city = city;
        city.name = model.name;
        [self.navigationController pushViewController:countryVC animated:YES];
    } else {
        
        GCZTravelListTVC *travelTVC = [[GCZTravelListTVC alloc] init];
        GCZTravelListModel *model = self.storyArray[indexPath.row];
        travelTVC.travel_id = [NSString stringWithFormat:kTravelListUrl ,model.ID];
        travelTVC.travel_type = @"4";
        [self.navigationController pushViewController:travelTVC animated:YES];
        
    }
}
*/


@end
