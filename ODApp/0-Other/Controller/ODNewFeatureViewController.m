//
//  ODNewFeatureViewController.m
//  ODApp
//
//  Created by 王振航 on 16/3/7.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODNewFeatureViewController.h"

#import "ODNewFeatureCell.h"
#import "MyPageControl.h"
#import "ODShopCartView.h"

@interface ODNewFeatureViewController ()

/** 引导页图片 */
@property (nonatomic, weak) UIImageView *guideImageViews;
/** 小圆点 */
@property (nonatomic, weak) MyPageControl *pageControl;

@end

/** 复用collectionCell标识 */
static NSString * const reuseIdentifier = @"newFeatureCell";
/** 图片个数 */
static NSInteger const imageCount = 4;

@implementation ODNewFeatureViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化collectionView
    [self setupCollectionView];
    
    // 初始化pageControll
    [self setupPageControl];
    
    // 清空购物车
    ODShopCartView  *shopCart = [ODShopCartView shopCart];
    [shopCart shopCartHeaderViewDidClickClearButton:nil];
}

#pragma mark - 初始化方法
/**
 *  设置布局方式
 */
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = kScreenSize;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [self initWithCollectionViewLayout:layout];
}

/**
 *  初始化collectionView
 */
- (void)setupCollectionView
{
    [self.collectionView registerClass:[ODNewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
}

- (void)setupPageControl
{
    CGRect frame = CGRectMake((KScreenWidth - 60) * 0.5, self.view.od_height * 0.93, 60, 30);
    MyPageControl *pageControl = [[MyPageControl alloc] initWithFrame:frame
                                                          normalImage:[UIImage imageNamed:@"noselected"]
                                                     highlightedImage:[UIImage imageNamed:@"selected"]
                                                           dotsNumber:(imageCount - 1) sideLength:15 dotsGap:10];
    pageControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

#pragma mark - UICollectionView 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"begin%zd", indexPath.item + 1];
    cell.image = [UIImage imageNamed:imageName];
    [cell setIndex:indexPath imageCount:imageCount];
    return cell;
}

#pragma mark - UIScrollView 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / KScreenWidth + 0.5;
    // 滚动pageControl
    self.pageControl.currentPage = index;
    
    // 根据滚动位置判断pageControl是否隐藏
    self.pageControl.hidden = (index == (imageCount - 1));
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat curOffsetX = scrollView.contentOffset.x;
    // 计算index
    NSInteger index = curOffsetX / scrollView.bounds.size.width + 1;
    self.guideImageViews.image = [UIImage imageNamed:[NSString stringWithFormat:@"begin%zd", index]];
}

@end

