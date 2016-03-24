//
//  ODReleaseController.m
//  ODApp
//
//  Created by Bracelet on 16/2/18.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODReleaseController.h"
#import "ODBazaarExchangeSkillDetailViewController.h"

#import "ODReleaseView.h"

NSString * const ODReleaseViewID = @"ODReleaseViewID";
@interface ODReleaseController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) ODReleaseModel *model;

// 列表数组
@property(nonatomic, strong) NSMutableArray *dataArray;

// 数据页数
@property(nonatomic, assign) int pageCount;

// 记录删除了哪一行
@property (nonatomic, assign) long deleteRow;

// 记录点击了哪一行
@property (nonatomic, assign) long loveRow;

@end

@implementation ODReleaseController

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight + 6) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 144;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODReleaseView class]) bundle:nil] forCellReuseIdentifier:ODReleaseViewID];
        [self.view addSubview:_tableView];
        
        __weakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^ {
            weakSelf.pageCount = 1;
            [weakSelf createRequestData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^ {
            [weakSelf loadMoreData];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"已发布";
    self.pageCount = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self createRequestData];
    __weakSelf;
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationEditSkill object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note){
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:ODNotificationloveSkill object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadData:(NSNotification *)text {
    ODReleaseModel *model = self.dataArray[self.loveRow];
    model.love_num = [NSString stringWithFormat:@"%@" , text.userInfo[@"loveNumber"]];
    [self.dataArray replaceObjectAtIndex:self.loveRow withObject:model];
    [self.tableView reloadData];
}

#pragma mark - 加载数据请求
- (void)createRequestData {
    __weakSelf
    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%i", self.pageCount],@"my":@"1"};
    [ODHttpTool getWithURL:ODUrlSwapList parameters:parameter modelClass:[ODReleaseModel class] success:^(id model) {
         if (weakSelf.pageCount == 1) {
             [weakSelf.dataArray removeAllObjects];
         }
        for (ODReleaseModel *md in [model result]) {
            if (![[weakSelf.dataArray valueForKeyPath:@"swap_id"] containsObject:[md swap_id]]) {
                [weakSelf.dataArray addObject: md];
            }
        }
        // 刷新数据
        [ODHttpTool od_endRefreshWith:weakSelf.tableView array:[model result]];

        if (weakSelf.dataArray.count == 0) {
            [self.noResultabel showOnSuperView:weakSelf.tableView title:@"暂无技能"];
        }else {
            [self.noResultabel hidden];
        }        
    }
    failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    self.pageCount ++;
    [self createRequestData];
}

#pragma mark - 删除技能请求
- (void)deleteSkillRequest {
    NSDictionary *parameter = @{@"swap_id" : self.swap_id};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlSwapDel parameters:parameter modelClass:[NSObject class] success:^(id model) {
        [ODProgressHUD showInfoWithStatus:@"删除任务成功"];
        [weakSelf.dataArray removeObject:weakSelf.dataArray[weakSelf.deleteRow]];
        [weakSelf.tableView reloadData];
    }
    failure:^(NSError *error) {
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODReleaseView *cell = [tableView dequeueReusableCellWithIdentifier:ODReleaseViewID];
    cell.model = self.dataArray[indexPath.row];
    [cell.editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarExchangeSkillDetailViewController *vc = [[ODBazaarExchangeSkillDetailViewController alloc] init];
    ODReleaseModel *model = self.dataArray[indexPath.row];
    self.loveRow = indexPath.row;
    if (![[NSString stringWithFormat:@"%@", model.status] isEqualToString:@"-1"]) {
        vc.swap_id = [NSString stringWithFormat:@"%@",model.swap_id];
        vc.nick = model.user[@"nick"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 编辑 点击事件
- (void)editButtonClick:(UIButton *)button {
    ODReleaseView *cell = (ODReleaseView *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ODReleaseModel *model = self.dataArray[indexPath.row];
    
    if (![[NSString stringWithFormat:@"%@", model.status] isEqualToString:@"-1"]) {
        ODBazaarReleaseSkillViewController *vc = [[ODBazaarReleaseSkillViewController alloc] init];
        vc.swap_id = [NSString stringWithFormat:@"%@",model.swap_id];
        vc.type = @"编辑";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 删除 点击事件
- (void)deleteButtonClick:(UIButton *)button {
    __weakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除技能" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          ODReleaseView *cell = (ODReleaseView *)button.superview.superview;
                          NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:cell];
                          ODReleaseModel *model = weakSelf.dataArray[indexPath.row];
                          weakSelf.deleteRow = indexPath.row;
                          weakSelf.swap_id = model.swap_id;
                          [weakSelf deleteSkillRequest];
                          
                      }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
