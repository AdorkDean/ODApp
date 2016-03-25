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

@interface ODOtherTaskController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic)NSInteger page;

@end

@implementation ODOtherTaskController

#pragma mark - lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -6,kScreenSize.width, kScreenSize.height-58) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRGBString:@"#f3f3f3" alpha:1];
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
    
     __weakSelf
    self.page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"他发起的任务";
    [self getData];
   
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getData];
    }];
    
    self.tableView .mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getData];
    }];
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

#pragma mark - 获取数据
- (void)getData{
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
         
         [ODHttpTool od_endRefreshWith:weakSelf.tableView array:tasksModel.tasks];
         
         
         if (weakSelf.dataArray.count == 0) {
             [self.noResultLabel showOnSuperView:weakSelf.tableView title:@"暂无任务"];
         }else {
             [self.noResultLabel hidden];
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




@end
