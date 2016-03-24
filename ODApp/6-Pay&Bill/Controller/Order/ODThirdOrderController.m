//
//  ODThirdOrderController.m
//  ODApp
//
//  Created by zhz on 16/2/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODThirdOrderController.h"
#import "ODOrderCell.h"
#import "ODContactAddressController.h"
#import "UIImageView+WebCache.h"
#import "ODOrderThirdHeadView.h"
#import "ODOrderAddressModel.h"
#import "ODPayController.h"
#import "TimeButton.h"
#import "DataButton.h"
#import "ODOrderDataModel.h"

#import "ODSaveOrderModel.h"

@interface ODThirdOrderController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) ODOrderThirdHeadView *headView;
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UILabel *allPriceLabel;
@property(nonatomic, copy) NSString *openId;
@property(nonatomic, strong) NSMutableArray *addressArray;
@property(nonatomic, strong) UIView *choseTimeView;
@property(nonatomic, strong) UIScrollView *scroller;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *selectDataArray;


@end

@implementation ODThirdOrderController

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
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.selectDataArray = [[NSMutableArray alloc] init];
    self.view.userInteractionEnabled = YES;
    self.openId = [ODUserInformation sharedODUserInformation].openID;
    self.addressArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"提交订单";
    [self getData];

    [self createCollectionView];
}

#pragma mark - 初始化方法
- (void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 115) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithRGBString:@"#f6f6f6" alpha:1];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.userInteractionEnabled = YES;
    [self.collectionView registerClass:[ODOrderThirdHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    [self.collectionView registerNib:[UINib nibWithNibName:@"ODOrderCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];

    UIImageView *amountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 49 - ODNavigationHeight, kScreenSize.width - 150, 49 )];
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
    self.allPriceLabel.textColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1];
    [amountImageView addSubview:self.allPriceLabel];
    [self.view addSubview:amountImageView];


    UIButton *saveOrderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveOrderButton.frame = CGRectMake(kScreenSize.width - 150, kScreenSize.height - 49 - ODNavigationHeight, 150, 49);
    saveOrderButton.backgroundColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1];
    [saveOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    saveOrderButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [saveOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveOrderButton addTarget:self action:@selector(saveOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveOrderButton];
}


- (void)saveOrderAction:(UIButton *)sender
{
    if ([self.headView.thirdOrderView.timeLabel.text isEqualToString:@"请选择"])
    {
        [ODProgressHUD showInfoWithStatus:@"请输入服务时间"];
    } else
    {
        [self saveOrder];
    }
}
#pragma mark - 获取数据
- (void)getData
{
    NSDictionary *parameters = @{@"swap_id" : [NSString stringWithFormat:@"%d", self.informationModel.swap_id]};

    __weakSelf
    [ODHttpTool getWithURL:ODUrlSwapServiceTime parameters:parameters modelClass:[ODOrderDataModel class] success:^(id model) {
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
    params[@"service_time"] = self.headView.thirdOrderView.timeLabel.text;
    params[@"user_address_id"] = @"0";
    params[@"comment"] = @"";
    // 发送请求
    __weakSelf
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
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
    self.headView.thirdOrderView.labelConstraint.constant = 0.5;
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeAction)];
    [self.headView.thirdOrderView.choseTimeView addGestureRecognizer:timeTap];

    return self.headView;
}

#pragma mark - UICollectionView 代理方法
//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, 160);
}
//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenSize.width, 120);
}

- (void)timeAction
{
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
            button.dataLabel.textColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1];
            button.timeLabel.textColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            button.layer.borderColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1].CGColor;
            button.layer.borderWidth = 1;
        } else {
            button.layer.borderColor = [UIColor colorWithRGBString:@"#e6e6e6" alpha:1].CGColor;
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
            button.layer.borderColor = [UIColor colorWithRGBString:@"#8e8e8e" alpha:1].CGColor;
            button.dataLabel.textColor = [UIColor colorWithRGBString:@"#8e8e8e" alpha:1];
            button.timeLabel.textColor = [UIColor colorWithRGBString:@"#8e8e8e" alpha:1];

        } else {
            button.layer.borderColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1].CGColor;
            button.dataLabel.textColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1];
            button.timeLabel.textColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1];
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
        NSString *status = [NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"status"]];
        
        if (![status isEqualToString:@"1"]) {
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor colorWithRGBString:@"#f0f0f0" alpha:1];
            [button setTitleColor:[UIColor colorWithRGBString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor colorWithRGBString:@"#555555" alpha:1] forState:UIControlStateNormal];
        }
        [button setTitle:[NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"time"]] forState:UIControlStateNormal];

        [self.choseTimeView addSubview:button];
    }

    for (int i = 0; i < 4; i++) {
        TimeButton *button = [[TimeButton alloc] initWithFrame:CGRectMake(i * self.choseTimeView.frame.size.width / 4, 80 + (self.choseTimeView.frame.size.height - 80) / 4, self.choseTimeView.frame.size.width / 4, (self.choseTimeView.frame.size.height - 80) / 4)];

        button.tag = 888 + i + 4;
        [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableDictionary *dic = timeArray[i + 4];
        NSString *status = [NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"status"]];
    
        if (![status isEqualToString:@"1"]) {
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor colorWithRGBString:@"#f0f0f0" alpha:1];
            [button setTitleColor:[UIColor colorWithRGBString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor colorWithRGBString:@"#555555" alpha:1] forState:UIControlStateNormal];
        }

        [button setTitle:[NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"time"]] forState:UIControlStateNormal];
        [self.choseTimeView addSubview:button];
    }

    for (int i = 0; i < 4; i++) {
        TimeButton *button = [[TimeButton alloc] initWithFrame:CGRectMake(i * self.choseTimeView.frame.size.width / 4, 80 + 2 * (self.choseTimeView.frame.size.height - 80) / 4, self.choseTimeView.frame.size.width / 4, (self.choseTimeView.frame.size.height - 80) / 4)];

        button.tag = 888 + i + 8;
        [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableDictionary *dic = timeArray[i + 8];
        NSString *status = [NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"status"]];
        
        if (![status isEqualToString:@"1"]) {
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor colorWithRGBString:@"#f0f0f0" alpha:1];
            [button setTitleColor:[UIColor colorWithRGBString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];

        } else {
            [button setTitleColor:[UIColor colorWithRGBString:@"#555555" alpha:1] forState:UIControlStateNormal];
        }
        [button setTitle:[NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"time"]] forState:UIControlStateNormal];
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
            NSMutableDictionary *dic = timeArray[i + 12];
            NSString *status = [NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"status"]];
            if (![status isEqualToString:@"1"]) {
                button.userInteractionEnabled = NO;
                button.backgroundColor = [UIColor colorWithRGBString:@"#f0f0f0" alpha:1];
                [button setTitleColor:[UIColor colorWithRGBString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];

            } else {
                [button setTitleColor:[UIColor colorWithRGBString:@"#555555" alpha:1] forState:UIControlStateNormal];
            }
            [button setTitle:[NSString stringWithFormat:@"%@", [dic valueForKeyPath:@"time"]] forState:UIControlStateNormal];
            [self.choseTimeView addSubview:button];
        }
    }
}

- (void)ChosetimeAction:(TimeButton *)sender {
    [self.choseTimeView removeFromSuperview];
    NSMutableDictionary *dic = self.selectDataArray[sender.tag - 888];
    self.headView.thirdOrderView.timeLabel.text = [dic valueForKeyPath:@"request"];
}





@end
