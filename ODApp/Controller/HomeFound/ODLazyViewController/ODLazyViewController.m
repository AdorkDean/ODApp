//
//  ODLazyViewController.m
//  ODApp
//
//  Created by 代征钏 on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODLazyViewController.h"



@interface ODLazyViewController ()

@end

@implementation ODLazyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    
    [self navigationInit];
    [self createJobButton];
    [self createScrollView];
}

- (void)navigationInit
{

    self.navigationController.navigationBar.hidden = YES;
    
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3  "];
    [self.view addSubview:self.headView];
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80) / 2, 28, 80, 20) text:@"去偷懒" font:17 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16, 44, 44) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.headView addSubview:backButton];
}

- (void)createJobButton
{

    UIButton *otherJobButton = [ODClassMethod creatButtonWithFrame:CGRectMake(4, 64 + 4, kScreenSize.width * 0.6, 40) target:self sel:@selector(otherJobButtonClick:) tag:0 image:nil title:@"看看别人发了什么任务" font:14];
    otherJobButton.backgroundColor = [UIColor colorWithHexString:@"#ffd802" alpha:1];
    [otherJobButton setTitleColor:[UIColor colorWithHexString:@"#484848" alpha:1] forState:UIControlStateNormal];
    otherJobButton.layer.cornerRadius = 7;
    otherJobButton.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    otherJobButton.layer.borderWidth = 1;
    [self.view addSubview:otherJobButton];
    
    UIButton *buildMyJobButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width * 0.6 + 10, 64 + 4, kScreenSize.width * 0.4 - 16, 40) target:self sel:@selector(buildMyJobButtonClick:) tag:0 image:nil title:@"我也要发任务" font:14];
    buildMyJobButton.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [buildMyJobButton setTitleColor:[UIColor colorWithHexString:@"#484848" alpha:1] forState:UIControlStateNormal];
    buildMyJobButton.layer.cornerRadius = 7;
    buildMyJobButton.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    buildMyJobButton.layer.borderWidth = 1;
    [self.view addSubview:buildMyJobButton];
    
    UIImageView *buildMyJobImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width - 21, 64 + 4 + 11.5, 10, 17) imageName:@"我也要发布任务icon" tag:0];
    [self.view addSubview:buildMyJobImageView];
    
    UILabel *detailesLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(4, 64 + 4 + 40 + 10, kScreenSize.width, 15) text:@"以下为任务攻略图文详情" font:13 alignment:@"left" color:@"#8e8e8e" alpha:1 maskToBounds:NO];
    [self.view addSubview:detailesLabel];
}

- (void)createScrollView
{

    self.scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(4, 64 + 4 + 40 + 10 + 15 + 10, kScreenSize.width - 8,kScreenSize.height - (64 + 4 + 40 + 10 + 15 + 10))];
    self.scrollView.contentSize = CGSizeMake(3 * (kScreenSize.width - 8), kScreenSize.height - (64 + 4 + 40 + 10 + 15 + 10));
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            UIImageView *imageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(0, 0, kScreenSize.width - 8, kScreenSize.height - (64 + 4 + 40 + 10 + 15 + 10)) imageName:@"任务攻略图文详情图一" tag:0];
            [self.scrollView addSubview:imageView];
        }
        if (i == 1) {
            UIImageView *imageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width - 8, 0, kScreenSize.width - 8, kScreenSize.height - (64 + 4 + 40 + 10 + 15 + 10)) imageName:@"任务攻略图文详情图二" tag:0];
            [self.scrollView addSubview:imageView];
        }
        if (i == 2) {
            UIImageView *imageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(2 * (kScreenSize.width - 8), 0, kScreenSize.width - 8, kScreenSize.height - (64 + 4 + 40 + 10 + 15 + 10)) imageName:@"任务攻略图文详情图三" tag:0];
            [self.scrollView addSubview:imageView];
        }
    }
    
    [self.view addSubview:self.scrollView];
}


- (void)backButtonClick:(UIButton *)button
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)otherJobButtonClick:(UIButton *)button
{
    
    self.isJob =YES;
    
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.selectedIndex = 2;
    
    NSInteger index = 2;
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *newButton = (UIButton *)[tabBar.imageView viewWithTag:1+i];
        
        if (i != index) {
            newButton.selected = NO;
        }else{
            newButton.selected = YES;
        }
    }
}

- (void)buildMyJobButtonClick:(UIButton *)button
{

    self.isJob =NO;
    
    ODBazaarReleaseTaskViewController *vc = [[ODBazaarReleaseTaskViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = YES;
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated
{

    if (self.isJob) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
    
    }
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
