//
//  ODTestUrlViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODTestUrlViewController.h"

@interface ODTestUrlViewController ()

@end

@implementation ODTestUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createButtons];
}

-(void)createButtons{
    NSArray *array = @[@"删除单个商品",@"清楚购物单",@"直接下单按钮",@"确认下单"];
    for (NSInteger i = 0; i< array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setFrame:CGRectMake(100, 100 + 50* i, 175, 40)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)buttonClick:(UIButton *)button{
    NSUInteger index = [self.view.subviews indexOfObject:button];
    switch (index) {
        case 0:{
            NSDictionary *parameter = @{@"shopcart_id":@"14",@"open_id":@"766148455eed214ed1f8"};
            [self requestDataWithUrl:ODUrlShopcartDel parameter:parameter];
        }
            break;
        case 1:{
            NSDictionary *parameter = @{@"open_id":@"766148455eed214ed1f8"};
            [self requestDataWithUrl:ODUrlShopcartClear parameter:parameter];
        }
            break;
        case 2:{
//            NSDictionary *parameter = @{@"object_type":@"1",@"object_id":@"2",@"open_id":@"766148455eed214ed1f8"};
            NSDictionary *parameter1 = @{@"shopcart_ids":@"17,18",@"open_id":@"766148455eed214ed1f8"};
            [self requestDataWithUrl:ODUrlShopcartOrder parameter:parameter1];
        }
            break;
        case 3:{
//            NSDictionary *parameter = @{@"address_id":@"1",@"price_show":@"45",@"pay_type":@"2",@"object_type":@"1",@"object_id":@"2",@"num":@"1",@"open_id":@"766148455eed214ed1f8"};
            NSDictionary *parameter1 = @{@"address_id":@"1",@"price_show":@"70.99",@"pay_type":@"2",@"shopcart_ids":@"17,18"};
            [self requestDataWithUrl:ODUrlShopcartOrderConfirm parameter:parameter1];
        }
            break;
        default:
            break;
    }
}

-(void)requestDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter{
    [ODHttpTool getWithURL:url parameters:parameter modelClass:[NSObject class] success:^(id model) {
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
