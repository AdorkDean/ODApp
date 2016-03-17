//
//  ODCenterDetailController.m
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODCenterDetailController.h"
#import "ODCenderDetailView.h"
#import "UIImageView+WebCache.h"
#import "ODChoseCenterController.h"
#import "ODPrecontractViewController.h"
#import "MJRefresh.h"
#import "ODStoreDetailModel.h"

#import "ODTabBarController.h"
#import "ODUserInformation.h"
#import "ODPersonalCenterViewController.h"
#import "ODPublicWebViewController.h"

int pageNumnber = 0;

@interface ODCenterDetailController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) ODCenderDetailView *centerDetailView;
@property(nonatomic, strong) ODStoreDetailModel *model;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) UILabel *centerNameLabe;
@property(nonatomic, strong) NSTimer *myTimer;

@end

@implementation ODCenterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"中心详情";
    [self getData];
}

#pragma mark - lifeCycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    pageNumnber = 0;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.myTimer invalidate];
    self.myTimer = nil;
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 点击事件

- (void)appointmentAction:(UIButton *)sender {

    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {

        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];


    } else {
        ODPrecontractViewController *vc = [[ODPrecontractViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.storeId = self.storeId;
    }
}

- (void)phoneAction:(UITapGestureRecognizer *)sender
{
    [self.view callToNum:self.centerDetailView.phoneLabel.text];
}


- (void)addressAction:(UITapGestureRecognizer *)sender
{
    ODPublicWebViewController *vc = [[ODPublicWebViewController alloc] init];
    NSString *webUrl = [NSString stringWithFormat:@"%@?lng=%@&lat=%@",ODWebUrlMapSearch, self.model.lng, self.model.lat];
    vc.webUrl = webUrl;
    vc.navigationTitle = self.model.name;
    vc.isShowProgress = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 定时器

- (void)timerFired {
    pageNumnber++;
    if (pageNumnber == self.model.pics.count) {
        [self.centerDetailView.scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];

        pageNumnber = 0;
    } else {

        [self.centerDetailView.scrollerView setContentOffset:CGPointMake(pageNumnber * kScreenSize.width, 0) animated:YES];

    }


    self.pageControl.currentPage = pageNumnber;


}

#pragma mark - 请求数据

- (void)getData
{
    __weakSelf
    [ODHttpTool getWithURL:ODUrlOtherStoreDetail parameters:@{@"store_id" : self.storeId} modelClass:[ODStoreDetailModel class] success:^(id model)
    {
        weakSelf.model = [model result];
        [weakSelf.tableView reloadData];
    }
                   failure:^(NSError *error)
     {
        
    }];
}


#pragma mark - 懒加载

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 60) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.centerDetailView;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (ODCenderDetailView *)centerDetailView {
    if (_centerDetailView == nil) {


        CGRect rect = [self.model.desc boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 0)
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]}
                                                    context:nil];

        self.centerDetailView = [ODCenderDetailView getView];

        self.centerDetailView.frame = CGRectMake(0, 0, kScreenSize.width, 250 + 95 + self.centerDetailView.scrollerHeight.constant + rect.size.height);

   


        self.centerDetailView.detailTextView.text = self.model.desc;
        self.centerDetailView.centerNameLabel.text = self.model.name;
        self.centerDetailView.phoneLabel.text = self.model.tel;
        self.centerDetailView.addressTextView.text = self.model.address;
        self.centerDetailView.addressTextView.scrollEnabled = NO;
        self.centerDetailView.timeTextView.text = self.model.business_hours;


        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneAction:)];
        [self.centerDetailView.phoneLabel addGestureRecognizer:tap];

        [self.centerDetailView.appointmentButton addTarget:self action:@selector(appointmentAction:) forControlEvents:UIControlEventTouchUpInside];


        UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressAction:)];
        [self.centerDetailView.addressImageView addGestureRecognizer:addressTap];




        // 设置scrollerView的内容视图大小
        self.centerDetailView.scrollerView.contentSize = CGSizeMake(self.model.pics.count * kScreenSize.width, self.centerDetailView.scrollerHeight.constant);
        // 设置整页滑动
        self.centerDetailView.scrollerView.pagingEnabled = YES;
        // 隐藏滚动条
        self.centerDetailView.scrollerView.showsHorizontalScrollIndicator = NO;
        self.centerDetailView.scrollerView.delegate = self;

        // 创建图片
        for (int i = 0; i < self.model.pics.count; i++) {

            // 创建imageView;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenSize.width, 0, kScreenSize.width, self.centerDetailView.scrollerHeight.constant)];
            NSString *url = self.model.pics[i];
            [imageView sd_setImageWithURL:[NSURL OD_URLWithString:url]];
            // imageView添加到scroller上
            [self.centerDetailView.scrollerView addSubview:imageView];

        }

        // 创建pageControl
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.center.x - 50, self.centerDetailView.scrollerHeight.constant - 30, 100, 20)];
        self.pageControl.backgroundColor = [UIColor clearColor];
        // 给pageControl设置点的个数
        self.pageControl.numberOfPages = self.model.pics.count;
        // 设置默认选中的点
        self.pageControl.currentPage = 0;
        // 当前选中点的颜色
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        // 未被选中点的颜色
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.userInteractionEnabled = YES;
        [self.centerDetailView addSubview:self.pageControl];

    }
    return _centerDetailView;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }


    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
