//
//  ODLandMainController.m
//  ODApp
//
//  Created by zhz on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODLandMainController.h"
#import "ODLandFirstCell.h"
#import "ODLandSecondCell.h"
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


@interface ODLandMainController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , UMSocialUIDelegate>{

}


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
    self.navigationController.navigationBarHidden = YES;
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark - 请求数据
- (void)getData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    
    NSDictionary *parameters = @{@"open_id":openId};
    
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
        
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kGetUserInformationUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSMutableDictionary *dic = responseObject[@"result"];
        weakSelf.model = [[ODUserModel alloc] initWithDict:dic];
        
        [weakSelf createCollectionView];
        [weakSelf.collectionView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}


#pragma mark - 初始化
-(void)createCollectionView
{
    
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, kScreenSize.width, kScreenSize.height - 55 - 20) collectionViewLayout:self.flowLayout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandFirstCell" bundle:nil] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandSecondCell" bundle:nil] forCellWithReuseIdentifier:@"second"];
    
    
    
    
    [self.view addSubview:self.collectionView];
    
    
    
    
}




#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        ODLandFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        
        
             
        
        cell.model = self.model;
        
        
        
              
        return cell;
        
    }else{
        ODLandSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        
        if (indexPath.section == 1) {
            cell.titleLabel.text = @"我的预约记录";
            
        }else if (indexPath.section == 2) {
            cell.titleLabel.text = @"我报名的活动";
            
        }else if (indexPath.section == 3) {
            cell.titleLabel.text = @"我的话题";
        }else if (indexPath.section == 4) {
            cell.titleLabel.text = @"我的任务";
        }
        
        
        else if (indexPath.section == 5) {
            cell.titleLabel.text = @"我收到的评价";
        }else if (indexPath.section == 6) {
            cell.titleLabel.text = @"我的订单";
        }
        
        else if (indexPath.section == 7) {
            
            cell.titleLabel.text = @"分享我们的app";
            cell.coverImageView.backgroundColor = [UIColor colorWithHexString:@"#ffd802" alpha:1];
            
        }else if (indexPath.section == 8) {
            
            cell.titleLabel.text = @"      退出登录";
            cell.titleLabel.textAlignment = NSTextAlignmentCenter;
            [cell.arrowImageView removeFromSuperview];
            
        }
        
        return cell;
        
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 9;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        ODInformationController *vc = [[ODInformationController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.section == 1){
        
        ODMyOrderRecordController *vc = [[ODMyOrderRecordController alloc] init];
        vc.open_id = self.model.open_id;
        vc.centerTitle = @"我的预约纪录";
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 2){
        
        ODMyApplyActivityController *vc = [[ODMyApplyActivityController alloc] init];
        
        vc.open_id = self.model.open_id;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section ==3) {
        
        ODMyTopicController *vc = [[ODMyTopicController alloc] init];
        
        vc.open_id = self.model.open_id;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section ==4) {
        
        ODMyTaskController *vc = [[ODMyTaskController alloc] init];
        
        vc.open_id = self.model.open_id;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 5) {
        
        ODUserEvaluationController *vc = [[ODUserEvaluationController alloc] init];
        
        vc.typeTitle = @"我收到的评价";
        vc.openId = [ODUserInformation sharedODUserInformation].openID;
        
        
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.section == 6) {
       
        
        ODMyOrderController *vc = [[ODMyOrderController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }
    else if (indexPath.section == 7) {
        
        NSString *url = self.model.share_download[@"icon"];
        NSString *content = self.model.share_download[@"desc"];
        NSString *link = self.model.share_download[@"link"];
        NSString *title = self.model.share_download[@"title"];
        
        
        
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"569dda54e0f55a994f0021cf"
                                          shareText:content
                                         shareImage:nil
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                           delegate:self];
      
        
        
        
    }
    else if (indexPath.section ==8) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ODTabBarController *tabBar = (ODTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            ;
            tabBar.selectedIndex = 0;
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            //清空数据
            [ODUserInformation sharedODUserInformation].openID = @"";
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:@"" forKey:KUserDefaultsOpenId];
            
            [self createProgressHUDWithAlpha:0.6f withAfterDelay:1.0 title:@"已退出登录"];
           
            tabBar.selectedIndex = tabBar.currentIndex;
    }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenSize.width , 80);
    }else {
        return CGSizeMake(kScreenSize.width , 40);
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
    
    return 4;
    
    
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
    if (section == 7) {
        return CGSizeMake(0, 30);
    }else{
        return CGSizeMake(0, 5);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
