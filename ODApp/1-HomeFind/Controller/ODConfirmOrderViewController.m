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

static NSString *cellId = @"ODConfirmOrderCell";

@interface ODConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *tableHeaderView;
@property(nonatomic,strong)ODConfirmOrderModel *model;

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
    
    self.navigationItem.title = @"确认订单";
    [self requestData];
    [self createBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createTableHeaderView{
    self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 200)];
    self.tableHeaderView.backgroundColor = [UIColor backgroundColor];
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 66)];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.tableHeaderView addSubview:infoView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 17, 100, 20)];
    nameLabel.text = [self.model.address valueForKeyPath:@"name"];
    nameLabel.font = [UIFont systemFontOfSize:13.5];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+15, 17, 150, 20)];
    numLabel.text = [self.model.address valueForKeyPath:@"tel"];
    numLabel.font = [UIFont systemFontOfSize:13.5];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(nameLabel.frame)+7.5, kScreenSize.width-60, 15)];
    addressLabel.text = [self.model.address valueForKeyPath:@"address"];
    addressLabel.textColor = [UIColor colorGreyColor];
    addressLabel.font = [UIFont systemFontOfSize:11];
    [infoView addSubview:nameLabel],[infoView addSubview:numLabel],[infoView addSubview:addressLabel];
    
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(infoView.frame)+6, kScreenSize.width, 55)];
    payView.backgroundColor = [UIColor whiteColor];
    [self.tableHeaderView addSubview:payView];
    
    UIImageView *wxIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(17, 20, 20, 15)];
    wxIamgeView.image = [UIImage imageNamed:@"UMS_wechat_on"];
    [payView addSubview:wxIamgeView];
    
    UILabel *wxLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(wxIamgeView.frame)+7.5, 15, 100, 25)];
    wxLabel.text = @"微信钱包支付";
    wxLabel.font = [UIFont systemFontOfSize:13.5];
    [payView addSubview:wxLabel];
    
    UIImageView *confirmImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width-50, 20, 15, 15)];
    confirmImageView.image = [UIImage imageNamed:@""];
    [payView addSubview:confirmImageView];
    
    UIView *deliveryView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payView.frame)+6, kScreenSize.width,101)];
    deliveryView.backgroundColor = [UIColor whiteColor];
    [self.tableHeaderView addSubview:deliveryView];
    
    UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 15, 100, 20)];
    remarkLabel.text = @"配送备注";
    remarkLabel.font = [UIFont systemFontOfSize:13.5];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(remarkLabel.frame)+15.5, kScreenSize.width-17, 0.5)];
    lineView.backgroundColor = [UIColor backgroundColor];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(lineView.frame)+15, 100, 20)];
    timeLabel.text = @"配送时间";
    timeLabel.font = [UIFont systemFontOfSize:13.5];
    
    UILabel *detailTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-120, CGRectGetMaxY(lineView.frame)+15, 103, 20)];
    detailTimeLabel.text = @"25分钟内";
    detailTimeLabel.textColor = [UIColor colorGreyColor];
    detailTimeLabel.font = [UIFont systemFontOfSize:13.5];
    detailTimeLabel.textAlignment = NSTextAlignmentRight;
    
    [deliveryView addSubview:remarkLabel],[deliveryView addSubview:lineView];[deliveryView addSubview:timeLabel];
    [deliveryView addSubview:detailTimeLabel];
    
    self.tableHeaderView.frame = CGRectMake(0, 0, kScreenSize.width,infoView.frame.size.height+ payView.frame.size.height+ deliveryView.frame.size.height+18);
    self.tableView.tableHeaderView = self.tableHeaderView;
}

#pragma mark - 创建底部试图
-(void)createBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenSize.height-64-49, kScreenSize.width-100, 49)];
    bottomView.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.9];
    [self.view addSubview:bottomView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, kScreenSize.width-117, 49)];
    label.text = @"合计  ￥10";
    label.textColor = [UIColor colorWithRGBString:@"#ffffff"];
    label.font = [UIFont systemFontOfSize:17];
    [bottomView addSubview:label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, 100, 49)];
    [button setTitle:@"确认下单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRGBString:@"#ffffff"] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorRedColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [bottomView addSubview:button];
}

#pragma mark - 数据请求
-(void)requestData{
    __weakSelf;
    NSDictionary *parametr = @{@"shopcart_ids":@"17,18",@"open_id":@"766148455eed214ed1f8"};
    [ODHttpTool getWithURL:ODUrlShopcartOrder parameters:parametr modelClass:[ODConfirmOrderModel class] success:^(ODConfirmOrderModelResponse * model) {
        weakSelf.model = [model result];
        [weakSelf.dataArray addObjectsFromArray:weakSelf.model.shopcart_list];
        [weakSelf createTableHeaderView];
        [weakSelf.tableView reloadData];
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

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UITableViewDelegate




@end
