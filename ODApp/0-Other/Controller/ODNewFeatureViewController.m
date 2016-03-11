//
//  ODNewFeatureViewController.m
//  ODApp
//
//  Created by 王振航 on 16/3/7.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODNewFeatureViewController.h"

#import "ODNewFeatureCell.h"

@interface ODNewFeatureViewController ()

/** 引导页图片 */
@property (nonatomic, weak) UIImageView *guideImageViews;

@end

@implementation ODNewFeatureViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - 生命周期方法
/**
 *  设置布局方式
 */
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化collectionView
    [self setupCollectionView];
}

#pragma mark - 初始化方法
/**
 *  初始化collectionView
 */
- (void)setupCollectionView
{
    // Register cell classes
    [self.collectionView registerClass:[ODNewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.bounces = NO;
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView.pagingEnabled = YES;
}

- (void)setupPageControl
{
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSString *imageName = [NSString stringWithFormat:@"begin%ld", indexPath.item + 1];
    cell.image = [UIImage imageNamed:imageName];
    
    [cell setIndex:indexPath imageCount:5];
    
    return cell;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat curOffsetX = scrollView.contentOffset.x;
    
    // 计算index
    NSInteger index = curOffsetX / scrollView.bounds.size.width + 1;
    
    self.guideImageViews.image = [UIImage imageNamed:[NSString stringWithFormat:@"begin%ld", index]];
}

@end

