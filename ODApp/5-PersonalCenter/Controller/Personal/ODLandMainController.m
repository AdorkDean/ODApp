//
//  ODLandMainController.m
//  ODApp
//
//  Created by zhz on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODLandMainController.h"
#import "ODLandFirstCell.h"
#import "ODLandSecondCell.h"
#import "ODLandThirdCell.h"
#import "ODTabBarController.h"
#import "ODUserModel.h"
#import "UIImageView+WebCache.h"
#import "ODInformationController.h"
#import "ODPersonalCenterViewController.h"
#import "ODMyTopicController.h"
#import "ODMyTopicController.h"
#import "ODMyTaskController.h"
#import "ODMyApplyActivityController.h"
#import "ODMyOrderRecordController.h"
#import "UMSocial.h"
#import "ODMyOrderController.h"
#import "ODGiveOpinionController.h"
#import "ODOperationController.h"
#import "ODBalanceController.h"
#import "ODMySellController.h"
#import "ODEvaluationController.h"
#import "WXApi.h"


@interface ODLandMainController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , UMSocialUIDelegate, ODInformationControllerDelegate>

@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;

@end

@implementation ODLandMainController

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![ODUserInformation sharedODUserInformation].openID.length)
        return;
    self.navigationItem.title = @"个人中心";
    
    [self createCollectionView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 初始化
-(void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - ODNavigationHeight) collectionViewLayout:self.flowLayout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandFirstCell" bundle:nil] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandSecondCell" bundle:nil] forCellWithReuseIdentifier:@"second"];
    [self.collectionView registerClass:[ODLandThirdCell class] forCellWithReuseIdentifier:@"third"];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ODLandFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        ODUserModel *user = [[ODUserInformation sharedODUserInformation] getUserCache];
        cell.model = user;
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        ODLandThirdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"third" forIndexPath:indexPath];
        
        [cell.buyButton addTarget:self action:@selector(alreadyBuyAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.collectionButton addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.releaseButton addTarget:self action:@selector(releaseAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sellButton addTarget:self action:@selector(mySellAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else
    {
        ODLandSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        cell.coverImageView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        if (indexPath.section == 2)
        {
            cell.titleLabel.text = @"我的中心预约";
        }
        else if (indexPath.section == 3)
        {
            cell.titleLabel.text = @"我报名的活动";
        }
        else if (indexPath.section == 4)
        {
            cell.titleLabel.text = @"我的话题";
        }
        else if (indexPath.section == 5)
        {
            cell.titleLabel.text = @"我的任务";
        }
        else if (indexPath.section == 6)
        {
            cell.titleLabel.text = @"我收到的评价";
        }
        else if (indexPath.section == 7)
        {
            cell.titleLabel.text = @"余额";
        }else if (indexPath.section == 8)
        {
            cell.titleLabel.text = @"设置";
        }
        else if (indexPath.section == 9)
        {
            cell.titleLabel.text = @"意见反馈";
        }
        else if (indexPath.section == 10)
        {
            cell.titleLabel.text = @"分享我们的app";
            cell.coverImageView.backgroundColor = [UIColor colorWithHexString:@"#ffd802" alpha:1];
        }
        
        return cell;
    }
}

- (void)mySellAction:(UIButton *)sender
{
    ODMySellController *vc = [[ODMySellController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)alreadyBuyAction:(UIButton *)sender
{
    ODMyOrderController *vc = [[ODMyOrderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)releaseAction:(UIButton *)sender
{
    ODReleaseController *vc = [[ODReleaseController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collectionAction:(UIButton *)button
{
    ODPersonalCenterCollectionController *collection = [[ODPersonalCenterCollectionController alloc]init];
    [self.navigationController pushViewController:collection animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 11;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODUserModel *user = [[ODUserInformation sharedODUserInformation] getUserCache];
    if (indexPath.section == 0)
    {
        ODInformationController *vc = [[ODInformationController alloc] init];
        // 设置代理
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 2)
    {
        ODMyOrderRecordController *vc = [[ODMyOrderRecordController alloc] init];
        vc.open_id = user.open_id;
        vc.isRefresh = YES;
        vc.centerTitle = @"我的预约纪录";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 3)
    {
        ODMyApplyActivityController *vc = [[ODMyApplyActivityController alloc] init];
        vc.isRefresh = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section ==4)
    {
        ODMyTopicController *vc = [[ODMyTopicController alloc] init];
        vc.open_id = user.open_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section ==5)
    {
        ODMyTaskController *vc = [[ODMyTaskController alloc] init];
        vc.open_id = user.open_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 6)
    {
        ODEvaluationController *vc = [[ODEvaluationController alloc] init];
        vc.typeTitle = @"我收到的评价";
        NSString *openId = [ODUserInformation sharedODUserInformation].openID;
        vc.openId = openId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 7)
    {
        ODBalanceController *vc = [[ODBalanceController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 8)
    {
        ODOperationController *vc = [[ODOperationController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 9)
    {
        ODGiveOpinionController *vc = [[ODGiveOpinionController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
   else if (indexPath.section == 10){
        [ODPublicTool shareAppWithTarget:self dictionary:(NSDictionary *)user.share controller:self];
    }
}



//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1)
    {
        return CGSizeMake(kScreenSize.width , 80);
    }
    else
    {
        return CGSizeMake(kScreenSize.width , 40);
    }
}

//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 5);
}

#pragma mark - ODInformationViewController 代理方法
- (void)infoVc:(ODInformationController *)infoVc DidChangedUserImage:(ODUserModel *)userModel
{
    // 更新缓存
    [[ODUserInformation sharedODUserInformation] updateUserCache:userModel];
    [self.collectionView reloadData];
}

#pragma mark - umeng

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
