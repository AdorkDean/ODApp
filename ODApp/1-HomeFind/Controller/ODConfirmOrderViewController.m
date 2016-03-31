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

@end

@implementation ODConfirmOrderViewController

#pragma mark - lzayload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-63) style:UITableViewStylePlain];
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
    [ODHttpTool getWithURL:ODUrlSwapOrder parameters:parametr modelClass:[ODConfirmOrderModel class] success:^(ODConfirmOrderModelResponse * model) {
        ODConfirmOrderModel *orderModel = [model result];
        [weakSelf.dataArray addObjectsFromArray:orderModel.shopcart_list];
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
