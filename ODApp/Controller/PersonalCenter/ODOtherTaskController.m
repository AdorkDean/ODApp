//
//  ODOtherTaskController.m
//  ODApp
//
//  Created by zhz on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOtherTaskController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODTaskCell.h"
#import "ODBazaarModel.h"
#import "UIImageView+WebCache.h"
#import "ODBazaarDetailViewController.h"
#import "ODTabBarController.h"
#import "ODViolationsCell.h"
@interface ODOtherTaskController ()

<UIScrollViewDelegate,UICollectionViewDataSource , UICollectionViewDelegate>

@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , assign) NSInteger PageNumber;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) NSMutableArray *dataArray;



@end

@implementation ODOtherTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.PageNumber = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    self.navigationItem.title = @"他发起的任务";
    [self createCollection];
   
    
}

- (void)createCollection
{
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width,kScreenSize.height - 64) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODTaskCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODViolationsCell" bundle:nil] forCellWithReuseIdentifier:@"item1"];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downRefresh];
    }];
    
    
    self.collectionView .mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMoreData];
    }];
    
    
    
    [self.collectionView.mj_header beginRefreshing];
    
    [self.view addSubview:self.collectionView];
    
    
}

#pragma mark - 刷新
- (void)downRefresh
{
    
    self.PageNumber = 1;
    [self getData];
    
    
}


- (void)loadMoreData
{
    self.PageNumber++;
    [self getData];
    
}


- (void)getData
{
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.PageNumber];
    
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"suggest":@"0", @"task_status":@"0", @"page":countNumber, @"my":@"1" , @"open_id":self.openId};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
   
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kGetTaskUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([countNumber isEqualToString:@"1"]) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.noReusltLabel removeFromSuperview];
        }
        
        if (responseObject) {
            
            
            NSDictionary *result = responseObject[@"result"];
            NSArray *tasks = result[@"tasks"];
            
            
            for (NSDictionary *itemDict in tasks) {
                ODBazaarModel *model = [[ODBazaarModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            if (tasks.count == 0) {
                [weakSelf.collectionView.mj_footer noticeNoMoreData];
            }
            
        }
        
        if (weakSelf.dataArray.count == 0) {
            weakSelf.noReusltLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80)/2, kScreenSize.height/2, 80, 30) text:@"暂无任务" font:16 alignment:@"center" color:@"#000000" alpha:1];
            [weakSelf.view addSubview:weakSelf.noReusltLabel];
        }
        
        else{
            [weakSelf.collectionView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [ODProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    ODBazaarModel *model = self.dataArray[indexPath.row];
    NSString *status = [NSString stringWithFormat:@"%@" , model.task_status];
    
    if ([status isEqualToString:@"-1"]) {
        ODViolationsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item1" forIndexPath:indexPath];
        
        [cell.deleteButton removeFromSuperview];
        cell.model = model;
    
        return cell;
        
        
    }else{
        
        ODTaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
        
        cell.model = model;
        
        
        return cell;
        
    }
    
    
    
    
    
   
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
    
   
    
    
    ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc]init];
    ODBazaarModel *model = self.dataArray[indexPath.row];
    
    
    NSString *status = [NSString stringWithFormat:@"%@" , model.task_status];
    
    if ([status isEqualToString:@"-1"]) {
        
                        ;
    }else{
        
        bazaarDetail.task_id = [NSString stringWithFormat:@"%@",model.task_id];
        bazaarDetail.open_id = [NSString stringWithFormat:@"%@",model.open_id];
        bazaarDetail.task_status_name = model.task_status_name;
        [self.navigationController pushViewController:bazaarDetail animated:YES];
        
    }
    
    
    
    
    
  
       
    
}




//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width , 140);
    
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
    return CGSizeMake(0, 0);
    
}
//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
