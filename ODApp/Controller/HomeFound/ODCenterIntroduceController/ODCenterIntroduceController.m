//
//  ODCenterIntroduceController.m
//  ODApp
//
//  Created by Bracelet on 16/1/6.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODCenterIntroduceController.h"




@interface ODCenterIntroduceController ()

@property (nonatomic, strong)ODHomeFoundViewController *homeDetail;


@end


@implementation ODCenterIntroduceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.activityTitle;
//    self.view.backgroundColor = [UIColor whiteColor];
    [self createWebView];
}

- (void)createWebView
{

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self.view addSubview:self.webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
