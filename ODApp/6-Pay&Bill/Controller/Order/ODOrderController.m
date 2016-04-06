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
#import "DataButton.h"
#import "TimeButton.h"
#import "UIImageView+WebCache.h"
#import "ODOrderAddressModel.h"
#import "ODExchangePayViewController.h"

#import "ODSaveOrderModel.h"

@interface ODOrderController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate>

@property(nonatomic, strong) UIButton *selectedButton;
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UILabel *allPriceLabel;
@property(nonatomic, strong) ODOrderHeadView *headView;
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 初始化操作
    [self setupInit];
}

#pragma mark - 初始化
/**
 *  初始化操作
 */
- (void)setupInit
{
    self.openId = [ODUserInformation sharedODUserInformation].openID;
    self.dataArray = [[NSMutableArray alloc] init];
    self.selectDataArray = [[NSMutableArray alloc] init];
    self.addressArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"提交订单";
    
    [self getData];
    [self getAddress];
    
    [self createCollectionView];
}

- (void)createCollectionView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 120) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor backgroundColor];
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


#pragma mark - 获取数据
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
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"swap_id"] = [NSString stringWithFormat:@"%d",self.informationModel.swap_id];
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapServiceTime parameters:params modelClass:[ODOrderDataModel class] success:^(id model) {
        [weakSelf.dataArray addObjectsFromArray:[model result]];
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)saveOrder
{
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"swap_id"] = [NSString stringWithFormat:@"%d", self.informationModel.swap_id];
    params[@"service_time"] = self.headView.orderView.timeLabel.text;
    params[@"user_address_id"] = self.addressId;
    params[@"comment"] = @"";
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapOrder parameters:params modelClass:[ODSaveOrderModel class] success:^(id model)
     {
         ODSaveOrderModel *orderModel = [model result];
         ODExchangePayViewController *vc = [[ODExchangePayViewController alloc] init];
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
    return CGSizeMake(kScreenSize.width, 160);
}

#pragma mark - 监听方法
- (void)saveOrderAction:(UIButton *)sender {
    
    if ([self.headView.orderView.timeLabel.text isEqualToString:@"请选择"]) {
        [ODProgressHUD showInfoWithStatus:@"请输入服务时间"];
    } else if ([self.headView.orderView.addressLabel.text isEqualToString:@"请选择"]) {
        [ODProgressHUD showInfoWithStatus:@"请输入联系地址"];
    } else {
        [self saveOrder];
    }
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
            
            button.dataLabel.textColor = [UIColor colorRedColor];
            button.timeLabel.textColor = [UIColor colorRedColor];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            button.layer.borderColor = [UIColor colorRedColor].CGColor;
            button.layer.borderWidth = 1;
            
        } else {
            button.layer.borderColor = [UIColor lineColor].CGColor;
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

- (void)timeAction:(DataButton *)sender {
    
    for (NSInteger i = 0; i < 7; i++) {
        DataButton *button = [self.scroller viewWithTag:i + 7];
        if (sender.tag != button.tag) {
            button.layer.borderColor = [UIColor colorGraynessColor].CGColor;
            button.dataLabel.textColor = [UIColor colorGraynessColor];
            button.timeLabel.textColor = [UIColor colorGraynessColor];
            
        } else {
            button.layer.borderColor = [UIColor colorRedColor].CGColor;
            button.dataLabel.textColor = [UIColor colorRedColor];
            button.timeLabel.textColor = [UIColor colorRedColor];
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
        
        
        ODOrderDataTimesModel *timeData = timeArray[i];
        NSString *status = timeData.status;
        if (![status isEqualToString:@"1"]) {
            
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor colorWithRGBString:@"#f0f0f0" alpha:1];
            [button setTitleColor:[UIColor colorGraynessColor] forState:UIControlStateNormal];
            
        } else {
            [button setTitleColor:[UIColor colorWithRGBString:@"#555555" alpha:1] forState:UIControlStateNormal];
        }
        [button setTitle:[NSString stringWithFormat:@"%@", timeData.time] forState:UIControlStateNormal];
        
        [self.choseTimeView addSubview:button];
    }
    
    
    for (int i = 0; i < 4; i++) {
        TimeButton *button = [[TimeButton alloc] initWithFrame:CGRectMake(i * self.choseTimeView.frame.size.width / 4, 80 + (self.choseTimeView.frame.size.height - 80) / 4, self.choseTimeView.frame.size.width / 4, (self.choseTimeView.frame.size.height - 80) / 4)];
        
        button.tag = 888 + i + 4;
        [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
        ODOrderDataTimesModel *timeData = timeArray[i + 4];
        NSString *status = timeData.status;
        if (![status isEqualToString:@"1"]) {
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor colorWithRGBString:@"#f0f0f0" alpha:1];
            [button setTitleColor:[UIColor colorGraynessColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor colorWithRGBString:@"#555555" alpha:1] forState:UIControlStateNormal];
        }
        
        [button setTitle:timeData.time forState:UIControlStateNormal];
        [self.choseTimeView addSubview:button];
    }
    
    for (int i = 0; i < 4; i++) {
        TimeButton *button = [[TimeButton alloc] initWithFrame:CGRectMake(i * self.choseTimeView.frame.size.width / 4, 80 + 2 * (self.choseTimeView.frame.size.height - 80) / 4, self.choseTimeView.frame.size.width / 4, (self.choseTimeView.frame.size.height - 80) / 4)];
        
        
        button.tag = 888 + i + 8;
        [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
        ODOrderDataTimesModel *timeData = timeArray[i + 8];
        NSString *status = timeData.status;
        if (![status isEqualToString:@"1"]) {
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor colorWithRGBString:@"#f0f0f0" alpha:1];
            [button setTitleColor:[UIColor colorGraynessColor] forState:UIControlStateNormal];
            
        } else {
            [button setTitleColor:[UIColor colorWithRGBString:@"#555555" alpha:1] forState:UIControlStateNormal];
            
        }
        [button setTitle:timeData.time forState:UIControlStateNormal];
        [self.choseTimeView addSubview:button];
    }
    for (int i = 0; i < 4; i++) {
        
        
        if (i == 3) {
            TimeButton *button = [[TimeButton alloc] initWithFrame:CGRectMake(i * self.choseTimeView.frame.size.width / 4, 80 + 3 * (self.choseTimeView.frame.size.height - 80) / 4, self.choseTimeView.frame.size.width / 4, (self.choseTimeView.frame.size.height - 80) / 4)];
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor colorWithRGBString:@"#f0f0f0" alpha:1];
            [self.choseTimeView addSubview:button];
            
        } else {
            TimeButton *button = [[TimeButton alloc] initWithFrame:CGRectMake(i * self.choseTimeView.frame.size.width / 4, 80 + 3 * (self.choseTimeView.frame.size.height - 80) / 4, self.choseTimeView.frame.size.width / 4, (self.choseTimeView.frame.size.height - 80) / 4)];
            button.tag = 888 + i + 12;
            [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
            ODOrderDataTimesModel *timeData = timeArray[i + 12];
            NSString *status = timeData.status;
            if (![status isEqualToString:@"1"]) {
                button.userInteractionEnabled = NO;
                button.backgroundColor = [UIColor colorWithRGBString:@"#f0f0f0" alpha:1];
                [button setTitleColor:[UIColor colorGraynessColor] forState:UIControlStateNormal];
                
            } else {
                [button setTitleColor:[UIColor colorWithRGBString:@"#555555" alpha:1] forState:UIControlStateNormal];
                
            }
            [button setTitle:timeData.time forState:UIControlStateNormal];
            
            [self.choseTimeView addSubview:button];
        }
    }
}

- (void)ChosetimeAction:(TimeButton *)sender {
    [self.choseTimeView removeFromSuperview];
    ODOrderDataTimesModel *timeData = self.selectDataArray[sender.tag - 888];
    self.headView.orderView.timeLabel.text = timeData.request;
}

- (void)addressAction {
    ODContactAddressController *vc = [[ODContactAddressController alloc] init];
    
    __weakSelf
//    vc.getAddressBlock = ^(NSString *address, NSString *addrssId, NSString *isAddress) {
//        
//        if ([isAddress isEqualToString:@"1"]) {
//            weakSelf.headView.orderView.addressLabel.text = @"请选择";
//            weakSelf.addressId = nil;
//        } else {
//            weakSelf.headView.orderView.addressLabel.text = address;
//            weakSelf.addressId = addrssId;
//        }
//    };
    
    vc.addressId = self.addressId;
    ODNavigationController *navi = [[ODNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

@end