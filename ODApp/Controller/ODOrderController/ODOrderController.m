//
//  ODOrderController.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODNavigationController.h"
#import "ODOrderController.h"
#import "ODOrderCell.h"
#import "ODContactAddressController.h"
#import "ODOrderHeadView.h"
#import "ODOrderDataModel.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "DataButton.h"
#import "TimeButton.h"
#import "UIImageView+WebCache.h"
#import "ODOrderAddressModel.h"
#import "ODPayController.h"
#import "ODPayController.h"

#import "ODSaveOrderModel.h"

@interface ODOrderController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate>

@property(nonatomic, strong) UIButton *selectedButton;
@property(nonatomic, strong) AFHTTPRequestOperationManager *getOrderIdManger;
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UILabel *allPriceLabel;
@property(nonatomic, strong) ODOrderHeadView *headView;
@property(nonatomic, strong) AFHTTPRequestOperationManager *orderManager;
@property(nonatomic, strong) AFHTTPRequestOperationManager *addressManager;
@property(nonatomic, strong) UIView *choseTimeView;
@property(nonatomic, strong) UIScrollView *scroller;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *selectDataArray;
@property(nonatomic, strong) NSMutableArray *addressArray;
@property(nonatomic, copy) NSString *openId;
@property(nonatomic, copy) NSString *addressId;


@end

@implementation ODOrderController

#pragma mark - 生命周期方法

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.choseTimeView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.openId = [ODUserInformation sharedODUserInformation].openID;
    self.dataArray = [[NSMutableArray alloc] init];
    self.selectDataArray = [[NSMutableArray alloc] init];
    self.addressArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"提交订单";


    [self getData];
    [self getAddress];

    [self createCollectionView];
}

- (void)getAddress {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"open_id"] = self.openId;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlUserAddressList parameters:params modelClass:[ODOrderAddressModel class] success:^(id model)
     {
         [weakSelf.addressArray removeAllObjects];

         ODOrderAddressModel *addressModel = [model result];
         
         if (addressModel.def) {
             [weakSelf.addressArray addObject:addressModel.def];
         }

         [weakSelf.collectionView reloadData];
     
     } failure:^(NSError *error) {
     }];
}

- (void)getData {

    NSDictionary *parameters = @{@"swap_id" : [NSString stringWithFormat:@"%d", self.informationModel.swap_id]};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlSwapServiceTime parameters:parameters modelClass:[ODOrderDataModel class] success:^(id model) {
        
        for (ODOrderDataModel *dataModel in [model result]) {
            [weakSelf.dataArray addObject:dataModel];
        }
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 初始化
- (void)createCollectionView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 120) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6" alpha:1];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ODOrderHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    [self.collectionView registerNib:[UINib nibWithNibName:@"ODOrderCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];

    UIImageView *amountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 49 - ODNavigationHeight, kScreenSize.width - 150, 49)];
    amountImageView.backgroundColor = [UIColor whiteColor];

    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 17, 70, 15)];
    priceLabel.text = @"订单金额：";
    priceLabel.font = [UIFont systemFontOfSize:13];
    priceLabel.backgroundColor = [UIColor whiteColor];
    [amountImageView addSubview:priceLabel];

    self.allPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 15, amountImageView.frame.size.width - 106, 19)];
    self.allPriceLabel.text = [NSString stringWithFormat:@"%@元", self.informationModel.price];
    self.allPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.allPriceLabel.font = [UIFont systemFontOfSize:15];
    self.allPriceLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    [amountImageView addSubview:self.allPriceLabel];
    [self.view addSubview:amountImageView];

    UIButton *saveOrderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveOrderButton.frame = CGRectMake(kScreenSize.width - 150, kScreenSize.height - 49 - ODNavigationHeight, 150, 49);
    saveOrderButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    [saveOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    saveOrderButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [saveOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveOrderButton addTarget:self action:@selector(saveOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveOrderButton];
}


#pragma mark - 获取数据
- (void)saveOrderAction:(UIButton *)sender {

    if ([self.headView.orderView.timeLabel.text isEqualToString:@"请选择"]) {
        [ODProgressHUD showInfoWithStatus:@"请输入服务时间"];
    } else if ([self.headView.orderView.addressLabel.text isEqualToString:@"请选择"]) {
        [ODProgressHUD showInfoWithStatus:@"请输入联系地址"];
    } else {
        [self saveOrder];
    }
}

- (void)saveOrder
{
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"swap_id"] = [NSString stringWithFormat:@"%@", self.informationModel.swap_id];
    params[@"service_time"] = @"";
    params[@"user_address_id"] = self.addressId;
    params[@"comment"] = @"";
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapOrder parameters:params modelClass:[ODSaveOrderModel class] success:^(id model)
     {
         ODSaveOrderModel *orderModel = [model result];
         ODPayController *vc = [[ODPayController alloc] init];
         vc.OrderTitle = weakSelf.informationModel.title;
         // 获取 order_id
         vc.orderId = [orderModel order_id];
         vc.price = [NSString stringWithFormat:@"%d", weakSelf.informationModel.price];
         vc.swap_type = [NSString stringWithFormat:@"%d", weakSelf.informationModel.swap_type];
         [weakSelf.navigationController pushViewController:vc animated:YES];
     } failure:^(NSError *error) {
     }];
}

@end