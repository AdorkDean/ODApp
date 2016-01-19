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
@interface ODLandMainController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;

@property(nonatomic,strong)ODUserModel *model;

@end

@implementation ODLandMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self navigationInit];
    
    
    
    
}

#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{

    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 1;

    [self getData];
}


#pragma mark - 请求数据
- (void)getData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    

    
    NSString *openId = [ODUserInformation getData].openID;
    
    
    NSDictionary *parameters = @{@"open_id":openId};

    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/user/info";
    
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                 
         NSMutableDictionary *dic = responseObject[@"result"];
        self.model = [[ODUserModel alloc] initWithDict:dic];
        
         [self createCollectionView];
        [self.collectionView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];

}


#pragma mark - 初始化

-(void)navigationInit
{
    

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
       
}

-(void)createCollectionView
{
    
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, kScreenSize.width, kScreenSize.height - 20) collectionViewLayout:self.flowLayout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [ODColorConversion colorWithHexString:@"#d9d9d9" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandFirstCell" bundle:nil] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandSecondCell" bundle:nil] forCellWithReuseIdentifier:@"second"];
    
    
    
    
    [self.view addSubview:self.collectionView];
    
    
    
    
}




#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        ODLandFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        
        
        cell.userImageView.layer.masksToBounds = YES;
        cell.userImageView.layer.cornerRadius = 35;
        cell.userImageView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.userImageView.layer.borderWidth = 1;
        
        
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar]];
        [cell.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:self.model.qrcode]];
        

        if ([self.model.nick isEqualToString:@""]) {
           cell.nickNameLabel.text = [NSString stringWithFormat:@"您还未设置昵称"];
        }else{
           cell.nickNameLabel.text = self.model.nick;
            
        }

        if ([self.model.sign isEqualToString:@""]) {
            cell.signatureLabel.text = [NSString stringWithFormat:@"您还未设置签名"];
        }else{
            cell.signatureLabel.text = self.model.sign;
            
        }
        
        return cell;

    }else{
        ODLandSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        
        if (indexPath.section == 1) {
            cell.titleLabel.text = @"我的中心预约";
            
        }else if (indexPath.section == 2) {
            cell.titleLabel.text = @"我报名的活动";

        }else if (indexPath.section == 3) {
            cell.titleLabel.text = @"我的话题";
        }else if (indexPath.section == 4) {
            cell.titleLabel.text = @"我的任务";
        }else if (indexPath.section == 5) {
             cell.titleLabel.text = @"我收到的评价";
        }
        
        else if (indexPath.section == 6) {
          
            cell.titleLabel.text = @"分享我们的app";
            cell.coverImageView.backgroundColor = [ODColorConversion colorWithHexString:@"#ffd802" alpha:1];
            
        }else if (indexPath.section == 7) {
            
            cell.titleLabel.text = @"      退出登录";
            cell.titleLabel.textAlignment = NSTextAlignmentCenter;
            [cell.arrowImageView removeFromSuperview];
          
        }
    
        return cell;
        
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 8;
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
        vc.centerTitle = @"我的中心预约";
        
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
        vc.openId = [ODUserInformation getData].openID;
        
        
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
     else if (indexPath.section ==7) {
         ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
         tabBar.selectedIndex = 0;
        [self.navigationController popViewControllerAnimated:YES];
       
         [ODUserInformation getData].openID = nil;



         
         if (self.navigationController.viewControllers.count > 1)
         {
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             tabBar.selectedIndex = tabBar.currentIndex;
             
             NSInteger index = tabBar.selectedIndex;
             for (NSInteger i = 0; i < 5; i++)
             {
                 UIButton *newButton = (UIButton *)[tabBar.imageView viewWithTag:1+i];
                 newButton.selected = i == index;
             }
         }
    }
}

//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
         return CGSizeMake(kScreenSize.width , 90);
    }else {
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
    if (section == 6) {
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
