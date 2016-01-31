//
//  ODCenterPactureController.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODCenterPactureController.h"
#import "ODTabBarController.h"
@interface ODCenterPactureController ()


@end

@implementation ODCenterPactureController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationInit];
  
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.view.userInteractionEnabled = YES;
    self.navigationItem.title = self.activityName;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(fanhui:) color:nil highColor:nil title:@"返回"];
    
    
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, kScreenSize.width, kScreenSize.height)];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    [self.view addSubview:web];
    [web loadRequest:request];
    
    
    
    
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
