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

@property (nonatomic, strong) NSMutableArray *datasArray;

/** 购物车头部视图 */
@property (nonatomic, strong) ODShopCartListHeaderView *headerView;

/** 蒙板 */
@property (nonatomic, strong) UIView *coverView;

/** 结算按钮 */
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end

static NSString * const shopCartListCell = @"ODShopCartListCell";

@implementation ODShopCartView

- (ODShopCartListHeaderView *)headerView
{
    if (!_headerView)
    {
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
        [keyWindow addSubview:self.shopCartView];
        
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

- (NSMutableArray *)datasArray
{
    if (!_datasArray)
    {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *gas =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShopCart)];
    [self.leftView addGestureRecognizer:gas];
    
    self.numberLabel.layer.cornerRadius = self.numberLabel.od_width * 0.5;
    self.numberLabel.layer.masksToBounds = YES;
}
+ (instancetype)shopCart
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setShops:(NSMutableDictionary *)shops
{
    _shops = shops;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in shops)
    {
        NSDictionary *userDict = shops[dict];
        [arrayM addObject:userDict];
    }
    self.datasArray = [ODTakeOutModel mj_objectArrayWithKeyValuesArray:arrayM];
    // 逆序
//    self.datasArray = [[self.datasArray reverseObjectEnumerator] allObjects];
    
    // 设置按钮状态
    self.buyButton.enabled = self.datasArray.count;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODShopCartListCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCartListCell];
    cell.takeOut = self.datasArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - ODShopCartListCellDelegate
- (void)shopCartListcell:(ODShopCartListCell *)cell RemoveCurrentRow:(ODTakeOutModel *)currentData
{
    [self.datasArray removeObject:currentData];
    CGFloat height = self.datasArray.count * shopCartCellH + shopCartHeaderViewH;
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.shopCartView.frame = CGRectMake(0, KScreenHeight - height - shopCartH, KScreenWidth, height);
    }];
    
    self.headerView.od_width = KScreenWidth;
    self.headerView.od_height = shopCartHeaderViewH;
    
    [self.shopCartView reloadData];
    if (!self.datasArray.count) [self dismiss];
}

#pragma mark - ODShopCartListHeaderViewDelegate
- (void)shopCartHeaderViewDidClickClearButton:(ODShopCartListHeaderView *)headerView
{
    // 清除缓存
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"shops"];
    [user removeObjectForKey:@"result"];
    [user removeObjectForKey:@"priceResult"];
    [user synchronize];
    
    [self dismiss];
    
    // 发送通知, 清空所有
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAll" object:self];
    
    // 清空所有
    [self.datasArray removeAllObjects];
    self.numberLabel.text = @"0";
    self.priceLabel.text = @"¥0";
    
    // 移除所有模型中保存的商品数量
    for (ODTakeOutModel *takeOut in self.datasArray) takeOut.shopNumber = 0;

    [self.shopCartView reloadData];
}

/**
 *  点击购物车
 */
- (void)clickShopCart
{
    if (!self.datasArray.count) return;
    self.opened = !self.opened;
    
    if (self.isOpened) {
        CGFloat height = self.datasArray.count * shopCartCellH + shopCartHeaderViewH;
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
    } completion:^(BOOL finished) {
        if (self.coverView.subviews) [self.coverView removeFromSuperview];
    }];
    [self.shopCartView reloadData];
}

/**
 *  点击去结算
 */
- (IBAction)comfirmClick {
    [self dismiss];
    
    if (!self.datasArray.count) return;
    
    UITabBarController *tabBarVc = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navVc = tabBarVc.selectedViewController;
    ODConfirmOrderViewController *vc = [[ODConfirmOrderViewController alloc] init];
    
    NSMutableArray *jsonM = [NSMutableArray array];
    for (ODTakeOutModel *takeOut in self.datasArray)
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


@end
