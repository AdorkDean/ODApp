//
//  ODBazaarViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaarViewController.h"

@interface ODBazaarViewController ()

@end

@implementation ODBazaarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createSkillAndHelpButton];
    [self createScrollView];

    self.navigationItem.title = @"欧动集市";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(releaseButtonClick:) image:[UIImage imageNamed:@"发布任务icon"] highImage:nil];
}


- (void)releaseButtonClick:(UIButton *)button {
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc] init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
    } else {
        if (self.index == 0) {
            ODBazaarReleaseSkillViewController *releaseSkill = [[ODBazaarReleaseSkillViewController alloc] init];
            [self.navigationController pushViewController:releaseSkill animated:YES];
        } else {
            ODBazaarReleaseTaskViewController *releaseTask = [[ODBazaarReleaseTaskViewController alloc] init];
            releaseTask.isBazaar = YES;
            [self.navigationController pushViewController:releaseTask animated:YES];
        }
    }
}

- (void)createSkillAndHelpButton {
    NSArray *array = @[@"换技能", @"求帮助"];
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#484848" alpha:1] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithHexString:@"#ffffff" alpha:1]];
        [button setFrame:CGRectMake((kScreenSize.width / 2) * i, 0, kScreenSize.width / 2, 40)];
        [button addTarget:self action:@selector(changeController:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10010 + i;
        [self.view addSubview:button];

        if (i == 0) {
            self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kScreenSize.width / 2, 1)];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"#ffd802" alpha:1];
            [self.view addSubview:self.lineView];
        }
    }
}

- (void)setIndex:(NSInteger)index {
    CGPoint point = CGPointMake(KScreenWidth * index, 0);
    NSInteger i = point.x / self.view.frame.size.width;
    _index = i;
    self.lineView.frame = CGRectMake((kScreenSize.width / 2) * i, 39, kScreenSize.width / 2, 1);
    [self.view addSubview:self.lineView];
    [self.scrollView setContentOffset:point animated:YES];
}

- (void)changeController:(UIButton *)button {
    self.index = button.tag - 10010;
}

- (void)selectChildViewww:(NSInteger)index {

}

- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenSize.width, kScreenSize.height - ODNavigationHeight - 40 - 55)];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(2 * kScreenSize.width, kScreenSize.height - ODNavigationHeight - 40 - 55);
    [self.view addSubview:self.scrollView];

    ODBazaaeExchangeSkillViewController *exchangeSkill = [[ODBazaaeExchangeSkillViewController alloc] init];
    exchangeSkill.view.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - ODNavigationHeight - 55);

    ODBazaarRequestHelpViewController *requestHelp = [[ODBazaarRequestHelpViewController alloc] init];
    requestHelp.view.frame = CGRectMake(kScreenSize.width, 0, kScreenSize.width, kScreenSize.height - ODNavigationHeight - 55);

    [self.scrollView addSubview:exchangeSkill.view];
    [self.scrollView addSubview:requestHelp.view];

    [self addChildViewController:exchangeSkill];
    [self addChildViewController:requestHelp];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isEqual:self.scrollView])
        return;
    NSInteger i = scrollView.contentOffset.x / self.view.frame.size.width;
    self.index = i;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
