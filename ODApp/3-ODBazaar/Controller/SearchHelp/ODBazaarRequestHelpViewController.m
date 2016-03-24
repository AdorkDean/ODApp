//
//  ODBazaarRequestHelpViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//  求帮助界面

#import "ODBazaarRequestHelpViewController.h"
#import "ODBazaarHelpCell.h"

@interface ODBazaarRequestHelpViewController () <UITableViewDataSource, UITableViewDelegate,UIPopoverPresentationControllerDelegate>

/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

@end

// 循环cell标识
static NSString * const helpCellId = @"helpCell";

@implementation ODBazaarRequestHelpViewController

#pragma mark - 懒加载
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.refresh isEqualToString:@"release"]) {
        self.status = @"9";
        [self.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [self.tableView.mj_header beginRefreshing];
    } else if ([self.refresh isEqualToString:@"del"]) {
        [self.dataArray removeObjectAtIndex:self.indexPath];
        [self.tableView reloadData];
    }
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加通知
    [self addObserver];
    
    [self createScreeningAndSearchButton];
    
    [self setupTableView];
    
    [self setupRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.refresh = @"";
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化方法
/**
 *  接收通知
 */
- (void)addObserver
{
    __weakSelf
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationShowBazaar object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"任务筛选" forState:UIControlStateNormal];
        [weakSelf.tableView.mj_header beginRefreshing];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationReleaseTask object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [weakSelf.tableView.mj_header beginRefreshing];

    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationLocationSuccessRefresh object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [weakSelf.tableView.mj_header beginRefreshing];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationQuit object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"任务筛选" forState:UIControlStateNormal];
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

/**
 *  创建搜索栏
 */
- (void)createScreeningAndSearchButton
{
    //任务筛选
    self.screeningButton = [ODClassMethod creatButtonWithFrame:CGRectMake(10, 10, 112, 35) target:self sel:@selector(screeningButtonClick:) tag:0 image:nil title:@"任务筛选" font:15];
    [self.screeningButton setTitleColor:[UIColor colorWithRGBString:@"#000000" alpha:1] forState:UIControlStateNormal];
    self.screeningButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    self.screeningButton.layer.masksToBounds = YES;
    self.screeningButton.layer.cornerRadius = 5;
    self.screeningButton.layer.borderColor = [UIColor colorWithRGBString:@"484848" alpha:1].CGColor;
    self.screeningButton.layer.borderWidth = 1;
    [self.view addSubview:self.screeningButton];
    
    UIImageView *screeningIamgeView = [ODClassMethod creatImageViewWithFrame:CGRectMake(85, 13, 15, 9) imageName:@"任务筛选下拉箭头" tag:0];
    screeningIamgeView.tag = 10010;
    [self.screeningButton addSubview:screeningIamgeView];
    
    UITapGestureRecognizer *searchGestuer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchButtonClick)];
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame) + 5, 10, kScreenSize.width - 137, 35)];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 5;
    searchView.layer.borderColor = [UIColor colorWithRGBString:@"484848" alpha:1].CGColor;
    searchView.layer.borderWidth = 1;
    [searchView addGestureRecognizer:searchGestuer];
    searchView.tag = 10011;
    [self.view addSubview:searchView];
    
    UIImageView *searchImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(15, 10, 15, 15) imageName:@"搜索放大镜icon" tag:0];
    [searchView addSubview:searchImageView];
    
    UILabel *seacrhLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame)+10, 10, searchView.frame.size.width-40, 15)];
    seacrhLabel.text = @"请输入您要搜索的关键字";
    seacrhLabel.textColor = [UIColor colorWithRGBString:@"#8e8e8e" alpha:1];
    seacrhLabel.font = [UIFont systemFontOfSize:15];
    seacrhLabel.tag = 10012;
    [searchView addSubview:seacrhLabel];
}
/**
 *  初始化表格
 */
- (void)setupTableView
{
    self.status = @"9";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTabBarHeight, KScreenWidth, KScreenHeight - ODNavigationHeight - 95 - ODTabBarHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithRGBString:@"#f3f3f3" alpha:1];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // 估算tableView高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -ODBazaaeExchangeCellMargin, 0);
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODBazaarHelpCell class]) bundle:nil] forCellReuseIdentifier:helpCellId];
}
/**
 *  设置刷新控件
 */
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTasks)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTasks)];
    self.tableView.mj_footer.automaticallyHidden = YES;
}

#pragma mark - UITableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:helpCellId];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableView 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc] init];
    ODBazaarRequestHelpTasksModel *model = self.dataArray[indexPath.row];
    bazaarDetail.task_id = [NSString stringWithFormat:@"%ld", model.task_id];
    bazaarDetail.task_status_name = model.task_status_name;
    bazaarDetail.open_id = model.open_id;
    __weakSelf
    bazaarDetail.myBlock = ^(NSString *del) {
        weakSelf.refresh = del;
    };
    if ([self.refresh isEqualToString:@"accept"]) {
        [bazaarDetail.taskButton setTitle:@"待派遣" forState:UIControlStateNormal];
    }
    self.indexPath = indexPath.row;
    [self.navigationController pushViewController:bazaarDetail animated:YES];
}

#pragma mark - UIPopDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - 事件方法
- (void)loadNewTasks
{
    // 结束上拉加载
    [self.tableView.mj_footer endRefreshing];
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"task_status"] = self.status;
    params[@"page"] = @"1";
    params[@"city_id"] = [ODUserInformation sharedODUserInformation].cityID;
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:ODUrlTaskList parameters:params modelClass:[ODBazaarRequestHelpModel class] success:^(ODBazaarRequestHelpModelResponse *model) {
        if (weakSelf.params != params) return;
        // 清空所有数据
        [weakSelf.dataArray removeAllObjects];
        
        ODBazaarRequestHelpModel *helpModel = [model result];
        [weakSelf.dataArray addObjectsFromArray:helpModel.tasks];
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf checkFooterState:helpModel.tasks.count];
        // 重新设置为1
        weakSelf.count = 1;
    } failure:^(NSError *error) {
        if (weakSelf.params != params) return;
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTasks
{
    // 结束下拉刷新
    [self.tableView.mj_header endRefreshing];
    // 取出页码
    NSInteger page = self.count + 1;
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"task_status"] = self.status;
    params[@"page"] = [NSString stringWithFormat:@"%ld", page];
    params[@"city_id"] = [ODUserInformation sharedODUserInformation].cityID;
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:ODUrlTaskList parameters:params modelClass:[ODBazaarRequestHelpModel class] success:^(ODBazaarRequestHelpModelResponse *model) {
        if (weakSelf.params != params) return;
        
        ODBazaarRequestHelpModel *helpModel = [model result];
        [weakSelf.dataArray addObjectsFromArray:helpModel.tasks];
        [weakSelf.tableView reloadData];
        [weakSelf checkFooterState:helpModel.tasks.count];
        // 请求成功后才赋值页码
        weakSelf.count = page;
    } failure:^(NSError *error) {
        if (weakSelf.params != params) return;
        weakSelf.count = weakSelf.count - 1;
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

/**
 *  时刻监测footer的状态
 */
- (void)checkFooterState:(NSUInteger)count
{
    if (count < 20) { // 全部数据已经加载完毕
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else { // 还没有加载完毕
        [self.tableView.mj_footer endRefreshing];
    }
}

-(void)screeningButtonClick:(UIButton *)button
{
    UIViewController *controller = [[UIViewController alloc]init];
    controller.view.backgroundColor = [UIColor colorWithRGBString:@"#f3f3f3" alpha:1];
    NSArray *array = @[@"待派遣",@"正在完成",@"已完成",@"已过期",@"全部"];
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 30*i, 112, 29);
        button.tag = i+10;
        [button setTitleColor:[UIColor colorWithRGBString:@"#000000" alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [controller.view addSubview:button];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(7, CGRectGetMaxY(button.frame)+0.5, 98, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:1];
        [controller.view addSubview:lineView];
    }
    //设置弹出模式
    controller.modalPresentationStyle = UIModalPresentationPopover;
    controller.preferredContentSize = CGSizeMake(112, 150);
    UIPopoverPresentationController *popVC = controller.popoverPresentationController;
    controller.popoverPresentationController.sourceView = button;
    controller.popoverPresentationController.sourceRect = button.bounds;
    popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popVC.delegate = self;
    
    [self presentViewController:controller animated:YES completion:^{
    }];
}

-(void)buttonClick:(UIButton *)button
{
    UIImageView *imageView = (UIImageView *)[self.screeningButton viewWithTag:10010];
    UIView *view = (UIView *)[self.view viewWithTag:10011];
    UILabel *label = (UILabel *)[view viewWithTag:10012];
    if (button.tag==10) {
        self.status = @"1";
        [self.screeningButton setTitle:@"待派遣" forState:UIControlStateNormal];
        [self.screeningButton setFrame:CGRectMake(10, 10, 100, 35)];
        [imageView setFrame:CGRectMake(70, 13, 15, 9)];
        [view setFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame)+5, 10, kScreenSize.width-self.screeningButton.frame.size.width-25, 35)];
        [label setFrame:CGRectMake(40, 10, view.frame.size.width-40, 15)];
    } else if (button.tag == 11) {
        self.status = @"2";
        [self.screeningButton setTitle:@"正在完成" forState:UIControlStateNormal];
        [self.screeningButton setFrame:CGRectMake(10, 10, 112, 35)];
        [imageView setFrame:CGRectMake(85, 13, 15, 9)];
        [view setFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame)+5, 10, kScreenSize.width-self.screeningButton.frame.size.width-25, 35)];
        [label setFrame:CGRectMake(40, 10, view.frame.size.width-40, 15)];
    } else if (button.tag == 12) {
        self.status = @"4";
        [self.screeningButton setTitle:@"已完成" forState:UIControlStateNormal];
        [self.screeningButton setFrame:CGRectMake(10, 10, 100, 35)];
        [imageView setFrame:CGRectMake(70, 13, 15, 9)];
        [view setFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame)+5, 10, kScreenSize.width-self.screeningButton.frame.size.width-25, 35)];
        [label setFrame:CGRectMake(40, 10, view.frame.size.width-40, 15)];
    } else if (button.tag == 13) {
        self.status = @"-2";
        [self.screeningButton setTitle:@"已过期" forState:UIControlStateNormal];
        [self.screeningButton setFrame:CGRectMake(10, 10, 100, 35)];
        [imageView setFrame:CGRectMake(70, 13, 15, 9)];
        [view setFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame)+5, 10, kScreenSize.width-self.screeningButton.frame.size.width-25, 35)];
        [label setFrame:CGRectMake(40, 10, view.frame.size.width-40, 15)];
    } else {
        self.status = @"9";
        [self.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [self.screeningButton setFrame:CGRectMake(10, 10, 85, 35)];
        [imageView setFrame:CGRectMake(55, 13, 15, 9)];
        [view setFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame)+5, 10, kScreenSize.width-self.screeningButton.frame.size.width-25, 35)];
        [label setFrame:CGRectMake(40, 10, view.frame.size.width-40, 15)];
    }
    [self.tableView.mj_header beginRefreshing];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (void)searchButtonClick {
    ODBazaarLabelSearchViewController *labelSearch = [[ODBazaarLabelSearchViewController alloc] init];
    [self.navigationController pushViewController:labelSearch animated:YES];
}

@end
