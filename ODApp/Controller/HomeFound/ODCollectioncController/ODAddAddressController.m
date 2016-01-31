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

@property (nonatomic , strong) UILabel *centerNameLabe;
@property (nonatomic , strong) ODAddAddressView *addAddressView;
@property (nonatomic , assign) BOOL isdefault;

@end

@implementation ODAddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.isdefault = YES;
    [self navigationInit];
    [self createView];
}

#pragma mark - 初始化

-(void)navigationInit
{
    self.navigationItem.title = @"新增地址";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(saveAction:) color:nil highColor:nil title:@"保存"];
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
@end
