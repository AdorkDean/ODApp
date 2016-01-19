//
//  ODUserGenderController.m
//  ODApp
//
//  Created by zhz on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODUserGenderController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"

@interface ODUserGenderController ()

@property (nonatomic , strong) UIView *headView;
@property(nonatomic,strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong) AFHTTPRequestOperationManager *managers;
@property(nonatomic,copy) NSString *openID;
@end

@implementation ODUserGenderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.openID = [ODUserInformation getData].openID;
    
    
     [self navigationInit];
     [self createView];
    
    
}
#pragma mark - 初始化
-(void)navigationInit
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 登陆label
    UILabel *centerNameLabe = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width / 2 - 110, 28, 220, 20) text:@"修改性别" font:17 alignment:@"center" color:@"#000000" alpha:1];
    
    centerNameLabe.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:centerNameLabe];
    
    
    
    // 返回button
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
    
    
    
    
}


- (void)createView
{
    
    UIImageView *manView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, 40)];
    manView.backgroundColor = [UIColor whiteColor];
    manView.userInteractionEnabled = YES;
    [self.view addSubview:manView];
    
    
    
    UITapGestureRecognizer *manTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manAction)];
    [manView addGestureRecognizer:manTap];

    
    
    UILabel *manLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
    manLabel.text = @"男";
    [manView addSubview:manLabel];
    
    
    UIImageView *firstArror = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 30, 10, 20, 20)];
    firstArror.image = [UIImage imageNamed:@"rightjiantou"];
    [manView addSubview:firstArror];
    
    
    UIImageView *firstLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + manView.frame.size.height, kScreenSize.width, 1)];
    firstLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:firstLine];
    
    
    
    UIImageView *womanView = [[UIImageView alloc] initWithFrame:CGRectMake(0, firstLine.frame.origin.y + firstLine.frame.size.height, kScreenSize.width, 40)];
    womanView.backgroundColor = [UIColor whiteColor];
    womanView.userInteractionEnabled = YES;
    [self.view addSubview:womanView];
    
    
    UITapGestureRecognizer *womanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(womanAction)];
    [womanView addGestureRecognizer:womanTap];

    
    
    UILabel *womanLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
    womanLabel.text = @"女";
    [womanView addSubview:womanLabel];
    
    
    UIImageView *secondArror = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 30, 10, 20, 20)];
    secondArror.image = [UIImage imageNamed:@"rightjiantou"];
    [womanView addSubview:secondArror];
    
    
    UIImageView *secondLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, womanView.frame.origin.y + womanView.frame.size.height, kScreenSize.width, 1)];
    secondLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:secondLine];


    
    
    
}

#pragma mark - 点击事件
- (void)manAction
{
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"gender":@"1", @"open_id":self.openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.odong.com/1.0/user/change";
    
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (self.getTextBlock) {
                if (self.getTextBlock) {
                    self.getTextBlock(@"1");
                }
                
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
            
            
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:responseObject[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alter show];
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];



}



- (void)womanAction
{
    self.managers = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"gender":@"2", @"open_id":self.openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.odong.com/1.0/user/change";
    
    [self.managers GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (self.getTextBlock) {
                if (self.getTextBlock) {
                    self.getTextBlock(@"2");
                }
                
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
            
            
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:responseObject[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alter show];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];

      
}



-(void)fanhui:(UIButton *)sender
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
