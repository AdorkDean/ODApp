//
//  ODChoseCenterController.m
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODChoseCenterController.h"
#import "ODChoseCenterCell.h"
#import "ODStorePlaceListModel.h"

@interface ODChoseCenterController () <UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;


@property(nonatomic, strong) NSArray *dataArray;


@end

@implementation ODChoseCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择中心";
    self.dataArray = [[NSArray alloc] init];
    
    [self tableView];
    [self getData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 46;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODChoseCenterCell class]) bundle:nil] forCellReuseIdentifier:@"item"];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

#pragma mark - 请求数据

- (void)getData
{
    __weakSelf
    NSDictionary *parameter = @{@"show_type" : @"1",@"call_array" : @"1"};
    [ODHttpTool getWithURL:ODUrlOtherStoreList parameters:parameter modelClass:[ODStorePlaceListModel class] success:^(ODStorePlaceListModelResponse *model)
    {
        weakSelf.dataArray = model.result;
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
    ODChoseCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item"];

    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ODStorePlaceListModel *model = self.dataArray[indexPath.row];
    NSString *storeId = [NSString stringWithFormat:@"%d",model.id];
    if (self.storeCenterNameBlock)
    {
        self.storeCenterNameBlock(model.name, storeId, model.id);
    }
    if (self.isRefreshBlock)
    {
        self.isRefreshBlock(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
