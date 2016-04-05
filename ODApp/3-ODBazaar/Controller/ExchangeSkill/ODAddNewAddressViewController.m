//
//  ODAddNewAddressViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/4/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODAddNewAddressViewController.h"
#import "ODSelectAddressViewController.h"

@interface ODAddNewAddressViewController ()

@property(nonatomic,strong)UIView *infoView;

@end

@implementation ODAddNewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新增地址";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(rightItemClick) color:nil highColor:nil title:@"保存"];
    
    [self createInfoView];
    [self createBottomView];
}

-(void)createInfoView{
    
    self.infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 100)];
    self.infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.infoView];
    
    NSArray *array = @[@"icon_Edit name",@"icon_Edit Phone number",@"icon_address",@"icon_address"];
    NSArray *nameArray = @[@"您的姓名",@"您的手机号",@"定位地址",@"详细地址（如门牌号等）"];
    for (NSInteger i = 0 ; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 15+50*i, 20, 20)];
        imageView.image = [UIImage imageNamed:array[i]];
        
        if (i==2) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+8, 15+50*i, kScreenSize.width-63, 20)];
            [button setTitle:nameArray[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor colorGrayColor] forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [self.infoView addSubview:button];
        }else{
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+8, 15+50*i, kScreenSize.width-63, 20)];
            textField.placeholder = nameArray[i];
            textField.textColor = [UIColor colorGloomyColor];
            textField.tag = i+1;
            if (i==1) {
                NSString *str = [ODUserInformation sharedODUserInformation].mobile;
                textField.text = str;
            }
            [self.infoView addSubview:textField];
        
        }
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 50+50*i, kScreenSize.width-17.5, 1)];
        lineView.backgroundColor = [UIColor backgroundColor];
        self.infoView.frame = CGRectMake(0, 0, kScreenSize.width, lineView.frame.origin.y+lineView.frame.size.height);
        
        [self.infoView addSubview:imageView];
        [self.infoView addSubview:lineView];
    }
}

-(void)createBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoView.frame)+6, kScreenSize.width, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 15, 20, 20)];
    imageView.image = [UIImage imageNamed:@"icon_Default address_default"];
    [bottomView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+8, 15, 200, 20)];
    label.text = @"设为默认地址";
    label.font = [UIFont systemFontOfSize:13.5];
    label.textColor = [UIColor colorGloomyColor];
    [bottomView addSubview:label];
    
}

-(void)rightItemClick{
    
}


-(void)buttonClick:(UIButton *)button{
    UITextField *textField = (UITextField *)[self.infoView viewWithTag:4];
    ODSelectAddressViewController *controller = [[ODSelectAddressViewController alloc]init];
    controller.myBlock = ^(NSString *address,NSString *addresstitle){
        [button setTitle:address forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorGloomyColor] forState:UIControlStateNormal];
        textField.text = addresstitle;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

@end
