//
//  ODUserEvaluationController.m
//  ODApp
//
//  Created by zhz on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODUserEvaluationController.h"
#import "MJRefresh.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "ODEvaluationCell.h"
#import "ODEvaluationModel.h"
#import "ODTabBarController.h"
@interface ODUserEvaluationController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) NSInteger pageNumber;
@end

@implementation ODUserEvaluationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNumber = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = self.typeTitle;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createCollectionView];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downRefresh];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMoreData];
    }];


    [self getData];
    
}


-(void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];


    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width,KControllerHeight) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ODEvaluationCell class] forCellWithReuseIdentifier:@"item"];
    
    [self.view addSubview:self.collectionView];
}

- (void)downRefresh
{
    self.pageNumber = 1;
    [self getData];

}

- (void)loadMoreData
{
    self.pageNumber++;
    [self getData];

}

- (void)getData
{
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.pageNumber];
//
//    
//    self.manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = @{@"type":@"1", @"page":countNumber, @"open_id":self.openId};
//    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"1";
    params[@"page"] = countNumber;
    params[@"open_id"] = self.openId;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlUserCommentList parameters:params modelClass:[ODEvaluationModel class] success:^(id model)
     {
         if ([countNumber isEqualToString:@"1"]) {
             [weakSelf.dataArray removeAllObjects];
             [weakSelf.noReusltLabel removeFromSuperview];
         }
         
         NSArray *evaluationDatas = [model result];
         [weakSelf.dataArray addObjectsFromArray:evaluationDatas];

         [weakSelf.collectionView.mj_header endRefreshing];

         if (evaluationDatas.count == 0) {
             [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
         }
         else
         {
             [weakSelf.collectionView.mj_footer endRefreshing];
         }

         if (weakSelf.dataArray.count == 0) {
             weakSelf.noReusltLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80)/2, kScreenSize.height/2, 80, 30) text:@"暂无评价" font:16 alignment:@"center" color:@"#000000" alpha:1];
             [weakSelf.view addSubview:self.noReusltLabel];
         }
         else
         {
             [weakSelf.collectionView reloadData];
         }

     } failure:^(NSError *error) {
         [weakSelf.collectionView.mj_header endRefreshing];
         [weakSelf.collectionView.mj_footer endRefreshing];
     }];
    
    
//    [self.manager GET:ODUrlUserCommentList parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        if ([countNumber isEqualToString:@"1"]) {
//            [weakSelf.dataArray removeAllObjects];
//            [weakSelf.noReusltLabel removeFromSuperview];
//        }
//     
//        if (responseObject) {
//
//            NSMutableDictionary *dic = responseObject[@"result"];
//            for (NSMutableDictionary *miniDic in dic) {
//                ODEvaluationModel *model = [[ODEvaluationModel alloc] init];
//                [model setValuesForKeysWithDictionary:miniDic];
//                [weakSelf.dataArray addObject:model];
//      
//            }
//
//            [weakSelf.collectionView.mj_header endRefreshing];
//            
//            
//            
//            if (dic.count == 0) {
//                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
//            }
//            else
//            {
//                [weakSelf.collectionView.mj_footer endRefreshing];
//            }
//            
//            if (weakSelf.dataArray.count == 0) {
//                weakSelf.noReusltLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80)/2, kScreenSize.height/2, 80, 30) text:@"暂无评价" font:16 alignment:@"center" color:@"#000000" alpha:1];
//                [weakSelf.view addSubview:self.noReusltLabel];
//            }
//            
//            else{
//                [weakSelf.collectionView reloadData];
//            }
//        }
//   
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//  
//        [weakSelf.collectionView.mj_header endRefreshing];
//        [weakSelf.collectionView.mj_footer endRefreshing];
//       [ODProgressHUD showInfoWithStatus:@"网络异常"];
//        
//    }];
  
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODEvaluationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.dataArray[indexPath.row];
    
    
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


//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width , [ODEvaluationCell returnHight:self.dataArray[indexPath.row]]);
    
    
    
}
//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
