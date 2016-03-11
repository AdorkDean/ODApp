//
//  ODOtherTaskController.m
//  ODApp
//
//  Created by zhz on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODOtherTaskController.h"
#import "MJRefresh.h"
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

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ODOtherTaskController


#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.PageNumber = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    self.navigationItem.title = @"他发起的任务";
    [self createCollection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化方法
- (void)createCollection
{
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width,kScreenSize.height - 64) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
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
#pragma mark - 获取数据
- (void)getData
{
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.PageNumber];
    
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"suggest"] = @"0";
    params[@"task_status"] = @"0";
    params[@"page"] = countNumber;
    params[@"my"] = @"1";
    params[@"open_id"] = self.openId;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlTaskList parameters:params modelClass:[ODBazaarTasksModel class] success:^(id model)
     {
         if ([countNumber isEqualToString:@"1"]) {
             [weakSelf.dataArray removeAllObjects];
             [weakSelf.noReusltLabel removeFromSuperview];
         }
         
         ODBazaarTasksModel *tasksModel = [model result];
         
         [weakSelf.dataArray addObjectsFromArray:tasksModel.tasks];
         
         [weakSelf.collectionView.mj_header endRefreshing];
         if (tasksModel.tasks.count == 0) {
             [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
         }
         else
         {
             [weakSelf.collectionView.mj_footer endRefreshing];
         }
         
         if (weakSelf.dataArray.count == 0) {
             weakSelf.noReusltLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80)/2, kScreenSize.height/2, 80, 30) text:@"暂无任务" font:16 alignment:@"center" color:@"#000000" alpha:1];
             [weakSelf.view addSubview:weakSelf.noReusltLabel];
         }
         
         else{
             [weakSelf.collectionView reloadData];
         }
         
     } failure:^(NSError *error) {
         [weakSelf.collectionView.mj_header endRefreshing];
         [weakSelf.collectionView.mj_footer endRefreshing];
         [ODProgressHUD showInfoWithStatus:@"网络异常"];
     }];
    
    
}
#pragma mark - UICollectionView 数据源方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
    
}
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
#pragma mark - UICollectionViewDelegate
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
#pragma mark - 事件方法
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

@end
