//
//  ODMyAcceptTaskViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODMyAcceptTaskViewController.h"
#import "ODBazaarDetailViewController.h"
#import "ODBazaarModel.h"
#import "ODMyTaskCell.h"
#import "ODMyTaskViolationsCell.h"

@interface ODMyAcceptTaskViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic)NSInteger page;
@property(nonatomic,copy)NSString *type;
@property(nonatomic)NSInteger index;

@end

@implementation ODMyAcceptTaskViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.status = @"0";
    [self requestData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self requestData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationClick:) name:ODNotificationRefreshTask object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     if (self.type.length){
        ODBazaarModel *model = self.dataArray[self.index];
        model.task_status = self.type;
        [self.dataArray replaceObjectAtIndex:self.index withObject:model];
        [self.tableView reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.type = @"";
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - 数据请求
- (void)requestData {
    __weakSelf
    NSDictionary *parameter = @{@"suggest":@"0",@"task_status":self.status,@"page":[NSString stringWithFormat:@"%ld", (long) self.page],@"my":@"2"};
    [ODHttpTool getWithURL:ODUrlTaskList parameters:parameter modelClass:[ODBazaarTasksModel class] success:^(id model)
     {
         if (weakSelf.page == 1) {
             [weakSelf.dataArray removeAllObjects];
         }
         ODBazaarTasksModel *tasksModel = [model result];
         [weakSelf.dataArray addObjectsFromArray:tasksModel.tasks];
         
         [weakSelf.tableView.mj_header endRefreshing];
         if (tasksModel.tasks.count == 0) {
             [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
         }else{
             [weakSelf.tableView.mj_footer endRefreshing];
         }
         [weakSelf.tableView reloadData];
         
         ODNoResultLabel *noResultLabel = [[ODNoResultLabel alloc] init];
         if (weakSelf.dataArray.count == 0) {
             [noResultLabel showOnSuperView:weakSelf.tableView title:@"暂无任务"];
         }
         else
         {
             [noResultLabel hidden];
         }
     } failure:^(NSError *error) {
         [weakSelf.tableView.mj_header endRefreshing];
         [weakSelf.tableView.mj_footer endRefreshing];
         [ODProgressHUD showInfoWithStatus:@"网络异常"];
     }];
}

-(void)loadMoreData{
    self.page++;
    [self requestData];
}

#pragma mark - UITableViewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    ODBazaarModel *model = self.dataArray[indexPath.row];
    NSString *status = [NSString stringWithFormat:@"%@", model.task_status];
    if ([status isEqualToString:@"-1"]) {;
    } else {
        __weakSelf
        ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc] init];
        bazaarDetail.myBlock = ^(NSString *type) {
            weakSelf.type = type;
        };
        bazaarDetail.task_id = [NSString stringWithFormat:@"%@", model.task_id];
        bazaarDetail.open_id = [NSString stringWithFormat:@"%@", model.open_id];
        bazaarDetail.task_status_name = [NSString stringWithFormat:@"%@", model.task_status_name];
        self.index = indexPath.row;
        [self.navigationController pushViewController:bazaarDetail animated:YES];
    }
}

#pragma mark - action
-(void)notificationClick:(NSNotification *)text{
    self.status = text.userInfo[@"type"];
    [self.tableView.mj_header beginRefreshing];
}


@end
