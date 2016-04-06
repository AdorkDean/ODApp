//
//  ODShopCartView.m
//  ODApp
//
//  Created by 王振航 on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "ODShopCartView.h"
#import "ODTakeOutModel.h"

#import "ODShopCartListCell.h"
#import "ODConfirmOrderViewController.h"
#import "ODShopCartListHeaderView.h"

/** 购物车HeaderView Height */
static CGFloat const shopCartHeaderViewH = 25;
/** 购物车 Height */
static CGFloat const shopCartH = 49;
/** 购物车Cell Height */
static CGFloat const shopCartCellH = 44;

#import <MJExtension.h>

@interface ODShopCartView() <UITableViewDataSource, UITableViewDelegate,
                             ODShopCartListCellDelegate, ODShopCartListHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *leftView;

/** 购物车列表 */
@property (nonatomic, strong) UITableView *shopCartView;
/** 购物车头部视图 */
@property (nonatomic, strong) ODShopCartListHeaderView *headerView;
/** 蒙板 */
@property (nonatomic, strong) UIView *coverView;
/** 价格 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 数量 */
@property (nonatomic, weak) IBOutlet UILabel *numberLabel;
/** 结算按钮 */
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

/** 存放需要购买的商品 */
@property (nonatomic, strong) NSMutableArray *shopCars;
/** 购买总数 */
@property (nonatomic, assign) NSInteger shopCount;
/** 是否展开 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;

@end

static NSString * const shopCartListCell = @"ODShopCartListCell";

// 存储偏好设置中的KEY
static NSString * const kShopCount = @"shopCount";
static NSString * const kTotalPrice = @"totalPrice";
static NSString * const kShopCarts = @"shopCarts";

@implementation ODShopCartView

#pragma mark - 懒加载
- (NSMutableArray *)shopCars
{
    if (!_shopCars) {
        _shopCars = [NSMutableArray array];
    }
    return _shopCars;
}

- (ODShopCartListHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [ODShopCartListHeaderView headerView];
        _shopCartView.tableHeaderView = _headerView;
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UITableView *)shopCartView
{
    if (!_shopCartView) {
         _shopCartView = [[UITableView alloc] initWithFrame:CGRectMake(0, KScreenHeight - shopCartH, KScreenWidth, CGFLOAT_MIN) style:UITableViewStylePlain];
        _shopCartView.dataSource = self;
        _shopCartView.delegate = self;
        _shopCartView.bounces = NO;
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:_shopCartView];
        
        // 取消分割线
        _shopCartView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 注册cell
        [_shopCartView registerNib:[UINib nibWithNibName:NSStringFromClass([ODShopCartListCell class]) bundle:nil] forCellReuseIdentifier:shopCartListCell];
    }
    return _shopCartView;
}

- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.6;
        _coverView.frame = [UIApplication sharedApplication].keyWindow.bounds;
        
        _coverView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gas = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_coverView addGestureRecognizer:gas];
    }
    return _coverView;
}

#pragma mark - 初始化
- (void)awakeFromNib
{
    UITapGestureRecognizer *gas =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShopCart)];
    [self.leftView addGestureRecognizer:gas];
    
    self.numberLabel.layer.cornerRadius = self.numberLabel.od_width * 0.5;
    self.numberLabel.layer.masksToBounds = YES;
    
    // 读取缓存
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.shopCount = [[user valueForKey:kShopCount] integerValue];
    self.numberLabel.text = self.shopCount ? [NSString stringWithFormat:@"%ld", self.shopCount] : @"0";
    CGFloat cacheTotalPrice = [[user valueForKey:kTotalPrice] floatValue];
    self.priceLabel.text = cacheTotalPrice ? [NSString stringWithFormat:@"%.2f", cacheTotalPrice] : @"0";
    // 读取shopCarts
    NSData *data = [user valueForKey:kShopCarts];
    self.shopCars = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    self.buyButton.enabled = cacheTotalPrice;
    self.buyButton.backgroundColor = self.buyButton.enabled ? [UIColor colorWithRGBString:@"#ff6666" alpha:1] : [UIColor lightGrayColor];
    
//    // 支付完成后, 清空购物车
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanCache:) name:ODNotificationPaySuccess object:nil];
}

+ (instancetype)shopCart
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - IBActions
/**
 *  点击购物车
 */
- (void)clickShopCart
{
    if (!self.shopCars.count) return;
    self.opened = !self.opened;
    
    if (self.isOpened) {
        CGFloat height = self.shopCars.count * shopCartCellH + shopCartHeaderViewH;
        [UIView animateWithDuration:kAnimateDuration animations:^{
            self.shopCartView.frame = CGRectMake(0, KScreenHeight - height - shopCartH, KScreenWidth, height);
        }];
        
        self.headerView.od_width = KScreenWidth;
        self.headerView.od_height = shopCartHeaderViewH;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow insertSubview:self.coverView belowSubview:self];
    } else {
        // 移除蒙板
        [self dismiss];
    }
    [self.shopCartView reloadData];
}

/**
 *  移除蒙板
 */
- (void)dismiss
{
    self.opened = NO;
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.shopCartView.frame = CGRectMake(0, KScreenHeight - shopCartH, KScreenWidth, CGFLOAT_MIN);
        self.headerView.od_width = KScreenWidth;
        self.headerView.od_height = shopCartHeaderViewH;
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
    [self.shopCartView reloadData];
}

/**
 *  点击去结算
 */
- (IBAction)comfirmClick
{
    [self dismiss];
    
    if (!self.shopCars.count) return;
    
    UITabBarController *tabBarVc = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navVc = tabBarVc.selectedViewController;
    ODConfirmOrderViewController *vc = [[ODConfirmOrderViewController alloc] init];
    
    NSMutableArray *jsonM = [NSMutableArray array];
    for (ODTakeOutModel *takeOut in self.shopCars)
    {
        NSMutableArray *dict = [NSMutableArray array];
        [dict addObject:@(1)];
        [dict addObject:takeOut.product_id];
        [dict addObject:@(takeOut.shopNumber)];
        [jsonM addObject:dict.od_URLDesc];
    }
    vc.datas = jsonM;
    [navVc pushViewController:vc animated:YES];
}

/**
 *  更新缓存
 */
- (void)updateCacheshopCount:(NSInteger)shopCount totalPrice:(CGFloat)totalPrice shopCarts:(NSMutableArray *)shopCarts
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [user setObject:@(shopCount) forKey:kShopCount];
    [user setObject:@(totalPrice) forKey:kTotalPrice];
    //将shopCarts类型变为NSData类型
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:shopCarts];
    [user setObject:data forKey:kShopCarts];
    [user synchronize];
}

#pragma mark - Public
/**
 *  添加购买商品
 */
- (void)addShopCount:(ODTakeOutModel *)data
{
    data.shopNumber += 1;
    // 修改数量
    self.shopCount += 1;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", self.shopCount];
    
    // 计算总价
    CGFloat totalPrice = self.priceLabel.text.floatValue + data.price_show.floatValue;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", totalPrice];
    self.buyButton.enabled = totalPrice;
    self.buyButton.backgroundColor = self.buyButton.enabled ? [UIColor colorWithRGBString:@"#ff6666" alpha:1]: [UIColor lightGrayColor];
    
    // 添加商品
    if ([self.shopCars containsObject:data]) {
        [self updateCacheshopCount:self.shopCount totalPrice:totalPrice shopCarts:self.shopCars];
        return;
    }
    
    for (ODTakeOutModel *takeOut in self.shopCars)
    {
        if ([takeOut.title isEqualToString:data.title])
        {
            takeOut.shopNumber++;
            [self updateCacheshopCount:self.shopCount totalPrice:totalPrice shopCarts:self.shopCars];
            return;
        }
    }
    [self.shopCars addObject:data];
    
    // 更新缓存
    [self updateCacheshopCount:self.shopCount totalPrice:totalPrice shopCarts:self.shopCars];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shopCars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODShopCartListCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCartListCell];
    cell.takeOut = self.shopCars[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - ODShopCartListHeaderViewDelegate
- (void)shopCartHeaderViewDidClickClearButton:(ODShopCartListHeaderView *)headerView
{
    // 清空购物车数据
    for (ODTakeOutModel *takeOut in self.shopCars) {
        takeOut.shopNumber = 0;
    }
    
    [self.shopCars removeAllObjects];
    
    [self dismiss];
    
    // 刷新
    [self.shopCartView reloadData];
    
    self.shopCount = 0;
    self.numberLabel.text = self.priceLabel.text = @"0";
    self.buyButton.enabled = NO;
    self.buyButton.backgroundColor = [UIColor lightGrayColor];
    
    // 移除缓存
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:kShopCount];
    [user removeObjectForKey:kTotalPrice];
    [user removeObjectForKey:kShopCarts];
    [user synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationShopCartRemoveALL object:self];
}

#pragma mark - ODShopCartListCellDelegate
- (void)shopCartListcell:(ODShopCartListCell *)cell DidClickMinusButton:(ODTakeOutModel *)currentData
{
    self.shopCount--;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", self.shopCount];
    
    // 计算总价
    CGFloat totalPrice = self.priceLabel.text.floatValue - currentData.price_show.floatValue;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", totalPrice];
    
    // 将商品从购物车中移除
    if (currentData.shopNumber == 0) {
        [self.shopCars removeObject:currentData];
        
        CGFloat height = self.shopCars.count * shopCartCellH + shopCartHeaderViewH;
        [UIView animateWithDuration:kAnimateDuration animations:^{
            self.shopCartView.frame = CGRectMake(0, KScreenHeight - height - shopCartH, KScreenWidth, height);
        }];
        self.headerView.od_width = KScreenWidth;
        self.headerView.od_height = shopCartHeaderViewH;
        [self.shopCartView reloadData];
        
        if (!self.shopCars.count) [self dismiss];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationShopCartminusNumber object:nil];
    }
    self.buyButton.enabled = self.priceLabel.text.floatValue;
    self.buyButton.backgroundColor = self.buyButton.enabled ? [UIColor colorWithRGBString:@"#ff6666" alpha:1] : [UIColor lightGrayColor];
    
    // 更新缓存
    [self updateCacheshopCount:self.shopCount totalPrice:totalPrice shopCarts:self.shopCars];
}

- (void)shopCartListcell:(ODShopCartListCell *)cell DidClickPlusButton:(ODTakeOutModel *)currentData
{
    self.shopCount++;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", self.shopCount];
    
    // 计算总价
    CGFloat totalPrice = self.priceLabel.text.floatValue + currentData.price_show.floatValue;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", totalPrice];
    
    // 更新缓存
    [self updateCacheshopCount:self.shopCount totalPrice:totalPrice shopCarts:self.shopCars];
}

@end
