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

@property(nonatomic,strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong) AFHTTPRequestOperationManager *managers;
@property(nonatomic,copy) NSString *openID;
@end

@implementation ODUserGenderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.openID = [ODUserInformation sharedODUserInformation].openID;
    
     self.navigationItem.title = @"修改性别";
     [self createView];
 
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
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/user/change";
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (weakSelf.getTextBlock) {
                if (weakSelf.getTextBlock) {
                    weakSelf.getTextBlock(@"1");
                }
             
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
  
    }];
}

- (void)womanAction
{
    self.managers = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"gender":@"2", @"open_id":self.openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/user/change";
    __weak typeof (self)weakSelf = self;
    [self.managers GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (weakSelf.getTextBlock) {
                if (weakSelf.getTextBlock) {
                    weakSelf.getTextBlock(@"2");
                }
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
        }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

@end
