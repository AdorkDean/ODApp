//
//  ODOthersInformationController.m
//  ODApp
//
//  Created by Bracelet on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODOthersInformationController.h"
#import "ODEvaluationController.h"
#import "ODOtherConfigInfoＭodel.h"
#import "ODInformViewController.h"

#import "ODCommunityHeaderView.h"


@implementation PersonCellData
@end





@interface ODOthersInformationController ()

@end

@implementation ODOthersInformationController {
    NSMutableArray *_cellData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    
    self.isOther = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(tapInformBtn) color:nil highColor:nil title:@"举报"];
    
    self.navigationItem.title = @"个人中心";
    [self createRequest];
}

- (void)tapInformBtn
{
    if (self.model != nil) {
        ODInformViewController *informVC = [[ODInformViewController alloc] init];
        informVC.objectId = self.model.open_id;
        informVC.type = @"4";
        [self.navigationController pushViewController:informVC animated:YES];
    }
}

- (void)initData
{
    _cellData = [NSMutableArray array];
    
    PersonCellData *topic = [[PersonCellData alloc] init];
    topic.title = @"他发表的话题";
    topic.type = kPersonCellTypeTopic;
    
    PersonCellData *reservation = [[PersonCellData alloc] init];
    reservation.title = @"他的预约中心";
    reservation.type = kPersonCellTypeReservation;
    
    PersonCellData *task = [[PersonCellData alloc] init];
    task.title = @"他发起的任务";
    task.type = kPersonCellTypeTask;
    
    PersonCellData *comment = [[PersonCellData alloc] init];
    comment.title = @"他收到的评价";
    comment.type = kPersonCellTypeComment;
    
    ODOtherConfigInfoModel *config = [[ODUserInformation sharedODUserInformation] getConfigCache];
    if (config == nil || config.auditing == 1) {
        [_cellData addObject:topic];
    } else {
        [_cellData addObject:reservation];
        [_cellData addObject:topic];
        [_cellData addObject:task];
        [_cellData addObject:comment];
    }
}

- (void)createRequest
{
    __weakSelf
    NSDictionary *parameter = @{@"open_id":self.open_id};
    [ODHttpTool getWithURL:ODUrlUserInfo parameters:parameter modelClass:[ODUserModel class] success:^(id model) {
        weakSelf.model = [model result];
        [weakSelf createCollectionView];
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
    }];
 }

- (void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - 20) collectionViewLayout:self.flowLayout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor backgroundColor];
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ODCommunityHeaderView class]) bundle:nil] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerClass:[ODCommunityHeaderView class] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandSecondCell" bundle:nil] forCellWithReuseIdentifier:@"second"];

    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ODCommunityHeaderView *headerView = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        headerView.data = self.model;
        return headerView;
    }
    else
    {
        PersonCellData *data = _cellData[indexPath.section - 1];
        ODLandSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        cell.titleLabel.text = data.title;
        return cell;
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _cellData.count + 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    
    PersonCellData *data = _cellData[indexPath.section - 1];
    
    switch (data.type) {
        case kPersonCellTypeReservation:
        {
            ODMyOrderRecordController *vc = [[ODMyOrderRecordController alloc] init];
            vc.open_id = self.model.open_id;
            vc.centerTitle = @"他的预约纪录";
            vc.isRefresh = YES;
            vc.isOther = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kPersonCellTypeTopic:
        {
            ODOtherTopicViewController *vc = [[ODOtherTopicViewController alloc] init];
            vc.open_id = self.model.open_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kPersonCellTypeTask:
        {
            ODOtherTaskController *vc = [[ODOtherTaskController alloc]init];
            vc.openId = self.model.open_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kPersonCellTypeComment:
        {
            ODEvaluationController *vc = [[ODEvaluationController alloc] init];
            vc.typeTitle = @"他收到的评价";
            vc.openId = self.model.open_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return CGSizeMake(kScreenSize.width , 80);
    }
    else
    {
        return CGSizeMake(kScreenSize.width , 30);
    }
}

//动态设置每个分区的缩进量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//动态返回不同区的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0,0);
}

//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 5);
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
