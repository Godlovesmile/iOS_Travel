//
//  AttractionDetailViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "AttractionDetailViewController.h"
//#import "MainScreenBound.h"
#import "TouristAttraction.h"
#import "AttractionCell.h"
//#import "MapKitViewController.h"
//#import "DescriptViewController.h"
//#import "UINavigationBar+Awesome.h"

//#import "SingleTonForTravel.h"


#define kIconImageX  -15
#define kIconImageY  0
#define kIconImageW  kScreenWidth+30
#define kIconImageH  230


#define kScrollViewX  0
#define kScrollViewY  0
#define kScrollViewW  kScreenWidth
#define kScrollViewH   kScreenHeight

#define NAVBAR_CHANGE_POINT 50

@interface AttractionDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIImageView *iconImage;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,retain)NSMutableDictionary   *messageDict;

@property(nonatomic,retain)NSArray  *keyArray;



@end

@implementation AttractionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    self.view.backgroundColor = [UIColor whiteColor];
    

    //[self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.iconImage];//添加图片
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.touristAttraction.cover]];
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    //区头视图
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
    self.tableView.tableHeaderView = headLabel;
    self.tableView.separatorStyle = NO;

    [self.tableView registerClass:[AttractionCell class] forCellReuseIdentifier:@"recommandCell"];
    
    //创建返回的按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"leftArrow@2x.jpg"] forState:UIControlStateNormal];
    //[backBtn sizeToFit];
    backBtn.frame = CGRectMake(10, 15, 50, 50);
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view insertSubview:backBtn atIndex:0];
    [self.view addSubview:backBtn];
    
}

//按钮点击事件
- (void)backAction:(UIBarButtonItem *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark------------collection------------------
/*
- (void)collectionAction:(UIBarButtonItem *)buttonItem
{
    
    if (![SingleTonForTravel shareTravelSingleTon].isLogin) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲，收藏请先登录喔(*^__^*)" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        if ([[TravelFMDataBase shareTravelDataBase] selectRowWithTravelName:self.touristAttraction.name tableName:@"TouristAttractionDeail"]) {
            [buttonItem  setImage:[[UIImage imageNamed:@"yw_detail_collecticon@3x"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
            [[TravelFMDataBase shareTravelDataBase] deleteRowFromTableWithTravelName:self.touristAttraction.name tableName:@"TouristAttractionDeail"];
        }else{
            [buttonItem  setImage:[[UIImage imageNamed:@"yw_detail_collectedicon@3x"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
            [[TravelFMDataBase shareTravelDataBase] insertRowToTableWithTouristAttractionModel:self.touristAttraction tableName:@"TouristAttractionDeail"];
        }
    }
}
*/
#pragma mark------------lazy------------------

- (NSArray *)keyArray {
    
    if (!_keyArray) {
        _keyArray = [NSArray arrayWithObjects:@"概述",@"地址",@"到达方式",@"开放时间",@"门票价格",@"联系方式",@"官方网站", nil];
    }
    return _keyArray;
}


-(UIImageView *)iconImage {
    
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
    }
    return _iconImage;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kIconImageY, kScreenWidth, kScreenHeight) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableDictionary *)messageDict {
    
    if (!_messageDict) {
        
        _messageDict = [NSMutableDictionary dictionary];
        if (self.touristAttraction.tips.count == 0) {
            [NetworkManager GET:[NSString stringWithFormat:@"http://api.breadtrip.com/destination/place/%@/%@/",self.touristAttraction.type,self.touristAttraction.ID] success:^(id response) {
                NSDictionary *rootDict = (NSDictionary *)response;
                [_messageDict setValue:rootDict[@"description"] forKey:@"概述"];
                [_messageDict setValue:rootDict[@"address"] forKey:@"地址"];
                [_messageDict setValue:rootDict[@"arrival_type"] forKey:@"到达方式"];
                [_messageDict setValue:rootDict[@"opening_time"] forKey:@"开放时间"];
                [_messageDict setValue:rootDict[@"fee"] forKey:@"门票价格"];
                [_messageDict setValue:rootDict[@"tel"] forKey:@"联系方式"];
                [_messageDict setValue:rootDict[@"website"] forKey:@"官方网站"];
                [self.tableView reloadData];
            } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                
            }];
        }
        else {
            NSDictionary *dict = self.touristAttraction.tips[0];
            NSDictionary *poiDict = dict[@"poi"];
            
            [_messageDict setValue:poiDict[@"description"] forKey:@"概述"];
            [_messageDict setValue:self.touristAttraction.address forKey:@"地址"];
            [_messageDict setValue:poiDict[@"arrival_type"] forKey:@"到达方式"];
            [_messageDict setValue:poiDict[@"opening_time"] forKey:@"开放时间"];
            [_messageDict setValue:self.touristAttraction.fee forKey:@"门票价格"];
            [_messageDict setValue:self.touristAttraction.tel forKey:@"联系方式"];
            [_messageDict setValue:self.touristAttraction.website forKey:@"官方网站"];
        }
    }
    return _messageDict;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIColor * color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        self.iconImage.transform = CGAffineTransformMakeScale(1-offsetY/100, 1-offsetY/100);
    } else if (offsetY>0 && offsetY < self.iconImage.frame.size.height) {
        self.iconImage.frame = CGRectMake(kIconImageX, kIconImageY-offsetY/10,kIconImageW, kIconImageH);
    }
    
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        //[self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        //[self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        
    }
}



#pragma mark------------datasource------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageDict.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        AttractionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommandCell"];
        cell.nameLabel.text = self.touristAttraction.name;
        cell.recommandLabel.text = self.touristAttraction.recommended_reason;
        
        //NSLog(@"cell.nameLabel.text = %@",cell.nameLabel.text);
        return cell;
        
    }else{
        
    NSString *idetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:idetifier];
        }
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 7) {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    cell.textLabel.text = self.keyArray[indexPath.row-1];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.text = self.messageDict[self.keyArray[indexPath.row-1]];

    cell.detailTextLabel.numberOfLines = 3;
    return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        return 120;
    }else{
       return 60;
    }
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.row == 6) {//拨打电话
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.touristAttraction.tel message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {

        }];
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"呼叫" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[ NSString stringWithFormat:@"tel:%@",self.touristAttraction.tel]]];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:callAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (indexPath.row == 2){//地址
        
        MapKitViewController *mapKitVC = [[MapKitViewController alloc]init];
        mapKitVC.touristAttraction = self.touristAttraction;
        [self.navigationController pushViewController:mapKitVC animated:YES];
        
    }else if (indexPath.row == 1){
        DescriptViewController *descripVC = [[DescriptViewController alloc]init];
        descripVC.descript = self.touristAttraction.descript;
        [self.navigationController pushViewController:descripVC animated:YES];
    }
}
*/
@end
