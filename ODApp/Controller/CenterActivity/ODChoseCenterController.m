//
//  ODChoseCenterController.m
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODChoseCenterController.h"
#import "ChoseCenterCell.h"
#import "ODStorePlaceListModel.h"

@interface ODChoseCenterController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSArray *dataArray;


@end

@implementation ODChoseCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择中心";
    [self createCollectionView];
    [self getData];
}

#pragma mark - 请求数据

- (void)getData
{
    __weakSelf
    NSDictionary *parameter = @{@"show_type" : @"1",@"call_array":@"1"};
    [ODHttpTool getWithURL:ODUrlOtherStoreList parameters:parameter modelClass:[ODStorePlaceListModel class] success:^(ODStorePlaceListModelResponse *model)
    {
        weakSelf.dataArray = model.result;
        [weakSelf.collectionView reloadData];
    }
                   failure:^(NSError *error)
    {
        
    }];
}


#pragma mark - 初始化

- (void)createCollectionView {


    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];


    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.collectionView registerNib:[UINib nibWithNibName:@"ChoseCenterCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];


}


#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChoseCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];


    ODStorePlaceListModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.name;

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODStorePlaceListModel *model = self.dataArray[indexPath.row];
    NSString *storeId = [NSString stringWithFormat:@"%d",model.id];
    if (self.storeCenterNameBlock)
    {
        self.storeCenterNameBlock(model.name, storeId, model.id);
    }
    if (self.isRefreshBlock)
    {
        self.isRefreshBlock(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(kScreenSize.width, 45.5);


}

//动态设置每个分区的缩进量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//动态返回不同区的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);

}

//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


@end
