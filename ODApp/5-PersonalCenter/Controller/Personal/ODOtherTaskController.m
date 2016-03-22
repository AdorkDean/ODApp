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
#import "UIImageView+WebCache.h"
#import "ODTabBarController.h"

#import "ODBazaarDetailViewController.h"
#import "ODBazaarModel.h"
#import "ODMyTaskCell.h"
#import "ODMyTaskViolationsCell.h"

@interface ODOtherTaskController ()

<UIScrollViewDelegate,UICollectionViewDataSource , UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , assign) NSInteger PageNumber;


@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic)NSInteger page;

@end

@implementation ODOtherTaskController

#pragma mark - lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenSize.width, kScreenSize.height-64-50) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ODMyTaskCell" bundle:nil] forCellReuseIdentifier:@"first"];
        [_tableView registerNib:[UINib nibWithNibName:@"ODMyTaskViolationsCell" bundle:nil] forCellReuseIdentifier:@"second"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"他发起的任务";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
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
    
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.PageNumber = 1;
        [weakSelf downRefresh];
    }];
    
    
    self.collectionView .mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.PageNumber++;
        [weakSelf loadMoreData];
    }];
    
    
    
    [self.collectionView.mj_header beginRefreshing];
    
    [self.view addSubview:self.collectionView];
    
    
}
#pragma mark - 获取数据
- (void)getData
{

    NSDictionary *params = @{@"suggest":@"0",@"task_status":@"0",@"page":[NSString stringWithFormat:@"%ld", (long) self.page],@"my":@"1",@"open_id":self.openId};
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlTaskList parameters:params modelClass:[ODBazaarTasksModel class] success:^(id model)
     {
         if (weakSelf.page == 1) {
             [weakSelf.dataArray removeAllObjects];
         }
         
         ODBazaarTasksModel *tasksModel = [model result];
         [weakSelf.dataArray addObjectsFromArray:tasksModel.tasks];
         
         [weakSelf.collectionView.mj_header endRefreshing];
         if (tasksModel.tasks.count == 0) {
             [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         }else{
             [weakSelf.tableView.mj_footer endRefreshing];
         }
         [weakSelf.tableView reloadData];
         
         ODNoResultLabel *noResultabel = [[ODNoResultLabel alloc] init];
         if (weakSelf.dataArray.count == 0) {
             [noResultabel showOnSuperView:weakSelf.collectionView title:@"暂无任务"];
         }
         else {
             [noResultabel hidden];
         }
     } failure:^(NSError *error) {
         [weakSelf.tableView.mj_header endRefreshing];
         [weakSelf.tableView.mj_footer endRefreshing];
         [ODProgressHUD showInfoWithStatus:@"网络异常"];
     }];
    
    
}
#pragma mark - UITableViewDataSource 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarModel *model = self.dataArray[indexPath.row];
    if ([model.task_status isEqualToString:@"-1"]) {
        ODMyTaskViolationsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"second"];
        cell.model = self.dataArray[indexPath.row];
        cell.deleteButton.hidden = YES;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 75, 15, 15)];
        imageView.image = [UIImage imageNamed:@"weigui"];
        [cell.contentView addSubview:imageView];
        return cell;
    }else{
        ODMyTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"first"];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
}
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    
//    return self.dataArray.count;
//    
//}
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ODBazaarModel *model = self.dataArray[indexPath.row];
//    NSString *status = [NSString stringWithFormat:@"%@" , model.task_status];
//    
//    if ([status isEqualToString:@"-1"]) {
////        ODViolationsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item1" forIndexPath:indexPath];
//        
////        [cell.deleteButton removeFromSuperview];
////        cell.model = model;
////        
////        return cell;
//        
//        
//    }else{
//        
////        ODTaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
////        
////        cell.model = model;
////        
////        
////        return cell;
////        
//    }
//    
//    return nil;
//}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc]init];
    ODBazaarModel *model = self.dataArray[indexPath.row];
    if ([model.task_status isEqualToString:@"-1"]) {
    }else{
        bazaarDetail.task_id = [NSString stringWithFormat:@"%@",model.task_id];
        bazaarDetail.open_id = [NSString stringWithFormat:@"%@",model.open_id];
        bazaarDetail.task_status_name = model.task_status_name;
        [self.navigationController pushViewController:bazaarDetail animated:YES];
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
