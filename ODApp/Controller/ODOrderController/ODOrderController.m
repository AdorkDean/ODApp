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
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.choseTimeView removeFromSuperview];
}


- (void)getAddress {
    self.addressManager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters = @{@"open_id" : self.openId};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];

    __weak typeof(self) weakSelf = self;
    [self.addressManager GET:ODUrlUserGetAddress parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {


        if ([responseObject[@"status"] isEqualToString:@"success"]) {


            [weakSelf.addressArray removeAllObjects];


            NSMutableDictionary *dic = responseObject[@"result"];

            NSMutableDictionary *addressDic = dic[@"def"];


            if (addressDic.count != 0) {
                ODOrderAddressDefModel *model = [[ODOrderAddressDefModel alloc] init];
                [model setValuesForKeysWithDictionary:addressDic];
                [weakSelf.addressArray addObject:model];

            }


        }


        [weakSelf.collectionView reloadData];

    }                failure:^(AFHTTPRequestOperation *operation, NSError *error) {


    }];

}

- (void)getData {
    self.manager = [AFHTTPRequestOperationManager manager];


    NSDictionary *parameters = @{@"swap_id" : [NSString stringWithFormat:@"%@", self.informationModel.swap_id]};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];


    [self.manager GET:kGetServecTimeUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {


        if (responseObject) {
            NSMutableDictionary *dic = responseObject[@"result"];


            for (NSMutableDictionary *miniDic in dic) {
                ODOrderDataModel *model = [[ODOrderDataModel alloc] initWithDict:miniDic];
                [self.dataArray addObject:model];
            }


        }

        [self.collectionView reloadData];

    }         failure:^(AFHTTPRequestOperation *operation, NSError *error) {


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
         vc.price = weakSelf.informationModel.price;
         vc.swap_type = weakSelf.informationModel.swap_type;
         [weakSelf.navigationController pushViewController:vc animated:YES];
     } failure:^(NSError *error) {
     }];
    
    
//    [self.orderManager GET:ODUrlSwapOrder parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//
//        if ([responseObject[@"status"] isEqualToString:@"success"]) {
//
//
//            NSMutableDictionary *dic = responseObject[@"result"];
//
//
//            NSString *orderId = [NSString stringWithFormat:@"%@", dic[@"order_id"]];
//
//
//            ODPayController *vc = [[ODPayController alloc] init];
//            vc.OrderTitle = self.informationModel.title;
//            vc.orderId = orderId;
//            vc.price = [NSString stringWithFormat:@"%@", self.informationModel.price];
//            vc.swap_type = [NSString stringWithFormat:@"%@", self.informationModel.swap_type];
//            [self.navigationController pushViewController:vc animated:YES];
//
//
//        } else if ([responseObject[@"status"] isEqualToString:@"error"]) {
//
//
//            [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];
//        }
//
//    }              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//
//    }];

}


#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];

    cell.model = self.informationModel;


    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {


    self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];

    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressAction)];
    [self.headView.orderView.addressImgeView addGestureRecognizer:addressTap];
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeAction)];
    [self.headView.orderView.choseTimeView addGestureRecognizer:timeTap];
    self.headView.orderView.firstLabelConstraint.constant = 0.5;
    self.headView.orderView.secondLabelConstraint.constant = 0.5;

    self.headView.orderView.typeLabel.text = @"上门服务";


    if (self.addressArray.count == 0) {
        self.headView.orderView.addressLabel.text = @"请选择";
    } else {
        ODOrderAddressDefModel *model = self.addressArray[0];
        self.headView.orderView.addressLabel.text = model.address;
        self.addressId = [NSString stringWithFormat:@"%d", model.id];


    }


    return self.headView;

}


//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(kScreenSize.width, 160);


}

//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenSize.width, 160);

}

- (void)timeAction {
    [self.choseTimeView removeFromSuperview];
    self.choseTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight / 2 - ODNavigationHeight, kScreenSize.width, KScreenHeight / 2)];
    self.choseTimeView.userInteractionEnabled = YES;
    self.choseTimeView.backgroundColor = [UIColor whiteColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.text = @"服务时间";
    titleLabel.textColor = [UIColor blackColor];
    [self.choseTimeView addSubview:titleLabel];

    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 20)];
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.text = @"(该时间将影响订单自动确认时间)";
    contentLabel.textColor = [UIColor lightGrayColor];
    [self.choseTimeView addSubview:contentLabel];


    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, self.choseTimeView.frame.size.width, 50)];
    self.scroller.backgroundColor = [UIColor whiteColor];
    self.scroller.userInteractionEnabled = YES;
    self.scroller.showsHorizontalScrollIndicator = NO;
    self.scroller.contentSize = CGSizeMake(self.scroller.frame.size.width * 2.35, 50);
    [self.choseTimeView addSubview:self.scroller];


    for (int i = 0; i < 7; i++) {
        DataButton *button = [[DataButton alloc] initWithFrame:CGRectMake(5 + i * self.scroller.frame.size.width / 3, 5, self.scroller.frame.size.width / 3 - 10, 40)];
        if (i == 0) {

            button.dataLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
            button.timeLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            button.layer.borderColor = [UIColor colorWithHexString:@"#ff6666" alpha:1].CGColor;
            button.layer.borderWidth = 1;

        } else {
            button.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            button.layer.borderWidth = 1;

        }


        ODOrderDataModel *model = self.dataArray[i];
        button.tag = i + 7;
        [button addTarget:self action:@selector(timeAction:) forControlEvents:UIControlEventTouchUpInside];
        button.dataLabel.text = [NSString stringWithFormat:@"%@", model.date];
        button.timeLabel.text = [NSString stringWithFormat:@"%@", model.date_name];

        [self.scroller addSubview:button];

    }


    [self createButtonWithNumber:0];


    [self.view addSubview:self.choseTimeView];
}

#pragma mark - 监听方法
- (void)timeAction:(DataButton *)sender {

    for (NSInteger i = 0; i < 7; i++) {
        DataButton *button = [self.scroller viewWithTag:i + 7];
        if (sender.tag != button.tag) {
            button.layer.borderColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1].CGColor;
            button.dataLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
            button.timeLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];


        } else {
            button.layer.borderColor = [UIColor colorWithHexString:@"#ff6666" alpha:1].CGColor;
            button.dataLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
            button.timeLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        }
    }


    [self createButtonWithNumber:sender.tag - 7];


}


- (void)createButtonWithNumber:(NSInteger)number {

    for (int i = 0; i < 15; i++) {
        TimeButton *button = [self.choseTimeView viewWithTag:888 + i];
        [button removeFromSuperview];
    }

    ODOrderDataModel *model = self.dataArray[number];
    NSMutableArray *timeArray = model.times;
    self.selectDataArray = model.times;

    for (int i = 0; i < 4; i++) {
        TimeButton *button = [[TimeButton alloc] initWithFrame:CGRectMake(i * self.choseTimeView.frame.size.width / 4, 80, self.choseTimeView.frame.size.width / 4, (self.choseTimeView.frame.size.height - 80) / 4)];
        button.tag = 888 + i;
        [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];

        NSMutableDictionary *dic = timeArray[i];
        NSString *status = [NSString stringWithFormat:@"%@", dic[@"status"]];
        if (![status isEqualToString:@"1"]) {

            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0" alpha:1];
            [button setTitleColor:[UIColor colorWithHexString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];


        } else {
            [button setTitleColor:[UIColor colorWithHexString:@"#555555" alpha:1] forState:UIControlStateNormal];
        }
        [button setTitle:[NSString stringWithFormat:@"%@", dic[@"time"]] forState:UIControlStateNormal];

        [self.choseTimeView addSubview:button];
    }


    for (int i = 0; i < 4; i++) {
        TimeButton *button = [[TimeButton alloc] initWithFrame:CGRectMake(i * self.choseTimeView.frame.size.width / 4, 80 + (self.choseTimeView.frame.size.height - 80) / 4, self.choseTimeView.frame.size.width / 4, (self.choseTimeView.frame.size.height - 80) / 4)];

        button.tag = 888 + i + 4;
        [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableDictionary *dic = timeArray[i + 4];
        NSString *status = [NSString stringWithFormat:@"%@", dic[@"status"]];
        if (![status isEqualToString:@"1"]) {
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0" alpha:1];
            [button setTitleColor:[UIColor colorWithHexString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor colorWithHexString:@"#555555" alpha:1] forState:UIControlStateNormal];
        }


        [button setTitle:[NSString stringWithFormat:@"%@", dic[@"time"]] forState:UIControlStateNormal];
        [self.choseTimeView addSubview:button];
    }

    for (int i = 0; i < 4; i++) {
        TimeButton *button = [[TimeButton alloc] initWithFrame:CGRectMake(i * self.choseTimeView.frame.size.width / 4, 80 + 2 * (self.choseTimeView.frame.size.height - 80) / 4, self.choseTimeView.frame.size.width / 4, (self.choseTimeView.frame.size.height - 80) / 4)];


        button.tag = 888 + i + 8;
        [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableDictionary *dic = timeArray[i + 8];
        NSString *status = [NSString stringWithFormat:@"%@", dic[@"status"]];
        if (![status isEqualToString:@"1"]) {
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0" alpha:1];
            [button setTitleColor:[UIColor colorWithHexString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];

        } else {
            [button setTitleColor:[UIColor colorWithHexString:@"#555555" alpha:1] forState:UIControlStateNormal];

        }
        [button setTitle:[NSString stringWithFormat:@"%@", dic[@"time"]] forState:UIControlStateNormal];
        [self.choseTimeView addSubview:button];
    }
    for (int i = 0; i < 4; i++) {


        if (i == 3) {
            TimeButton *button = [[TimeButton alloc] initWithFrame:CGRectMake(i * self.choseTimeView.frame.size.width / 4, 80 + 3 * (self.choseTimeView.frame.size.height - 80) / 4, self.choseTimeView.frame.size.width / 4, (self.choseTimeView.frame.size.height - 80) / 4)];
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0" alpha:1];
            [self.choseTimeView addSubview:button];

        } else {
            TimeButton *button = [[TimeButton alloc] initWithFrame:CGRectMake(i * self.choseTimeView.frame.size.width / 4, 80 + 3 * (self.choseTimeView.frame.size.height - 80) / 4, self.choseTimeView.frame.size.width / 4, (self.choseTimeView.frame.size.height - 80) / 4)];
            button.tag = 888 + i + 12;
            [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
            NSMutableDictionary *dic = timeArray[i + 12];
            NSString *status = [NSString stringWithFormat:@"%@", dic[@"status"]];
            if (![status isEqualToString:@"1"]) {
                button.userInteractionEnabled = NO;
                button.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0" alpha:1];
                [button setTitleColor:[UIColor colorWithHexString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];

            } else {
                [button setTitleColor:[UIColor colorWithHexString:@"#555555" alpha:1] forState:UIControlStateNormal];

            }
            [button setTitle:[NSString stringWithFormat:@"%@", dic[@"time"]] forState:UIControlStateNormal];

            [self.choseTimeView addSubview:button];

        }


    }

}


- (void)ChosetimeAction:(TimeButton *)sender {
    [self.choseTimeView removeFromSuperview];
    NSMutableDictionary *dic = self.selectDataArray[sender.tag - 888];
    self.headView.orderView.timeLabel.text = dic[@"request"];

}

- (void)addressAction {
    ODContactAddressController *vc = [[ODContactAddressController alloc] init];

    __weakSelf
    vc.getAddressBlock = ^(NSString *address, NSString *addrssId, NSString *isAddress) {

        if ([isAddress isEqualToString:@"1"]) {
            weakSelf.headView.orderView.addressLabel.text = @"请选择";
            weakSelf.addressId = nil;
        } else {
            weakSelf.headView.orderView.addressLabel.text = address;
            weakSelf.addressId = addrssId;

        }

    };

    vc.addressId = self.addressId;
    ODNavigationController *navi = [[ODNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
