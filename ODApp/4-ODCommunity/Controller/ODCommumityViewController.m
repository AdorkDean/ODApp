//
//  ODCommumityViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommumityViewController.h"
#import "ODCommunityCell.h"

@interface ODCommumityViewController ()<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ODCommumityViewController

#pragma mark - lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-55)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor backgroundColor];
        [_tableView registerNib:[UINib nibWithNibName:@"ODCommunityCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, -ODBazaaeExchangeCellMargin, 0);
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 300;;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableDictionary *)userInfoDic
{
    if (!_userInfoDic) {
        _userInfoDic = [[NSMutableDictionary alloc]init];
    }
    return _userInfoDic;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 1;
    self.refresh = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self navigationInit];
    [self joiningTogetherParmeters];
    
    __weakSelf
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationSearchCircle object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:ODNotificationLocationSuccessRefresh object:nil queue:[NSOperationQueue mainQueue ] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:ODNotificationQuit object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.bbsMark = @"全部";
        weakSelf.bbsType = 5;
        [weakSelf.tableView.mj_header beginRefreshing];
        
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.count = 1;
        [weakSelf joiningTogetherParmeters];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.count++;
        [weakSelf joiningTogetherParmeters];
    }];
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.releaseSuccess isEqualToString:@"delSuccess"]) {
        [self.dataArray removeObjectAtIndex:self.indexPath];
        [self.tableView reloadData];
    }else if ([self.releaseSuccess isEqualToString:@"refresh"]){
        self.bbsMark = @"全部";
        self.bbsType = 5;
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.refresh = NO;
    self.releaseSuccess = @"";
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.button = [ODBarButton barButtonWithTarget:self action:@selector(titleButtonClick:) title:@"社区    "];
    [self.button setImage:[UIImage imageNamed:@"jiantou_icon"] forState:UIControlStateNormal];
    [self.button.titleLabel setFont:[UIFont systemFontOfSize:ODNavigationTextFont]];
    [self.button setBarButtonType:(ODBarButtonTypeTextLeft)];
    self.navigationItem.titleView = self.button;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(searchButtonClick) image:[UIImage imageNamed:@"fangdajing_icon"] highImage:nil];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(publishButtonClick) image:[UIImage imageNamed:@"发布任务icon"] highImage:nil];
    
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    self.bbsType = self.bbsType ? self.bbsType :5;
    self.bbsMark = self.bbsMark ? self.bbsMark :@"";
    NSDictionary *parameter;
    if ([self.bbsMark isEqualToString:@""]||[self.bbsMark isEqualToString:@"社区"]) {
        [self.button setTitle:@"社区" forState:UIControlStateNormal];
        parameter = @{
                      @"type":[NSString stringWithFormat:@"%i", self.bbsType],
                      @"page":[NSString stringWithFormat:@"%ld",self.count],
                      @"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID],
                      @"search":@"",
                      @"call_array":@"1"
                      };
    }
    else if ([self.bbsMark isEqualToString:@"全部"]){
        [self.button setTitle:@"全部" forState:UIControlStateNormal];
        parameter = @{
                      @"type":[NSString stringWithFormat:@"%i", self.bbsType],
                      @"page":[NSString stringWithFormat:@"%ld",self.count],
                      @"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID],
                      @"search":@"",
                      @"call_array":@"1"
                      };
    }
    else{
        [self.button setTitle:self.bbsMark forState:UIControlStateNormal];
        parameter = @{
                      @"type":[NSString stringWithFormat:@"%i", self.bbsType],
                      @"page":[NSString stringWithFormat:@"%ld",self.count],
                      @"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID],
                      @"search":self.bbsMark,
                      @"call_array":@"1"
                      };
    }
    [self downLoadDataWithUrl:ODUrlBbsList paramater:parameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)parameter
{
    __weakSelf
    [ODHttpTool getWithURL:url parameters:parameter modelClass:[ODCommunityBbsModel class] success:^(ODCommunityBbsModelResponse  *model) {
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
//        [weakSelf.tableView reloadData];
//        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf.tableView.mj_footer endRefreshing];
        
        [ODHttpTool od_endRefreshWith:weakSelf.tableView array:[[model result] bbs_list]];
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ODCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ODCommunityBbsListModel *model = self.dataArray[indexPath.row];
    [cell showDataWithModel:model dict:self.userInfoDic index:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ODCommunityDetailViewController *detailController = [[ODCommunityDetailViewController alloc]init];
    detailController.myBlock = ^(NSString *refresh){
        self.releaseSuccess = refresh;
    };
    self.indexPath = indexPath.row;
    ODCommunityBbsListModel *model = self.dataArray[indexPath.row];
    detailController.bbs_id = [NSString stringWithFormat:@"%d",model.id];
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - UIPopDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - action
-(void)titleButtonClick:(UIButton *)button
{
    UIViewController *controller = [[UIViewController alloc]init];
    controller.view.backgroundColor = [UIColor colorWithRGBString:@"#ffd802" alpha:1];
    controller.view.layer.borderColor = [UIColor colorWithRGBString:@"#000000" alpha:1].CGColor;
    controller.view.layer.borderWidth = 1;
    controller.view.layer.cornerRadius = 10;
    
    NSArray *array = @[ @"情感", @"搞笑", @"影视", @"二次元", @"生活", @"明星", @"爱美", @"宠物", @"全部" ];
    for (NSInteger i = 0 ; i < array.count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(0, 30*i, 110, 29)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRGBString:@"#000000" alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(titleViewLabelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [controller.view addSubview:button];
        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(button.frame)+0.5, 80, 0.5)];
        lineImage.image = [UIImage imageNamed:@"shequxuxian_icon"];
        [controller.view addSubview:lineImage];
    }
    //设置弹出模式
    controller.modalPresentationStyle = UIModalPresentationPopover;
    controller.preferredContentSize = CGSizeMake(110, 270);
    UIPopoverPresentationController *popVC = controller.popoverPresentationController;
    controller.popoverPresentationController.sourceView = button;
    controller.popoverPresentationController.sourceRect = button.bounds;
    popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popVC.delegate = self;
    
    [self presentViewController:controller animated:YES completion:^{
    }];
}

-(void)titleViewLabelButtonClick:(UIButton *)button
{
    self.bbsMark = button.titleLabel.text;
    self.bbsType = 5;
    [self.tableView.mj_header beginRefreshing];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

-(void)searchButtonClick
{
    ODCommunityKeyWordSearchViewController *keyWordSearch = [[ODCommunityKeyWordSearchViewController alloc]init];
    [self.navigationController pushViewController:keyWordSearch animated:YES];
}

-(void)publishButtonClick
{
    __weakSelf
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc]init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
    }else{
        ODCommunityReleaseTopicViewController *releaseTopic = [[ODCommunityReleaseTopicViewController alloc]init];
        releaseTopic.myBlock = ^(NSString *refresh){
            weakSelf.releaseSuccess = refresh;
        };
        [self.navigationController pushViewController:releaseTopic animated:YES];
    }
}

@end
