//
//  ODBuyTakeOutViewController.m
//  ODApp
//
//  Created by 王振航 on 16/3/28.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  确定购买界面

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBuyTakeOutViewController.h"

#import "ODHttpTool.h"
#import "ODBuyTakeOutModel.h"

@interface ODBuyTakeOutViewController ()

@end

@implementation ODBuyTakeOutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"确定购买";
    
    // 拼接参数
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"order_id"] = self.order_id;
//    params[@"open_id"] = @"766148455eed214ed1f8";
////    __weakSelf
//    [ODHttpTool getWithURL:ODUrlTakeOutOrderInfo parameters:params modelClass:[ODBuyTakeOutModel class] success:^(id model) {
//        
//        
//    } failure:^(NSError *error) {
//        
    //    }];
    [self setupGroup00];
    [self setupGroup01];
    [self setupGroup02];
}

- (void)setupGroup00
{
    ODArrowItem *item0 = [ODArrowItem itemWithName:@"选择送餐地址"];
    
    ODGroupItem *group = [ODGroupItem groupWithItems:@[item0]];
    
    [self.groups addObject:group];
}

/**
 *  设置cell内容
 */
- (void)setupGroup01
{
    
    ODArrowItem *item0 = [ODArrowItem itemWithName:@"配送备注"];
    
    ODSettingItem *item1 = [ODSettingItem itemWithName:@"配送时间"];
    item1.subTitle = @"立即送出  25分钟送到";
    
    ODGroupItem *group = [ODGroupItem groupWithItems:@[item0, item1]];
    
    [self.groups addObject:group];
}

- (void)setupGroup02
{
    ODSettingItem *item0 = [ODSettingItem itemWithName:@"摩卡"];
    
    ODSettingItem *item1 = [ODSettingItem itemWithName:@"商品价格"];
    item1.subTitle = @"¥28";
    
    ODSettingItem *item2 = [ODSettingItem itemWithName:@"配送费"];
    item2.subTitle = @"¥0";
    
    ODArrowItem *item3 = [ODArrowItem itemWithName:@"优惠券"];
    item3.subTitle = @"没有可用的优惠券";
    
    ODGroupItem *group = [ODGroupItem groupWithItems:@[item0, item1, item2, item3]];
    
    [self.groups addObject:group];
}

@end
