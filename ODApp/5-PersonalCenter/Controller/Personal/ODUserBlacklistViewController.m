//
//  ODUserBlacklistViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/4/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODUserBlacklistViewController.h"
#import "MJRefresh.h"

@interface ODUserBlacklistViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic)NSInteger page;

@end

@implementation ODUserBlacklistViewController

#pragma mark - lazyload
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor backgroundColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weakSelf
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^ {
        weakSelf.page = 1;
        [weakSelf requestData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf requestData];
    }];

}

#pragma mark - 数据请求
- (void)requestData{
    __weakSelf
    [ODHttpTool getWithURL:ODUrlTakeOutOrderList parameters:nil modelClass:[NSObject class] success:^(id model) {
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        [ODHttpTool od_endRefreshWith:weakSelf.tableView array:weakSelf.dataArray];
        if (weakSelf.dataArray.count == 0) {
            [weakSelf.noResultLabel showOnSuperView:weakSelf.tableView title:@"暂无订单"];
        }
        else {
            [weakSelf.noResultLabel hidden];
        }
    } failure:^(NSError *error) {
    }];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
