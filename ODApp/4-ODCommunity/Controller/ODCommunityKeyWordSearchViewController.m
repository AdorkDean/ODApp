//
//  ODCommunityKeyWordSearchViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODCommunityKeyWordSearchViewController.h"
#import "ODCommunityCell.h"
#import "ODCommunityBbsModel.h"
#import "ODCommunityDetailViewController.h"
#import "ODCommunityShowPicViewController.h"
#import "MJRefresh.h"

@interface ODCommunityKeyWordSearchViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic ,strong) NSMutableDictionary *userInfoDic;
@property(nonatomic, strong) NSMutableArray *userArray;
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic) NSInteger count;
@property(nonatomic, copy) NSString *keyText;
@property(nonatomic, strong) UILabel *noReusltLabel;

@end

static NSString *cellId = @"ODCommunityCell";

@implementation ODCommunityKeyWordSearchViewController

#pragma mark - lazyload
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 8, kScreenSize.width - 20,30)];
        [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        _searchBar.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:1];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"标签关键字";
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46, kScreenSize.width, kScreenSize.height-110)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor backgroundColor];
        [_tableView registerNib:[UINib nibWithNibName:@"ODCommunityCell" bundle:nil] forCellReuseIdentifier:cellId];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, -ODBazaaeExchangeCellMargin, 0);
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 300;;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableDictionary *)userInfoDic{
    if (!_userInfoDic) {
        _userInfoDic = [[NSMutableDictionary alloc]init];
    }
    return _userInfoDic;
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
    self.count = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self searchBar];
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.searchBar.text.length > 0) {
            weakSelf.count = 1;
            [weakSelf requestData];
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.navigationItem.title = @"欧动社区";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(cancelButtonClick) color:[UIColor colorWithRGBString:@"#000000" alpha:1] highColor:nil title:@"取消"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick) color:[UIColor colorWithRGBString:@"#000000" alpha:1] highColor:nil title:@"确认"];
}

#pragma mark - 请求数据
- (void)requestData {
    __weakSelf
    [self.searchBar resignFirstResponder];
     NSDictionary *parameter = @{@"kw" : self.searchBar.text, @"suggest" : @"0", @"page" : [NSString stringWithFormat:@"%ld", self.count],  @"call_array" : @"1"};
    [ODHttpTool getWithURL:ODUrlBbsSearch parameters:parameter modelClass:[ODCommunityBbsModel class] success:^(ODCommunityBbsModelResponse  *model) {
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        ODCommunityBbsModel *bbsModel = [model result];
        for (ODCommunityBbsListModel *listModel in bbsModel.bbs_list) {
            [weakSelf.dataArray addObject:listModel];
        }
        NSDictionary *users = bbsModel.users;
        for (id userKey in users) {
            NSString *key = [NSString stringWithFormat:@"%@",userKey];
            ODCommunityBbsUsersModel *userModel = [ODCommunityBbsUsersModel mj_objectWithKeyValues:users[key]];
            [weakSelf.userInfoDic setObject:userModel forKey:userKey];
        }

        [ODHttpTool od_endRefreshWith:weakSelf.tableView array:[[model result] bbs_list]];
        if (weakSelf.dataArray.count == 0) {
            [weakSelf.noResultLabel showOnSuperView:weakSelf.tableView title:@"没有符合条件的话题"];
        }else {
            [weakSelf.noResultLabel hidden];
        }
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];

}

- (void)loadMoreData {
    if (self.searchBar.text.length > 0) {
        self.count++;
        [self requestData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ODCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    ODCommunityBbsListModel *model = self.dataArray[indexPath.row];
    [cell showDataWithModel:model dict:self.userInfoDic index:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ODCommunityDetailViewController *detailController = [[ODCommunityDetailViewController alloc] init];
    ODCommunityBbsListModel *model = self.dataArray[indexPath.row];
    detailController.bbs_id = [NSString stringWithFormat:@"%d", model.id];
    [self.navigationController pushViewController:detailController animated:YES];
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.tableView.mj_header beginRefreshing];
}
       
#pragma mark - action
- (void)confirmButtonClick {
   [self.searchBar resignFirstResponder];
   if (self.searchBar.text.length > 0) {
       [self.tableView.mj_header beginRefreshing];
   } else {
       [ODProgressHUD showInfoWithStatus:@"请输入搜索内容"];
   }
}

- (void)cancelButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
