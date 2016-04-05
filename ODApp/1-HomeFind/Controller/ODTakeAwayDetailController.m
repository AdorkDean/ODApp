//
//  ODTakeAwayDetailController.m
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import <UMengAnalytics-NO-IDFA/MobClick.h>
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

@interface ODTakeAwayDetailController()
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(h5addShopNumber:) name:ODNotificationShopCartAddNumber object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.shopCart.hidden = NO;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
//    self.shopCart.hidden = YES;
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

#pragma mark - 购物车
- (void)setupShopCart
{
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    ODShopCartView *shopCart = [ODShopCartView shopCart];
    [self.view addSubview:shopCart];
    self.shopCart = shopCart;
    [shopCart makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(49);
    }];
}

- (void)h5addShopNumber:(NSNotification *)note
{
    // 阻止多次点击, 造成数据错误
    [[self.shopCart class] cancelPreviousPerformRequestsWithTarget:self.shopCart selector:@selector(addShopCount:) object:self.takeOut];
    [self.shopCart performSelector:@selector(addShopCount:) withObject:self.takeOut afterDelay:0.2f];
}

#pragma mark - 初始化方法
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
