//
//  ODUserGenderController.m
//  ODApp
//
//  Created by zhz on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
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
    
    UIImageView *manView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 42.5)];
    manView.backgroundColor = [UIColor whiteColor];
    manView.userInteractionEnabled = YES;
    [self.view addSubview:manView];
    
    UITapGestureRecognizer *manTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manAction)];
    [manView addGestureRecognizer:manTap];
    
    UILabel *manLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, 0, 50, 42.5)];
    manLabel.text = @"男";
    manLabel.font = [UIFont systemFontOfSize:12.5];
    [manView addSubview:manLabel];
    
    UIImageView *firstArror = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - ODLeftMargin - 14, 14.25, 14, 14)];
    firstArror.image = [UIImage imageNamed:@"rightjiantou"];
    [manView addSubview:firstArror];
    
    UIImageView *firstLine = [[UIImageView alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(manView.frame), kScreenSize.width - ODLeftMargin, 0.5)];
    firstLine.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.view addSubview:firstLine];
    UIImageView *firstSpaceLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(manView.frame), ODLeftMargin, 0.5)];
    firstSpaceLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstSpaceLine];
   
    UIImageView *womanView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstLine.frame), kScreenSize.width, 42.5)];
    womanView.backgroundColor = [UIColor whiteColor];
    womanView.userInteractionEnabled = YES;
    [self.view addSubview:womanView];
    
    UITapGestureRecognizer *womanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(womanAction)];
    [womanView addGestureRecognizer:womanTap];
   
    UILabel *womanLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, 0, 50, 42.5)];
    womanLabel.text = @"女";
    womanLabel.font = [UIFont systemFontOfSize:12.5];
    [womanView addSubview:womanLabel];
    
    UIImageView *secondArror = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - ODLeftMargin - 14, 14.25, 14, 14)];
    secondArror.image = [UIImage imageNamed:@"rightjiantou"];
    [womanView addSubview:secondArror];
    
    UIImageView *secondLine = [[UIImageView alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(womanView.frame), kScreenSize.width - ODLeftMargin, 0.5)];
    secondLine.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.view addSubview:secondLine];
    UIImageView *secondSpaceLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(womanView.frame), ODLeftMargin, 0.5)];
    secondSpaceLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondSpaceLine];
}

#pragma mark - 点击事件
- (void)manAction
{
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"gender":@"1", @"open_id":self.openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
   
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kChangeUserInformationUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (weakSelf.getTextBlock) {
                if (weakSelf.getTextBlock) {
                    weakSelf.getTextBlock(@"1");
                }
             
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
          
            
            [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];
            
            
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
  
    }];
}

- (void)womanAction
{
    self.managers = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"gender":@"2", @"open_id":self.openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
   
    __weak typeof (self)weakSelf = self;
    [self.managers GET:kChangeUserInformationUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (weakSelf.getTextBlock) {
                if (weakSelf.getTextBlock) {
                    weakSelf.getTextBlock(@"2");
                }
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];

        }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
