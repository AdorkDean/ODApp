//
//  ODSecondOrderController.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODSecondOrderController.h"
#import "ODOrderCell.h"
#import "ODContactAddressController.h"
#import "UIImageView+WebCache.h"
#import "ODOrderSecondHeadView.h"
#import "ODOrderaddressmodel.h"
#import "ODPayController.h"
#import "ODNavigationController.h"

#import "ODOrderAddressModel.h"
#import "ODSaveOrderModel.h"

@interface ODSecondOrderController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate>


@property(nonatomic, strong) ODOrderSecondHeadView *headView;
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UILabel *allPriceLabel;
@property(nonatomic, copy) NSString *addressId;
@property(nonatomic, strong) NSArray *addressArray;
@end

@implementation ODSecondOrderController


#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"提交订单";

    [self getAddress];
    [self createCollectionView];

}

#pragma mark - 初始化方法
- (void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 115) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor backgroundColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ODOrderSecondHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

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
    self.allPriceLabel.text = [NSString stringWithFormat:@"%.2f元", self.informationModel.price];
    self.allPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.allPriceLabel.font = [UIFont systemFontOfSize:15];
    self.allPriceLabel.textColor = [UIColor colorRedColor];
    [amountImageView addSubview:self.allPriceLabel];
    [self.view addSubview:amountImageView];


    UIButton *saveOrderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveOrderButton.frame = CGRectMake(kScreenSize.width - 150, kScreenSize.height - 49 - ODNavigationHeight, 150, 49);
    saveOrderButton.backgroundColor = [UIColor colorRedColor];
    [saveOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    saveOrderButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [saveOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveOrderButton addTarget:self action:@selector(saveOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveOrderButton];
}

#pragma mark - 获取数据方法
- (void)getAddress
{
    __weakSelf
    [ODHttpTool getWithURL:ODUrlUserAddressList parameters: @{} modelClass:[ODOrderAddressModel class] success:^(id model)
     {
         ODOrderAddressModel *addressModel = [model result];
         ODOrderAddressDefModel *addressDefModel = addressModel.def;
         weakSelf.addressArray = @[addressDefModel];
         [weakSelf.collectionView reloadData];
     } failure:^(NSError *error) {
     }];
}
- (void)saveOrder
{
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"swap_id"] = [NSString stringWithFormat:@"%d", self.informationModel.swap_id];
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
        vc.price = [NSString stringWithFormat:@"%f", weakSelf.informationModel.price];
        vc.swap_type = [NSString stringWithFormat:@"%d", weakSelf.informationModel.swap_type];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
    }];
}


#pragma mark - UICollectionView 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];

    cell.model = self.informationModel;


    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {


    self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];

    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressAction)];
    [self.headView.secondOrderView.addressImgeView addGestureRecognizer:addressTap];
    self.headView.secondOrderView.labelConstraint.constant = 0.5;

    if (self.addressArray.count == 0) {
        self.headView.secondOrderView.addressLabel.text = @"请选择";
    } else {
        ODOrderAddressDefModel *model = self.addressArray[0];
        self.headView.secondOrderView.addressLabel.text = model.address;
        self.addressId = model.id;


    }
    return self.headView;

}

#pragma mark - UICollectionView 代理方法
//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(kScreenSize.width, 160);
}
//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenSize.width, 130);

}

#pragma mark - 监听方法
- (void)saveOrderAction:(UIButton *)sender
{
    if ([self.headView.secondOrderView.addressLabel.text isEqualToString:@"请选择"])
    {
        [ODProgressHUD showInfoWithStatus:@"请输入联系地址"];
    }
    else
    {
        [self saveOrder];
    }
    
}

- (void)addressAction {
    ODContactAddressController *vc = [[ODContactAddressController alloc] init];
    
    __weakSelf
    vc.getAddressBlock = ^(NSString *address, NSString *addrssId, NSString *isAddress) {
        
        if ([isAddress isEqualToString:@"1"]) {
            weakSelf.headView.secondOrderView.addressLabel.text = @"请选择";
            weakSelf.addressId = nil;
        } else {
            weakSelf.headView.secondOrderView.addressLabel.text = address;
            weakSelf.addressId = addrssId;
            
        }
        
    };
    
    vc.addressId = self.addressId;
    
    ODNavigationController *navi = [[ODNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
    
    
}

@end
