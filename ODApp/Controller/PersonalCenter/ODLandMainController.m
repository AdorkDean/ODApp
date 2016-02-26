//
//  ODLandMainController.m
//  ODApp
//
//  Created by zhz on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import "ODNavigationController.h"
#import "ODLandMainController.h"
#import "ODLandFirstCell.h"
#import "ODLandSecondCell.h"
#import "ODLandThirdCell.h"
#import "ODTabBarController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODUserModel.h"
#import "UIImageView+WebCache.h"
#import "ODInformationController.h"
#import "ODPersonalCenterViewController.h"
#import "ODMyTopicController.h"
#import "ODMyTopicController.h"
#import "ODMyTaskController.h"
#import "ODMyApplyActivityController.h"
#import "ODMyOrderRecordController.h"
#import "ODUserEvaluationController.h"
#import "UMSocial.h"
#import "ODMyOrderController.h"
#import "ODGiveOpinionController.h"
#import "ODOperationController.h"
#import "ODBalanceController.h"
#import "ODMySellController.h"
#import "ODEvaluationController.h"
@interface ODLandMainController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , UMSocialUIDelegate>

@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)ODUserModel *model;

@end

@implementation ODLandMainController

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![ODUserInformation sharedODUserInformation].openID.length)
        return;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"登录个人中心";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - 请求数据
- (void)getData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    NSDictionary *parameters = @{@"open_id":openId};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kGetUserInformationUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableDictionary *dic = responseObject[@"result"];
        weakSelf.model = [[ODUserModel alloc] initWithDict:dic];
        
        [weakSelf createCollectionView];
        [weakSelf.collectionView reloadData];
    }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
    }];
}

#pragma mark - 初始化
-(void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, kScreenSize.width, kScreenSize.height - 55 - 20) collectionViewLayout:self.flowLayout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
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
        cell.model = self.model;
        
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
    ODNavigationController *nav = [[ODNavigationController alloc]initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:vc action:@selector(backAction:) color:nil highColor:nil title:@"返回"];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)alreadyBuyAction:(UIButton *)sender
{
    ODMyOrderController *vc = [[ODMyOrderController alloc] init];
    ODNavigationController *nav = [[ODNavigationController alloc]initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:vc action:@selector(backAction:) color:nil highColor:nil title:@"返回"];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)releaseAction:(UIButton *)sender
{
    ODReleaseController *vc = [[ODReleaseController alloc] init];
    ODNavigationController *nav = [[ODNavigationController alloc]initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:vc action:@selector(backAction:) color:nil highColor:nil title:@"返回"];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)collectionAction:(UIButton *)button
{
    ODPersonalCenterCollectionViewController *vc = [[ODPersonalCenterCollectionViewController alloc]init];
    ODNavigationController *nav = [[ODNavigationController alloc]initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:vc action:@selector(backAction:) color:nil highColor:nil title:@"返回"];
   [self presentViewController:nav animated:YES completion:nil];
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
    if (indexPath.section != 10)
    {
        UIViewController *vc;
        if (indexPath.section == 0)
        {
            vc = [[ODInformationController alloc] init];
        }
        else if (indexPath.section == 2)
        {
            vc = [[ODMyOrderRecordController alloc] init];
            [(ODMyOrderRecordController *)vc setOpen_id:self.model.open_id];
            [(ODMyOrderRecordController *)vc setIsRefresh:YES];
            [(ODMyOrderRecordController *)vc setCenterTitle:@"我的预约纪录"];
        }
        else if (indexPath.section == 3)
        {
            vc = [[ODMyApplyActivityController alloc] init];
            [(ODMyApplyActivityController *)vc setOpen_id:self.model.open_id];
            [(ODMyApplyActivityController *)vc setIsRefresh:YES];
        }
        else if (indexPath.section ==4)
        {
            vc = [[ODMyTopicController alloc] init];
            [(ODMyTopicController *)vc setOpen_id:self.model.open_id];
        }
        else if (indexPath.section ==5)
        {
            vc = [[ODMyTaskController alloc] init];
            [(ODMyTaskController *)vc setOpen_id:self.model.open_id];
        }else if (indexPath.section == 6)
        {
            vc = [[ODEvaluationController alloc] init];
            [(ODEvaluationController *)vc setTypeTitle:@"我收到的评价"];
            NSString *openId = [ODUserInformation sharedODUserInformation].openID;
            [(ODEvaluationController *)vc setOpenId:openId];
        }
        else if (indexPath.section == 7)
        {
            vc = [[ODBalanceController alloc] init];
        }
        else if (indexPath.section == 8)
        {
            vc = [[ODOperationController alloc] init];
        }
        else if (indexPath.section == 9)
        {
            vc = [[ODGiveOpinionController alloc] init];
        }
        ODNavigationController *nav = [[ODNavigationController alloc]initWithRootViewController:vc];
        vc.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:vc action:@selector(backAction:) color:nil highColor:nil title:@"返回"];

        [self presentViewController:nav animated:YES completion:nil];
    }
    else if (indexPath.section == 10)
    {
        NSString *url = self.model.share[@"icon"];
        NSString *content = self.model.share[@"desc"];
        NSString *link = self.model.share[@"link"];
        NSString *title = self.model.share[@"title"];
        
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kGetUMAppkey
                                          shareText:content
                                         shareImage:nil
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                           delegate:self];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
