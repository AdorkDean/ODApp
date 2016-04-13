//
//  ODCenterDetailsController.m
//  ODApp
//
//  Created by Bracelet on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODCenterDetailController.h"

#import "UIImageView+WebCache.h"

#import "ODPersonalCenterViewController.h"
#import "ODChoseCenterController.h"
#import "ODPrecontractViewController.h"
#import "ODPublicWebViewController.h"
#import "ODTabBarController.h"

#import "ODStoreDetailModel.h"

#import "ODCenterDetailView.h"

@interface ODCenterDetailController () <UIScrollViewDelegate>

@property(nonatomic, strong) ODStoreDetailModel *model;

@property (nonatomic, strong) UIScrollView *scrollView;

// 顶部图片scrollView
@property (nonatomic, strong) UIScrollView *pictureScrollView;

@property(nonatomic, strong) UIPageControl *pageControl;

// 中心信息
@property (nonatomic,strong) ODCenterDetailView *centerDetailView;

// 场地预约按钮
@property (nonatomic, strong) UIButton *centerOrderButton;

// 中心描述
@property (nonatomic, strong) UIView *centerStateView;

@end

@implementation ODCenterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"中心详情";
    [self getRequestData];
}

#pragma mark - lifeCycle

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
    // Dispose of any resources that can be recreated.
}

#pragma mark - LazyLoad

#pragma mark - 底层ScrollView
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight)];
        _scrollView.backgroundColor = [UIColor backgroundColor];
        [self.view addSubview:self.scrollView];
    }
    return _scrollView;
}

#pragma mark - 顶部图片ScrollView
- (UIScrollView *)pictureScrollView {
    if (!_pictureScrollView) {
        float scrollViewHeight = KScreenWidth * 376/750;
        _pictureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, scrollViewHeight)];
        _pictureScrollView.contentSize = CGSizeMake(KScreenWidth * self.model.pics.count, scrollViewHeight);
        
        _pictureScrollView.delegate = self;
        _pictureScrollView.showsHorizontalScrollIndicator = NO;
        _pictureScrollView.showsVerticalScrollIndicator = NO;
        _pictureScrollView.pagingEnabled = YES;
        
        for (int i = 0; i < self.model.pics.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenSize.width, 0, kScreenSize.width, scrollViewHeight)];
            [imageView sd_setImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@", self.model.pics[i]]]placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
            [_pictureScrollView addSubview:imageView];
        }
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.center.x - 50, scrollViewHeight - 30, 100, 20)];
        self.pageControl.backgroundColor = [UIColor clearColor];
        self.pageControl.numberOfPages = self.model.pics.count;
        self.pageControl.currentPage = 0;
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:_pictureScrollView];
        [self.scrollView addSubview:self.pageControl];
    }
    return _pictureScrollView;
}

#pragma mark - 中心信息
- (void)createCenterDetailView {
    self.centerDetailView = [[ODCenterDetailView alloc] init];
    self.centerDetailView = [ODCenterDetailView centerDetailView];
    [self.centerDetailView setModel:self.model];
    
    float cellHeight = 170;
    cellHeight = cellHeight + [ODHelp textHeightFromTextString:self.model.name width:KScreenWidth - 105 - ODLeftMargin fontSize:12] - 12;
    cellHeight = cellHeight + [ODHelp textHeightFromTextString:self.model.address width:KScreenWidth - 105 - ODLeftMargin fontSize:12] - 12;
    cellHeight = cellHeight + [ODHelp textHeightFromTextString:self.model.business_hours width:KScreenWidth - 105 - ODLeftMargin fontSize:12] - 12;
    
    
    self.centerDetailView.frame = CGRectMake(5, CGRectGetMaxY(self.pictureScrollView.frame) + 5, KScreenWidth - 10, cellHeight);
    [self.centerDetailView.centerTelButton addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerDetailView.centerAddressButton addTarget:self action:@selector(addressAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.centerDetailView];
}

#pragma mark - 场地预约
- (UIButton *)centerOrderButton {
    if (!_centerOrderButton) {
        _centerOrderButton = [[UIButton alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.centerDetailView.frame) + 5, KScreenWidth - 10, 30)];
        [_centerOrderButton setTitle:@"场地预约" forState:UIControlStateNormal];
        [_centerOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _centerOrderButton.backgroundColor = [UIColor themeColor];
        _centerOrderButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        _centerOrderButton.layer.cornerRadius = 5;
        _centerOrderButton.layer.borderColor = [UIColor lineColor].CGColor;
        _centerOrderButton.layer.borderWidth = 0.5f;
        [_centerOrderButton addTarget:self action:@selector(appointmentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_centerOrderButton];
    }
    return _centerOrderButton;
}

#pragma mark - 中心描述
- (UIView *)centerStateView {
    if (!_centerStateView) {
        float centerStateViewHeight = [ODHelp textHeightFromTextString:self.model.desc width:KScreenWidth - ODLeftMargin * 2 fontSize:12.5] + 10;

        _centerStateView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.centerOrderButton.frame) + 5, KScreenWidth - 10, centerStateViewHeight)];
        _centerStateView.backgroundColor = [UIColor whiteColor];
        _centerStateView.layer.cornerRadius = 5;
        _centerStateView.layer.borderColor = [UIColor lineColor].CGColor;
        _centerStateView.layer.borderWidth = 0.5f;
        UILabel *centerStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin - 5, 0, KScreenWidth - ODLeftMargin * 2, centerStateViewHeight)];
        centerStateLabel.numberOfLines = 0;
        centerStateLabel.text = self.model.desc;
        centerStateLabel.textColor = [UIColor blackColor];
        centerStateLabel.font = [UIFont systemFontOfSize:12.5];
        [_centerStateView addSubview:centerStateLabel];
        [self.scrollView addSubview:_centerStateView];
        self.scrollView.contentSize = CGSizeMake(KScreenWidth, CGRectGetMaxY(_centerStateView.frame) + 5);
    }
    return _centerStateView;
}

#pragma mark - 请求数据
- (void)getRequestData {
    __weakSelf
    [ODHttpTool getWithURL:ODUrlOtherStoreDetail parameters:@{@"store_id" : self.storeId} modelClass:[ODStoreDetailModel class] success:^(id model)
    {
        weakSelf.model = [model result];
        [weakSelf createCenterDetailView];
        [weakSelf centerOrderButton];
        [weakSelf centerStateView];
    }
    failure:^(NSError *error) {
         
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 拿到偏移量
    CGPoint offset = self.pictureScrollView.contentOffset;
    
    // 算出偏移了几个fram.width
    NSInteger currentIndex = offset.x / self.pictureScrollView.frame.size.width;
    
    // 根据currentIndex 修改pageControl显示的点的位置
    self.pageControl.currentPage = currentIndex;
}

#pragma mark - Action

#pragma mark - 场地预约
- (void)appointmentAction:(UIButton *)sender {
    
    if ([ODUserInformation sharedODUserInformation].openID.length == 0) {
        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        ODPrecontractViewController *vc = [[ODPrecontractViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.storeId = self.storeId;
    }
}

#pragma mark - 打电话
- (void)phoneAction:(UITapGestureRecognizer *)sender {
    [self.view callToNum:self.centerDetailView.centerTelLabel.text];
}

#pragma mark - 中心地址
- (void)addressAction:(UITapGestureRecognizer *)sender {
    ODPublicWebViewController *vc = [[ODPublicWebViewController alloc] init];
    NSString *webUrl = [NSString stringWithFormat:@"%@/%@?lng=%@&lat=%@",ODH5BaseURL,ODWebUrlMapSearch, self.model.lng, self.model.lat];
    vc.webUrl = webUrl;
    vc.navigationTitle = self.model.name;
    vc.isShowProgress = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
