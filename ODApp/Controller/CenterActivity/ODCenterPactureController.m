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
    self.navigationItem.title = self.activityName;
    [self initWebView];
}

- (void)initWebView
{
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    [self.view addSubview:web];
    [web loadRequest:request];
}

@end
