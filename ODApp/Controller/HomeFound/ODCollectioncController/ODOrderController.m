//
//  ODOrderController.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOrderController.h"

@interface ODOrderController ()

@property(nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UILabel *centerNameLabe;



@end

@implementation ODOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self navigationInit];

    
    
    
}

#pragma mark - 初始化

-(void)navigationInit
{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.navigationController.navigationBar.hidden = YES;
    self.view.userInteractionEnabled = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 中心活动label
    self.centerNameLabe = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width / 2 - 110, 28, 220, 20) text:@"提交订单" font:17 alignment:@"center" color:@"#000000" alpha:1];
    
    self.centerNameLabe.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:self.centerNameLabe];
    
    
    // 返回button
    UIButton *fanhuiButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    fanhuiButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [fanhuiButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    
    [self.headView addSubview:fanhuiButton];
    
    
    
    
}

- (void)fanhui:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
