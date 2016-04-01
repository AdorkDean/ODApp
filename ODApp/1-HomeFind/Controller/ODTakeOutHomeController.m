//
//  ODTakeOutHomeController.m
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  定外卖

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODTakeOutHomeController.h"

#import <MJRefresh.h>
#import "ODTakeOutBannerModel.h"
#import "ODTakeOutModel.h"
#import "ODTakeOutCell.h"
#import "ODTakeOutHeaderView.h"
#import "ODShopCartView.h"
#import "ODShopCartListCell.h"
#import "ODTakeAwayDetailController.h"

#import "ODConfirmOrderViewController.h"
#import <Masonry.h>


// 循环cell标识
static NSString * const takeAwayCellId = @"ODTakeAwayViewCell";

@interface ODTakeOutHomeController () <UITableViewDataSource, UITableViewDelegate,
                                        ODTakeOutHeaderViewDelegate, ODTakeOutCellDelegate>

/** 表格 */
@property (nonatomic, weak) UITableView *tableView;
/** 头部控件 */
@property (nonatomic, weak) ODTakeOutHeaderView *headerView;

/** 购物车 */
@property (nonatomic, weak) ODShopCartView *shopCart;

/** 参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** 页码 */
@property (nonatomic, strong) NSNumber *page;
/** 类型 */
@property (nonatomic, strong) NSNumber *type;
/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *datas;

/** 购物车列表 */
@property (nonatomic, strong) NSMutableDictionary *shops;

@end

@implementation ODTakeOutHomeController

#pragma mark - 懒加载
- (NSMutableDictionary *)shops
{
    if (!_shops) {
        _shops = [NSMutableDictionary dictionary];
    }
    return _shops;
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 初始化购物车
    [self setupShopCart];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    result = [[user objectForKey:@"result"] integerValue];
    priceResult = [[user objectForKey:@"priceResult"] floatValue];
    NSMutableDictionary *cacheShops = [user objectForKey:@"shops"];
    self.shops = [NSMutableDictionary dictionaryWithDictionary:cacheShops];
    self.shopCart.shops = self.shops;
    
    self.shopCart.numberLabel.text = [NSString stringWithFormat:@"%ld", result];
    self.shopCart.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", priceResult];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
        [self.shopCart removeFromSuperview];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化表格
    [self setupTableView];
    
    // 初始化headerView
    [self setupHeaderView];
    
    // 加载广告页
    [self loadNewBanners];
    
    // 加载数据
    [self loadNewTakeOuts];
    
    // 初始化刷新控件
    [self setupScrollViewRefresh];
    
    // 添加通知
    [self addObserver];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化方法

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plusShopCart:) name:ODNotificationShopCartAddNumber object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(minusShopCart:) name:ODNotificationShopCartminusNumber object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllDatas:) name:ODNotificationShopCartRemoveALL object:nil];
}

/**
 *  初始化表格
 */
- (void)setupTableView
{
    self.navigationItem.title = @"订外卖";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 创建表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 163, KScreenWidth, KScreenHeight - 64 - 163 - 49) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.type = self.page = @1;
    
    // rowHeight
    tableView.rowHeight = 90;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODTakeOutCell class]) bundle:nil] forCellReuseIdentifier:takeAwayCellId];
}

/**
 *  初始化headerView
 */
- (void)setupHeaderView
{
    ODTakeOutHeaderView *headerView = [ODTakeOutHeaderView headerView];
    [headerView sizeToFit];
    headerView.od_width = KScreenWidth;
    // 设置代理
    headerView.delegate = self;
    [self.view addSubview:headerView];
    self.headerView = headerView;
}

- (void)setupShopCart
{
    ODShopCartView *shopCart = [ODShopCartView shopCart];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:shopCart];
    [shopCart makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(keyWindow);
        make.height.equalTo(49);
    }];
    self.shopCart = shopCart;
}

/**
 *  设置刷新控件
 */
- (void)setupScrollViewRefresh
{
//    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTakeOuts)];
//    [self.scrollView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTakeOuts)];
    self.tableView.mj_footer.automaticallyHidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODTakeOutCell *cell = [tableView dequeueReusableCellWithIdentifier:takeAwayCellId];
    cell.delegate = self;
    cell.datas = self.datas[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    // 点击方法
    ODTakeOutModel *model = self.datas[indexPath.row];
    ODTakeAwayDetailController *vc = [[ODTakeAwayDetailController alloc] init];
    vc.takeAwayTitle = model.title;
    vc.product_id = [NSString stringWithFormat:@"%@", model.product_id];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ODTakeOutHeaderViewDelegate
- (void)headerView:(ODTakeOutHeaderView *)headerView didClickedMenuButton:(NSInteger)index
{
    self.type = @(index);
    self.page = @1;
    [self loadNewTakeOuts];
}

static NSInteger result = 0;
static CGFloat priceResult = 0;
#pragma mark - ODTakeOutCellDelegate
- (void)takeOutCell:(ODTakeOutCell *)cell didClickedButton:(ODTakeOutModel *)takeOut
{
    // 商品总数量
    result += 1;
    // 计算数量
    self.shopCart.numberLabel.text = [NSString stringWithFormat:@"%ld", result];
    // 计算价格
    priceResult += takeOut.price_show.floatValue;
    self.shopCart.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", priceResult];

    // 读取缓存的shopNumber
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *cacheShops = [user objectForKey:@"shops"];
    NSDictionary *obj = [cacheShops objectForKey:takeOut.title];
    NSInteger cacheNumber = [[obj valueForKey:@"shopNumber"] integerValue];
    
    // 保存商品个数
    takeOut.shopNumber = cacheNumber;
    takeOut.shopNumber += 1;
    [self.shops setObject:takeOut.mj_keyValues forKey:takeOut.title];
    self.shopCart.shops = self.shops;
    
    // 保存数据
    [user setObject:@(result) forKey:@"result"];
    [user setObject:@(priceResult) forKey:@"priceResult"];
    [user setObject:self.shops forKey:@"shops"];
    [user synchronize];
}

#pragma mark - 事件方法
- (void)loadNewBanners
{
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"position"] = @"9";
    params[@"store_id"] = @"0";
    __weakSelf
    [ODHttpTool getWithURL:ODUrlOtherBanner parameters:params modelClass:[ODTakeOutBannerModel class] success:^(id model) {
        weakSelf.headerView.banners = [model result];
    } failure:^(NSError *error) {
    }];
}

- (void)loadNewTakeOuts
{
    // 结束上拉加载
    [self.tableView.mj_footer endRefreshing];
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = [NSString stringWithFormat:@"%@", self.type];
    params[@"page"] = [NSString stringWithFormat:@"%@", self.page];
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:ODUrlTakeOutList parameters:params modelClass:[ODTakeOutModel class] success:^(id model) {
        if (weakSelf.params != params) return;
        // 清空所有数据
        [weakSelf.datas removeAllObjects];
        
        NSArray *newDatas = [model result];
        [weakSelf.datas addObjectsFromArray:newDatas];
        [weakSelf.tableView reloadData];
//        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf checkFooterState:newDatas.count];
        // 重新设置 page = 1
        weakSelf.page = @1;
    } failure:^(NSError *error) {
        if (weakSelf.params != params) return;
//        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTakeOuts
{
    // 结束下拉刷新
//    [self.tableView.mj_header endRefreshing];
    // 取出页码
    NSNumber *currentPage = @([self.page integerValue] + 1);
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = [NSString stringWithFormat:@"%@", self.type];
    params[@"page"] = [NSString stringWithFormat:@"%@", currentPage];
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:ODUrlTakeOutList parameters:params modelClass:[ODTakeOutModel class] success:^(id model) {
        if (weakSelf.params != params) return;
        NSArray *moreTakeOuts = [model result];
        [weakSelf.datas addObjectsFromArray:moreTakeOuts];
        [weakSelf.tableView reloadData];
        [weakSelf checkFooterState:moreTakeOuts.count];
        // 请求成功后才赋值页码
        weakSelf.page = currentPage;
    } failure:^(NSError *error) {
        if (weakSelf.params != params) return;
        weakSelf.page = @([weakSelf.page integerValue] - 1);
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


- (void)removeAllDatas:(NSNotification *)note
{
    result = 0;
    priceResult = 0;
    [self.shops removeAllObjects];
}

- (void)plusShopCart:(NSNotification *)note
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    ODShopCartListCell *cell = note.object;
    NSInteger number = cell.takeOut.shopNumber;
    
    result = [[user objectForKey:@"result"] integerValue];
    result += 1;
    priceResult += cell.takeOut.price_show.floatValue;
    self.shopCart.numberLabel.text = [NSString stringWithFormat:@"%ld", result];
    self.shopCart.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", priceResult];
    
    // 更新模型
    NSMutableDictionary *cacheShops = [user objectForKey:@"shops"];
    NSMutableDictionary *obj = [cacheShops objectForKey:cell.takeOut.title];
    NSMutableDictionary *mutableItem = [NSMutableDictionary dictionaryWithDictionary:obj];
    // 修改数量
    [mutableItem setObject:@(number) forKey:@"shopNumber"];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    for (NSString *key in cacheShops)
    {
        NSDictionary *dict = cacheShops[key];
        if ([dict isEqual:obj]) {
            [dictM setObject:mutableItem forKey:key];
        } else {
            [dictM setObject:dict forKey:key];
        }
    }
    
    [self.shopCart.shopCartView reloadData];
    [user setObject:dictM forKey:@"shops"];
    [user setObject:@(result) forKey:@"result"];
    [user setObject:@(priceResult) forKey:@"priceResult"];
    [user synchronize];
}

- (void)minusShopCart:(NSNotification *)note
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    ODShopCartListCell *cell = note.object;
    NSInteger number = cell.takeOut.shopNumber;
    
    result = [[user objectForKey:@"result"] integerValue];
    result -= 1;
    if (!number) {
        [self.shopCart.shops removeObjectForKey:cell.takeOut.title];
        [user setObject:self.shopCart.shops forKey:@"shops"];
    }
    priceResult -= cell.takeOut.price_show.floatValue;
    self.shopCart.numberLabel.text = [NSString stringWithFormat:@"%ld", result];
    self.shopCart.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", priceResult];
    // 更新模型
    NSMutableDictionary *cacheShops = [user objectForKey:@"shops"];
    NSMutableDictionary *obj = [cacheShops objectForKey:cell.takeOut.title];
    NSMutableDictionary *mutableItem = [NSMutableDictionary dictionaryWithDictionary:obj];
    // 修改数量
    [mutableItem setObject:@(number) forKey:@"shopNumber"];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    for (NSString *key in cacheShops)
    {
        NSDictionary *dict = cacheShops[key];
        if ([dict isEqual:obj]) {
            [dictM setObject:mutableItem forKey:key];
        } else {
            [dictM setObject:dict forKey:key];
        }
    }
    [self.shopCart.shopCartView reloadData];
    [user setObject:dictM forKey:@"shops"];
    [user setObject:@(result) forKey:@"result"];
    [user setObject:@(priceResult) forKey:@"priceResult"];
    [user synchronize];
}

@end
