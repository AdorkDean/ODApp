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
#import "ODPersonalCenterViewController.h"
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

#pragma mark - LazyLoad
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

#pragma mark - Lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 初始化购物车
    [self setupShopCart];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.shopCart removeFromSuperview];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
    if (![[self.navigationController viewControllers] containsObject:self])
    {
        // 调用方法
        [self.shopCart removeFromSuperview];
    }
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
    [self setupRefresh];
}

#pragma mark - 初始化方法
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
    self.type = @0;
    self.page = @1;
    
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
- (void)setupRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTakeOuts)];
    self.tableView.mj_footer.automaticallyHidden = YES;
}

#pragma mark - IBActions
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
        [weakSelf checkFooterState:newDatas.count];
        // 重新设置 page = 1
        weakSelf.page = @1;
    } failure:^(NSError *error) {
        if (weakSelf.params != params) return;
    }];
}

- (void)loadMoreTakeOuts
{
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

/**
 *  设置购物车动画
 */
- (void)shopCartAnimation:(NSDictionary *)dict
{
    NSValue *value = dict[@"position"];
    CGPoint lbCenter = value.CGPointValue;
    
    UIImage *image = [UIImage imageNamed:@"icon_shopCart_circle"];
    image = [image OD_circleImage];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame = CGRectMake(0, 0, 10, 10);
    imageView.hidden = YES;
    imageView.center = lbCenter;
    
    CALayer *layer = [[CALayer alloc]init];
    layer.contents = imageView.layer.contents;
    layer.frame = imageView.frame;
    layer.opacity = 1;
    [self.view.layer addSublayer:layer];
    
    CGPoint btnCenter = CGPointMake(10, CGRectGetMidY(self.shopCart.frame));
    CGPoint endpoint = [self.view convertPoint:btnCenter fromView:self.view];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //动画起点
    CGPoint startPoint = [self.view convertPoint:lbCenter fromView:self.tableView];
    [path moveToPoint:startPoint];
    //贝塞尔曲线控制点
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex = endpoint.x;
    float x = sx + (ex - sx) / 3 - 100;
    float y = sy - 75;
    CGPoint centerPoint = CGPointMake(x, y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 0.6;
    animation.delegate = self;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:animation forKey:@"buy"];
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
    [self.tableView.mj_footer endRefreshing];
    // 点击方法
    ODTakeOutModel *model = self.datas[indexPath.row];
    ODTakeAwayDetailController *vc = [[ODTakeAwayDetailController alloc] init];
    vc.takeAwayTitle = @"商品详情";
    vc.takeOut = model;
    vc.product_id = [NSString stringWithFormat:@"%@", model.product_id];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ODTakeOutHeaderViewDelegate
- (void)headerView:(ODTakeOutHeaderView *)headerView didClickedMenuButton:(NSInteger)index
{
    self.type = @(index);
    self.page = @1;
    // 设置tableView偏移量
    [self loadNewTakeOuts];
    self.tableView.contentOffset = CGPointZero;
}

#pragma mark - ODTakeOutCellDelegate
- (void)takeOutCell:(ODTakeOutCell *)cell didClickedButton:(ODTakeOutModel *)takeOut userInfo:(NSDictionary *)dict
{
    // 添加动画
    [self shopCartAnimation:dict];
    // 延迟执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 点击购买按钮
        [self.shopCart addShopCount:takeOut];
    });

}

@end
