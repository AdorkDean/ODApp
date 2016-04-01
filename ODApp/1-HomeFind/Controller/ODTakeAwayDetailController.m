//
//  ODTakeAwayDetailController.m
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "PontoH5ToMobileRequest.h"
#import "ODPaySuccessController.h"
#import "ODTakeAwayDetailController.h"
#import "ODShopCartListCell.h"
#import "ODTakeOutModel.h"

#import <Masonry.h>
#import "ODHttpTool.h"
#import "ODUserInformation.h"
#import "ODAPPInfoTool.h"

#import "ODShopCartView.h"

@interface ODTakeAwayDetailController ()
@property (nonatomic, strong) PontoDispatcher *pontoDispatcher;
@property(nonatomic, copy) NSString *isPay;

@property (nonatomic, weak) ODShopCartView *shopCart;
@end

@implementation ODTakeAwayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.takeAwayTitle;
    [self createWebView];
    self.pontoDispatcher = [[PontoDispatcher alloc] initWithHandlerClassesPrefix:@"Ponto" andWebView:self.webView];
    
    // 订单详情页
    if (self.isOrderDetail) {
        NSString *urlString = [[ODHttpTool getRequestParameter:@{ @"order_id" : self.order_id}]od_URLDesc];
        NSString *url = [ODWebUrlNativeOrderInfo stringByAppendingString:urlString];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL OD_URLWithString:url]]];
    }
    // 商品详情页
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@", ODWebUrlNative, self.product_id]]]];
        [self setupShopCart];
    }
    [self addObserver];
}

#pragma mark - Create UIWebView
- (void)createWebView {
    float footHeight = 0;
    if (!self.isOrderDetail) {
        footHeight = 49;
    }
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight - footHeight)];
    [self.view addSubview:self.webView];
}


static NSInteger result = 0;
static CGFloat priceResult = 0;
#pragma mark - 购物车
- (void)setupShopCart
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    ODShopCartView *shopCart = [ODShopCartView shopCart];
    [keyWindow addSubview:shopCart];
    [shopCart makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(keyWindow);
        make.height.equalTo(49);
    }];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    result = [[user objectForKey:@"result"] integerValue];
    priceResult = [[user objectForKey:@"priceResult"] floatValue];
    self.shopCart = shopCart;
    shopCart.shops = self.shops;
    
    // 商品总数量
//    result += 1;
    // 计算数量
    shopCart.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)result];
    shopCart.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", priceResult];
    
    // 读取缓存的shopNumber
    NSMutableDictionary *cacheShops = [user objectForKey:@"shops"];
    NSDictionary *obj = [cacheShops objectForKey:self.takeOut.title];
    NSInteger cacheNumber = [[obj valueForKey:@"shopNumber"] integerValue];
    
    // 保存商品个数
    self.takeOut.shopNumber = cacheNumber;
//    takeOut.shopNumber += 1;
//    [self.shops setObject:takeOut.mj_keyValues forKey:takeOut.title];
//    self.shopCart.shops = self.shops;
    
    // 保存数据
    [user setObject:@(result) forKey:@"result"];
    [user setObject:@(priceResult) forKey:@"priceResult"];
    [user setObject:self.shops forKey:@"shops"];
    [user synchronize];
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
    if ([self.takeAwayTitle isEqualToString:@"订单详情"])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successPay:) name:ODNotificationPaySuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failPay:) name:ODNotificationPayfail object:nil];
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
    self.shopCart.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)result];
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
    self.shopCart.numberLabel.text = [NSString stringWithFormat:@"%zd", (long)result];
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

- (void)getDatawithCode:(NSString *)code {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"order_no"] = self.model.out_trade_no;
    params[@"errCode"] = code;
    params[@"type"] = @"1";
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlPayWeixinCallbackSync parameters:params modelClass:[NSObject class] success:^(id model)
     {
         for (UIViewController *vc in weakSelf.navigationController.childViewControllers)
         {
             if ([vc isKindOfClass:[ODPaySuccessController class]])
             {
                 return ;
             }
         }
         ODPaySuccessController *vc = [[ODPaySuccessController alloc] init];
//         vc.swap_type = weakSelf.swap_type;
         vc.payStatus = weakSelf.isPay;
//         vc.orderId = weakSelf.orderId;
//         vc.params = [PontoH5ToMobileRequest ].;
         vc.tradeType = @"1";
         [weakSelf.navigationController pushViewController:vc animated:YES];
     } failure:^(NSError *error) {
         [weakSelf.navigationController popViewControllerAnimated:YES];
     }];
}

#pragma mark - 事件方法
- (void)failPay:(NSNotification *)text {
    NSString *code = text.userInfo[@"codeStatus"];
    self.isPay = @"2";
    [self getDatawithCode:code];
}

- (void)successPay:(NSNotification *)text {
    NSString *code = text.userInfo[@"codeStatus"];
    self.isPay = @"1";
    [self getDatawithCode:code];
}

@end
