//
//  ODApplyListViewController.m
//  ODApp
//
//  Created by zhz on 16/2/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODApplyListViewController.h"
#import "ODCollectionCell.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODOthersInformationController.h"
#import "ODApplyModel.h"
@interface ODApplyListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic ,copy)NSString *open_id;


@end

@implementation ODApplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    
    self.page = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self getData];
    [self createCollectionView];
    
    self.navigationItem.title = @"TA们申请过";

}

- (void)getData
{
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.page];
    
    
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"activity_id":self.activity_id , @"page":countNumber , @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kGetApplyListUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                
                
                if ([countNumber isEqualToString:@"1"]) {
                    [self.dataArray removeAllObjects];
                }
                
                
                NSMutableDictionary *dic = responseObject[@"result"];
                
                for (NSMutableDictionary *miniDic in dic) {
                    ODApplyModel *model = [[ODApplyModel alloc] init];
                    [model setValuesForKeysWithDictionary:miniDic];
                    [self.dataArray addObject:model];
                }
                
                
                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.collectionView.mj_footer endRefreshing];
                [weakSelf.collectionView reloadData];

                
                if (dic.count == 0)
                {
                    [weakSelf.collectionView.mj_footer noticeNoMoreData];
                
                }
                

                
                
            }else if ([responseObject[@"status"]isEqualToString:@"error"]) {
                
                
            
                
                [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];
              
                
                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.collectionView.mj_footer endRefreshing];
                [weakSelf.collectionView reloadData];

            }
            
            
            
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [ODProgressHUD showInfoWithStatus:@"网络异常"];
    }];
    
    
    
}

#pragma mark - 刷新
- (void)DownRefresh
{
    
    self.page = 1;
    [self getData];
    
}


- (void)LoadMoreData
{
    self.page++;
    [self getData];
    
}


#pragma mark - 初始化
-(void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 60) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self DownRefresh];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self LoadMoreData];
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    ODApplyModel *model = self.dataArray[indexPath.row];
   
    [cell setWithApplyModel:model];
    
    
    
    
    
    return cell;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    ODLikeModel *model = self.dataArray[indexPath.row];
    vc.open_id = model.open_id;
    if (![vc.open_id isEqualToString:[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].openID]]) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}


//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width , 68);
    
    
    
}

@end
