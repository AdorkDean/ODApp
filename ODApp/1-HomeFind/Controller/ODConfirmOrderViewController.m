//
//  ODConfirmOrderViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODConfirmOrderViewController.h"
#import "ODConfirmOrderModel.h"
#import "ODConfirmOrderCell.h"
#import "ODDeliveryNoteViewController.h"
#import "ODSelectAddressViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "ODMyTakeOutModel.h"
#import "ODTakeOutConfirmModel.h"
#import "ODContactAddressController.h"
#import "ODShopCartView.h"
#import "ODOrderAddressModel.h"

static NSString *cellId = @"ODConfirmOrderCell";

@interface ODConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *tableHeaderView;

@property(nonatomic,strong)ODConfirmOrderModel *model;
@property(nonatomic,strong)UILabel *remarkDetailLabel;
@property(nonatomic,strong)ODConfirmOrderModel *orderModel;
@property(nonatomic,strong) ODTakeOutConfirmModel *confirmModel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *numLabel;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,copy)NSString *addressId;

@property(nonatomic)float count;

@end

@implementation ODConfirmOrderViewController

#pragma mark - lzayload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"ODConfirmOrderCell" bundle:nil] forCellReuseIdentifier:cellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tradeType = @"1";
    self.navigationItem.title = @"确认订单";
    [self requestData];
    
    __weakSelf
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAddress:) name:ODNotificationSaveAddress object:nil];
    [[NSNotificationCenter defaultCenter]addObserverForName:ODNotificationRefreshConfirmOrder object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf requestData];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)createTableHeaderView{
    self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 200)];
    self.tableHeaderView.backgroundColor = [UIColor backgroundColor];
    UITapGestureRecognizer *infoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(infoTapClick)];
    
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 66)];
    infoView.backgroundColor = [UIColor whiteColor];
    [infoView addGestureRecognizer:infoTap];
    [self.tableHeaderView addSubview:infoView];
    
    self.nameLabel = [[UILabel alloc]init];
    NSString *is_default = [NSString stringWithFormat:@"%@",[self.orderModel.address valueForKeyPath:@"is_default"]];
    if ([is_default isEqualToString:@"0"]||[is_default isEqualToString:@"1"]) {
        self.nameLabel.frame = CGRectMake(17, 17, 100, 20);
        self.nameLabel.text = [self.orderModel.address valueForKeyPath:@"name"];
    }else{
        self.nameLabel.frame = CGRectMake(17, 23, 100, 20);
        self.nameLabel.text = @"请选择配送地址";
    }
    self.nameLabel.font = [UIFont systemFontOfSize:13.5];
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+15, 17, 150, 20)];
    self.numLabel.text = [self.orderModel.address valueForKeyPath:@"tel"];
    self.numLabel.font = [UIFont systemFontOfSize:13.5];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(self.nameLabel.frame)+7.5, kScreenSize.width-60, 15)];
    self.addressLabel.text = [self.orderModel.address valueForKeyPath:@"address"];
    self.addressLabel.textColor = [UIColor colorGreyColor];
    self.addressLabel.font = [UIFont systemFontOfSize:11];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width-25.4, 25.5, 8.4, 15)];
    imageView.image = [UIImage imageNamed:@"Skills profile page_icon_arrow_upper"];
    [infoView addSubview:self.nameLabel],[infoView addSubview:self.numLabel],[infoView addSubview:self.addressLabel],[infoView addSubview:imageView];
    
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(infoView.frame)+6, kScreenSize.width, 55)];
    payView.backgroundColor = [UIColor whiteColor];
    [self.tableHeaderView addSubview:payView];
    
    UIImageView *wxIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(17, 18.5, 22.5, 18)];
    wxIamgeView.image = [UIImage imageNamed:@"icon_WeChat Payment"];
    [payView addSubview:wxIamgeView];
    
    UILabel *wxLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(wxIamgeView.frame)+7.5, 15, 100, 25)];
    wxLabel.text = @"微信钱包支付";
    wxLabel.font = [UIFont systemFontOfSize:13.5];
    [payView addSubview:wxLabel];
    
    UIImageView *confirmImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width-37, 20, 20, 20)];
    confirmImageView.image = [UIImage imageNamed:@"icon_Default address_Selected"];
    [payView addSubview:confirmImageView];
    
    
    UIView *deliveryView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payView.frame)+6, kScreenSize.width,101)];
    deliveryView.backgroundColor = [UIColor whiteColor];
    [self.tableHeaderView addSubview:deliveryView];
    
    UITapGestureRecognizer *deliveryTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deliverTapClick)];
    UIView *remarkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    [remarkView addGestureRecognizer:deliveryTap];
    [deliveryView addSubview:remarkView];
    
    UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 15, 60, 20)];
    remarkLabel.text = @"配送备注";
    remarkLabel.font = [UIFont systemFontOfSize:13.5];
    
    self.remarkDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(remarkLabel.frame)+10, 15, kScreenSize.width-120,20)];
    self.remarkDetailLabel.font = [UIFont systemFontOfSize:13.5];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width-25.4, 17.5, 8.4, 15)];
    imageView1.image = [UIImage imageNamed:@"Skills profile page_icon_arrow_upper"];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(remarkLabel.frame)+15, kScreenSize.width-17, 1)];
    lineView.backgroundColor = [UIColor backgroundColor];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(lineView.frame)+15, 100, 20)];
    timeLabel.text = @"配送时间";
    timeLabel.font = [UIFont systemFontOfSize:13.5];
    
    UILabel *detailTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-120, CGRectGetMaxY(lineView.frame)+15, 103, 20)];
    detailTimeLabel.text = @"25分钟内";
    detailTimeLabel.textColor = [UIColor colorGreyColor];
    detailTimeLabel.font = [UIFont systemFontOfSize:13.5];
    detailTimeLabel.textAlignment = NSTextAlignmentRight;
    
    [remarkView addSubview:remarkLabel],[remarkView addSubview:self.remarkDetailLabel], [remarkView addSubview:imageView1],[deliveryView addSubview:lineView],[deliveryView addSubview:timeLabel];
    [deliveryView addSubview:detailTimeLabel];
    
    self.tableHeaderView.frame = CGRectMake(0, 0, kScreenSize.width,infoView.frame.size.height+ payView.frame.size.height+ deliveryView.frame.size.height+18);
    self.tableView.tableHeaderView = self.tableHeaderView;
}

#pragma mark - 创建底部试图
-(void)createBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenSize.height-64-49, kScreenSize.width, 49)];
    bottomView.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.9];
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    
    self.count = 0;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, kScreenSize.width-117, 49)];
    for (ODConfirmOrderModelShopcart_list *model  in self.dataArray) {
        self.count += [model.num floatValue]*[model.price_show floatValue];
    }
    label.text = [NSString stringWithFormat:@"合计 %.2f",self.count];
    label.textColor = [UIColor colorWithRGBString:@"#ffffff"];
    label.font = [UIFont systemFontOfSize:17];
    [bottomView addSubview:label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, 100, 49)];
    [button setTitle:@"确认下单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRGBString:@"#ffffff"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorRedColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [bottomView addSubview:button];
}

#pragma mark - 数据请求
-(void)requestData{
    __weakSelf;
    NSDictionary *parametr = @{@"shopcart_json" : self.datas.od_URLDesc};
    [ODHttpTool getWithURL:ODUrlShopcartOrder parameters:parametr modelClass:[ODConfirmOrderModel class] success:^(ODConfirmOrderModelResponse * model) {
        [weakSelf.dataArray removeAllObjects];
        weakSelf.orderModel = [model result];
        [weakSelf.dataArray addObjectsFromArray:weakSelf.orderModel.shopcart_list];
        [weakSelf createTableHeaderView];
        [weakSelf createBottomView];
        [weakSelf.tableView reloadData];
        weakSelf.addressId = [weakSelf.orderModel.address valueForKeyPath:@"id"];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ODConfirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma mark - UIAction
-(void)infoTapClick{
    ODContactAddressController *controller = [[ODContactAddressController alloc]init];
    controller.getAddressBlock = ^(ODOrderAddressDefModel *model){
        self.nameLabel.text = model.name;
        self.nameLabel.frame = CGRectMake(17, 17, 100, 20);
        self.numLabel.text = model.tel;
        self.addressLabel.text = model.address;
        self.addressLabel.frame = CGRectMake(17, CGRectGetMaxY(self.nameLabel.frame)+7.5, kScreenSize.width-60, 15);
        self.addressId  = [NSString stringWithFormat:@"%@",model.id];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)deliverTapClick{
    ODDeliveryNoteViewController *deliveryNote = [[ODDeliveryNoteViewController alloc]init];
    __weakSelf
    deliveryNote.myBlock= ^(NSString *str){
        weakSelf.remarkDetailLabel.text = str;
    };
    deliveryNote.noteContent = self.remarkDetailLabel.text;
    [self.navigationController pushViewController:deliveryNote animated:YES];
}


-(void)buttonClick:(UIButton *)button{
    if (![WXApi isWXAppInstalled])
    {
        [ODProgressHUD showInfoWithStatus:@"没有安装微信"];
        return;
    }
    NSString *remarkStr;
    if (self.remarkDetailLabel.text.length != 0) {
        remarkStr = self.remarkDetailLabel.text;
    }
    else {
        remarkStr = @"";
    }
    NSMutableDictionary *successParams = [NSMutableDictionary dictionary];
    successParams[@"address_id"] = [NSString stringWithFormat:@"%@",self.addressId];
//    successParams[@"price_show"] = [NSString
//                                    stringWithFormat:@"%f", self.count];
    successParams[@"pay_type"] = @"2";
    successParams[@"remark"] = remarkStr;
    successParams[@"shopcart_json"] = self.datas.od_URLDesc;
    __weakSelf
    [ODHttpTool getWithURL:ODUrlShopcartOrderConfirm parameters:successParams modelClass:[ODTakeOutConfirmModel class] success:^(id model)
     {
         __strongSelf
         strongSelf.confirmModel = [model result];
         strongSelf.orderId = strongSelf.confirmModel.order_id;
         strongSelf.order_no = strongSelf.confirmModel.order_no;
         strongSelf.successParams = @{
                                    @"type" : @"1",
                                    @"takeout_order_id" : strongSelf.confirmModel.order_id
                                    };
         [strongSelf getWeiXinDataWithParam:strongSelf.successParams];
         
         // 清空购物车
         ODShopCartView *view = [ODShopCartView shopCart];
         [view shopCartHeaderViewDidClickClearButton:nil];
     }
                   failure:^(NSError *error)
     {
    }];
}

-(void)changeAddress:(NSNotification *)user{
    
    self.nameLabel.text = user.userInfo[@"name"];
    self.nameLabel.frame = CGRectMake(17, 17, 100, 20);
    self.numLabel.text = user.userInfo[@"tel"];
    self.addressLabel.text = user.userInfo[@"address"];
    self.addressLabel.frame = CGRectMake(17, CGRectGetMaxY(self.nameLabel.frame)+7.5, kScreenSize.width-60, 15);
    self.addressId  = [NSString stringWithFormat:@"%@",user.userInfo[@"id"]];
}

@end
