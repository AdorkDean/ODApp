//
//  ODAddNewAddressViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/4/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODAddNewAddressViewController.h"
#import "ODSelectAddressViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface ODAddNewAddressViewController ()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIView *infoView;
@property(nonatomic,strong)AMapGeoPoint *location;
@property(nonatomic,copy)NSString *isDefault;

@end

@implementation ODAddNewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isDefault = @"";
    self.navigationItem.title = self.naviTitle;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(saveInfoClick) color:nil highColor:nil title:@"保存"];
    
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
            button.tag = i+1;
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoView.frame)+6, kScreenSize.width, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView addGestureRecognizer:tapGesture];
    [self.view addSubview:bottomView];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 15, 20, 20)];
    self.imageView.image = [UIImage imageNamed:@"icon_Default address_default"];
    [bottomView addSubview:self.imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+8, 15, 200, 20)];
    label.text = @"设为默认地址";
    label.font = [UIFont systemFontOfSize:13.5];
    label.textColor = [UIColor colorGloomyColor];
    [bottomView addSubview:label];
    
}

-(void)saveInfoClick{
    UITextField *nameTextField = (UITextField *)[self.infoView viewWithTag:1];
    UITextField *phoneNumTextField = (UITextField *)[self.infoView viewWithTag:2];
    UIButton *addressButton = (UIButton *)[self.view viewWithTag:3];
    UITextField *addressTitleTextField = (UITextField *)[self.view viewWithTag:4];
    if (nameTextField.text.length&&phoneNumTextField.text.length&&addressButton.titleLabel.text.length&&addressTitleTextField.text.length) {
        [self saveAddress];
    }else if (!nameTextField.text.length){
        [ODProgressHUD showInfoWithStatus:@"请输入姓名"];
    }else if (!phoneNumTextField.text.length){
        [ODProgressHUD showInfoWithStatus:@"请输入正确手机号"];
    }else if (!addressButton.titleLabel.text.length){
        [ODProgressHUD showInfoWithStatus:@"请输入定位位置"];
    }else if (!addressTitleTextField.text.length){
        [ODProgressHUD showInfoWithStatus:@"请输入地址"];
    }
    
}


-(void)buttonClick:(UIButton *)button{
    UITextField *textField = (UITextField *)[self.infoView viewWithTag:4];
    ODSelectAddressViewController *controller = [[ODSelectAddressViewController alloc]init];
    __weakSelf;
    controller.myBlock = ^(NSString *address,NSString *addresstitle,AMapGeoPoint *location){
        [button setTitle:address forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorGloomyColor] forState:UIControlStateNormal];
        textField.text = addresstitle;
        weakSelf.location = location;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)tapGestureClick:(UITapGestureRecognizer *)tap{
    static BOOL isClick = YES;
    if (isClick) {
        self.imageView.image = [UIImage imageNamed:@"icon_Default address_Selected"];
        isClick = NO;
        self.isDefault = @"1";
    }else{
        self.imageView.image = [UIImage imageNamed:@"icon_Default address_default"];
        isClick = YES;
        self.isDefault = @"0";
    }
}

- (void)saveAddress {
    
    UITextField *nameTextField = (UITextField *)[self.infoView viewWithTag:1];
    UITextField *phoneNumTextField = (UITextField *)[self.infoView viewWithTag:2];
    UIButton *addressButton = (UIButton *)[self.view viewWithTag:3];
    UITextField *addressTitleTextField = (UITextField *)[self.view viewWithTag:4];
    NSDictionary *parameters = @{@"tel" : phoneNumTextField.text,
                                 @"address":addressTitleTextField.text,
                                 @"address_title" : addressButton.titleLabel.text,
                                 @"name" : nameTextField.text,
                                 @"lat":[NSString stringWithFormat:@"%f",self.location.latitude],
                                 @"lng":[NSString stringWithFormat:@"%f",self.location.longitude],
                                 @"is_default":self.isDefault,
                                 };
    
    __weakSelf
    [ODHttpTool getWithURL:ODUrlUserAddressAdd parameters:parameters modelClass:[NSObject class] success:^(id model) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [ODProgressHUD showInfoWithStatus:@"保存成功"];
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

@end
