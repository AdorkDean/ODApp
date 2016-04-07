//
//  ODTakeAwayDetailController.m
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS



#import "ODTakeOutpaysinglemodel.h"
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "PontoH5ToMobileRequest.h"
#import "ODPaySuccessController.h"
#import "ODTakeAwayDetailController.h"
#import "ODShopCartListCell.h"
#import "ODTakeOutModel.h"

#import <Masonry.h>
#import "ODUserInformation.h"
#import "ODAPPInfoTool.h"

#import "ODShopCartView.h"

@interface ODTakeAwayDetailController()
@property (nonatomic, strong) PontoDispatcher *pontoDispatcher;
@property(nonatomic, copy) NSString *isPay;

@property (nonatomic, weak) ODShopCartView *shopCart;

@end

@implementation ODTakeAwayDetailController

#pragma mark - View Lifecycle

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
        NSString *urlString = [[ODHttpTool getRequestParameter:@{ @"id" : self.product_id }] od_URLDesc];
        NSString *url = [ODWebUrlNative stringByAppendingString:urlString];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL OD_URLWithString:url]]];
        
    }
    
    // 点击 H5 购买商品按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(h5addShopNumber:) name:ODNotificationShopCartAddNumber object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successPay:) name:ODNotificationPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failPay:) name:ODNotificationPayfail object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearShopNumber:) name:ODNotificationShopCartRemoveALL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearShopNumber:) name:ODNotificationShopCartminusNumber object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearShopNumber:) name:ODNotificationPaySuccess object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    if (self.isOrderDetail) {
        return;
    } else {
        [self setupShopCart];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.shopCart removeFromSuperview];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 初始化方法
- (void)createWebView {
    float footHeight = 0;
    if (!self.isOrderDetail) {
        footHeight = 49;
    }
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight - footHeight)];
    [self.view addSubview:self.webView];
}

- (void)setupShopCart {
    ODShopCartView *shopCart = [ODShopCartView shopCart];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:shopCart];
    self.shopCart = shopCart;
    [shopCart makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(keyWindow);
        make.height.equalTo(49);
    }];
}

#pragma mark - Get Request Data
- (void)getDatawithCode1:(NSString *)code {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"order_no"] = [ODTakeOutPaySingleModel sharedODTakeOutPaySingleModel].order_no;
    params[@"errCode"] = code;
    params[@"type"] = @"1";
    __weakSelf
    
    // 发送请求
    [ODHttpTool getWithURL:ODUrlPayWeixinCallbackSync parameters:params modelClass:[NSObject class] success:^(id model) {
         for (UIViewController *vc in weakSelf.navigationController.childViewControllers)
         {
             if ([vc isKindOfClass:[ODPaySuccessController class]]) {
                 return ;
             }
         }
         
         ODPaySuccessController *vc = [[ODPaySuccessController alloc]init];
         vc.orderId = weakSelf.order_id;
         vc.payStatus = weakSelf.isPay;
         vc.params = [ODTakeOutPaySingleModel sharedODTakeOutPaySingleModel].params;
         vc.tradeType = @"1";
         [weakSelf.navigationController pushViewController:vc animated:YES];
     } failure:^(NSError *error) {
         [weakSelf.navigationController popViewControllerAnimated:YES];
     }];
}

#pragma mark - IBActions

- (void)clearShopNumber:(NSNotification *)note {
    self.takeOut.shopNumber = 0;
}

- (void)h5addShopNumber:(NSNotification *)note {
    [self.shopCart addShopCount:self.takeOut];
}

- (void)failPay:(NSNotification *)text {
    NSString *code = text.userInfo[@"codeStatus"];
    self.isPay = @"2";
    [self getDatawithCode1:code];
}

- (void)successPay:(NSNotification *)text {
    NSString *code = text.userInfo[@"codeStatus"];
    self.isPay = @"1";
    [self getDatawithCode1:code];
}

#pragma mark - Remove NSNotification
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
