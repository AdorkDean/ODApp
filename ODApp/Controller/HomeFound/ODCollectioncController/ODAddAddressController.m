//
//  ODAddAddressController.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODAddAddressController.h"
#import "ODAddAddressView.h"
@interface ODAddAddressController ()

@property(nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UILabel *centerNameLabe;
@property (nonatomic , strong) ODAddAddressView *addAddressView;
@property (nonatomic , assign) BOOL isdefault;

@end

@implementation ODAddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isdefault = YES;
    
    [self navigationInit];
    [self createView];
    
    
    
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
    self.centerNameLabe = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width / 2 - 110, 28, 220, 20) text:@"新增地址" font:17 alignment:@"center" color:@"#000000" alpha:1];
    
    self.centerNameLabe.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:self.centerNameLabe];
    
    
    // 返回button
    UIButton *fanhuiButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    fanhuiButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [fanhuiButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    
    [self.headView addSubview:fanhuiButton];
    
    UIButton *saveButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 60, 16,50, 44) target:self sel:@selector(saveAction:) tag:0 image:nil title:@"保存" font:16];
    [saveButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:saveButton];

    
    
}

- (void)createView
{
    
    self.addAddressView = [ODAddAddressView getView];
    self.addAddressView.frame = CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64);
    self.addAddressView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self.view addSubview:self.addAddressView];
    
    
    
    [self.addAddressView.defaultButton addTarget:self action:@selector(defaultAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

- (void)saveAction:(UIButton *)sender
{
    
}


- (void)defaultAction:(UIButton *)sender
{
    
    if (self.isdefault) {
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
    }else{
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
        
    }
    self.isdefault = !self.isdefault;

    
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
