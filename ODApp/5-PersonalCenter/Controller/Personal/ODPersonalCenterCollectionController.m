//
//  ODPersonalCenterCollectionController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>

#import "ODPersonalCenterCollectionController.h"
#import "ODBazaarExchangeSkillCollectionCell.h"

NSString *const ODBazaarExchangeSkillCellID = @"ODBazaarExchangeSkillCell";

@interface ODPersonalCenterCollectionController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

// 无纪录
@property(nonatomic, strong) UILabel *noReusltLabel;

// 数据数组
@property(nonatomic, strong) NSMutableArray *dataArray;

// 数据页数
@property(nonatomic) NSInteger page;

@end

@implementation ODPersonalCenterCollectionController

#pragma mark - lazyLoad

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight + 6) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODBazaarExchangeSkillCell class]) bundle:nil] forCellReuseIdentifier:ODBazaarExchangeSkillCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的收藏";
    [self requestData];
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf loadMoreData];
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

#pragma mark - 数据请求
-(void)requestData
{
    NSDictionary *parameter = @{
                                @"type" : @"4",
                                @"page" : [NSString stringWithFormat:@"%ld", self.page],
                                };
    __weakSelf
    [ODHttpTool getWithURL:ODUrlUserLoveList parameters:parameter modelClass:[ODBazaarExchangeSkillModel class] success:^(ODBazaarExchangeSkillModelResponse *model) {
        if (self.page == 1) {
            [weakSelf.noReusltLabel removeFromSuperview];
            [weakSelf.dataArray removeAllObjects];
        }
        
        NSArray *array = model.result;
        [weakSelf.dataArray addObjectsFromArray:array];
        
        [weakSelf.tableView.mj_header endRefreshing];
        if ([[model result]count] == 0) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
        
        if (self.page == 1 && self.dataArray.count == 0) {
            weakSelf.noReusltLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenSize.width - 160)/2, kScreenSize.height/2, 160, 30)];
            weakSelf.noReusltLabel.text = @"暂无收藏";
            weakSelf.noReusltLabel.font = [UIFont systemFontOfSize:16];
            weakSelf.noReusltLabel.textAlignment = NSTextAlignmentCenter;
            weakSelf.noReusltLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
            [weakSelf.view addSubview:weakSelf.noReusltLabel];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];

}

- (void)loadMoreData {
    self.page++;
    [self requestData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarExchangeSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:ODBazaarExchangeSkillCellID];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    return model.rowHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODBazaarExchangeSkillDetailViewController *detailControler = [[ODBazaarExchangeSkillDetailViewController alloc] init];
    detailControler.swap_id = [NSString stringWithFormat:@"%d", model.swap_id];
    detailControler.nick = model.user.nick;
    [self.navigationController pushViewController:detailControler animated:YES];
}

#pragma mark - action

- (void)imageButtonClicked:(UIButton *)button {
    ODBazaarExchangeSkillCell *cell = (ODBazaarExchangeSkillCell *) button.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc] init];
    picController.photos = model.imgs_big;
    picController.selectedIndex = button.tag - 10 * indexPath.row;
    picController.skill = @"skill";
    [self presentViewController:picController animated:YES completion:nil];
}


@end
