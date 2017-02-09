//
//  NewFeatureControllerCollectionViewController.m
//  微博
//
//  Created by mac527 on 15/10/20.
//  Copyright © 2015年 mac527. All rights reserved.
//

#import "NewFeatureControllerCollectionViewController.h"

#import "NewFeatureCell.h"

@interface NewFeatureControllerCollectionViewController ()

@property(nonatomic,weak)UIPageControl *page;
@end

@implementation NewFeatureControllerCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置cell的尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    //清空行距
    layout.minimumLineSpacing = 0;
    //设置滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [super initWithCollectionViewLayout:layout];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self.collectionView registerClass:[NewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self createPageControl];
}

//添加pageController
- (void)createPageControl
{
    UIPageControl *page = [[UIPageControl alloc] init];
    page.numberOfPages = 3;
    page.pageIndicatorTintColor = [UIColor orangeColor];
    page.currentPageIndicatorTintColor = [UIColor redColor];
    
    page.center = CGPointMake(self.view.width*0.5, self.view.height*0.95);
    _page = page;
    [self.view addSubview:_page];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollerView代理
//只要一滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/kScreenWidth;
    _page.currentPage = page;
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //拼接图片
    NSString *imageName = [NSString stringWithFormat:@"f%ld",indexPath.row+1];
    cell.image = [UIImage imageNamed:imageName];
    [cell setIndexPath:indexPath Count:3];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
