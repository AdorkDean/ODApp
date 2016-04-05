//
//  ODAddNewAddressViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/4/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODAddNewAddressViewController.h"

@interface ODAddNewAddressViewController ()

@property(nonatomic,strong)UIView *addressView;

@end

@implementation ODAddNewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新增地址";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(rightItemClick) color:nil highColor:nil title:@"保存"];
    
    [self createView];
}

-(void)createView{
    
    self.addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 100)];
    [self.view addSubview:self.addressView];
    
    NSArray *array = @[@"icon_Edit name",@"icon_Edit Phone number",@"icon_address",@"icon_address"];
    NSArray *nameArray = @[@"您的姓名",@"您的手机号",@"定位地址",@"详细地址（如门牌号等）"];
    for (NSInteger i = 0 ; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 15+30*i, 20, 20)];
        imageView.image = [UIImage imageNamed:array[i]];
        
        if (i==2) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+8, 15+30*i, kScreenSize.width-63, 20)];
            [button setTitle:nameArray[i] forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [self.addressView addSubview:button];
        }else{
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+8, 15+30*i, kScreenSize.width-63, 20)];
            textField.placeholder = nameArray[i];
            [self.addressView addSubview:textField];
        }
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 50+50*i, kScreenSize.width-17.5, 1)];
        lineView.backgroundColor = [UIColor backgroundColor];
        
        [self.addressView addSubview:imageView];
        [self.addressView addSubview:lineView];
    }
}

-(void)rightItemClick{
    
}


@end
