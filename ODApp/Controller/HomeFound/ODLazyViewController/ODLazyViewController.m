//
//  ODLazyViewController.m
//  ODApp
//
//  Created by Bracelet on 16/1/4.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODLazyViewController.h"


@interface ODLazyViewController ()

@end

@implementation ODLazyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];

    self.navigationItem.title = @"去偷懒";
    [self createJobButton];
    [self createScrollView];
}

- (void)createJobButton {

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

- (void)createScrollView {

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 64 + 4 + 40 + 10 + 15 + 10, kScreenSize.width - 8, kScreenSize.height - (64 + 4 + 40 + 10 + 15 + 10))];
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

- (void)otherJobButtonClick:(UIButton *)button {

    self.isJob = YES;

    self.tabBarController.selectedIndex = 2;
    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationShowBazaar object:nil];

}

- (void)buildMyJobButtonClick:(UIButton *)button {

    self.isJob = NO;
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {

        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {

        ODBazaarReleaseTaskViewController *vc = [[ODBazaarReleaseTaskViewController alloc] init];
        vc.isBazaar = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    if (self.isJob) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

@end
