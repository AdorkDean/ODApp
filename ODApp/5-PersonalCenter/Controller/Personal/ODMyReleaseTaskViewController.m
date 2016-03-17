//
//  ODMyReleaseTaskViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODMyReleaseTaskViewController.h"
#import "ODBazaarDetailViewController.h"
#import "ODBazaarModel.h"
#import "ODMyTaskCell.h"
#import "ODMyTaskViolationsCell.h"

@interface ODMyReleaseTaskViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic)NSInteger page;

@end

@implementation ODMyReleaseTaskViewController

#pragma mark - lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenSize.width, kScreenSize.height-64-43) style:UITableViewStylePlain];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 数据请求
- (void)requestReleaseData {
    __weakSelf
    NSDictionary *parameter = @{@"suggest":@"0",@"task_status":@"",@"page":[NSString stringWithFormat:@"%ld", (long) self.page],@"my":@"1"};
    [ODHttpTool getWithURL:ODUrlTaskList parameters:parameter modelClass:[ODBazaarTasksModel class] success:^(id model)
     {
         if (self.page == 1) {
             [weakSelf.dataArray removeAllObjects];
         }
         ODBazaarTasksModel *tasksModel = [model result];
         [weakSelf.dataArray addObjectsFromArray:tasksModel.tasks];
         [weakSelf.tableView reloadData];
     } failure:^(NSError *error) {
         [ODProgressHUD showInfoWithStatus:@"网络异常"];
     }];
}

-(void)loadMoreReleaseData{
    self.page++;
    [self requestReleaseData];
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
        ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc] init];
        bazaarDetail.myBlock = ^(NSString *del) {
        };
        bazaarDetail.task_id = [NSString stringWithFormat:@"%@", model.task_id];
        bazaarDetail.open_id = [NSString stringWithFormat:@"%@", model.open_id];
        bazaarDetail.task_status_name = [NSString stringWithFormat:@"%@", model.task_status_name];
        [self.navigationController pushViewController:bazaarDetail animated:YES];
    }
}




@end
