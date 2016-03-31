//
//  ODMyTopicController.m
//  ODApp
//
//  Created by zhz on 16/1/11.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODMyTopicController.h"
#import "ODMyReleaseTopicViewController.h"
#import "ODMyReplyTopicViewController.h"

@interface ODMyTopicController ()<UIScrollViewDelegate>

@property (nonatomic , strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation ODMyTopicController

#pragma mark - lzayload
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, kScreenSize.width, kScreenSize.height -64 -50)];
        _scrollView.contentSize = CGSizeMake(kScreenSize.width * 2, kScreenSize.height -64 -50);
        _scrollView.userInteractionEnabled = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.navigationItem.title = @"我的话题";
    [self creatSegmentControll];
    [self setupChilidVc];
}

-(void)creatSegmentControll{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我发表的", @"我回复的"]];
    self.segmentedControl.frame = CGRectMake(4, 10, kScreenSize.width - 8, 30);
    self.segmentedControl.clipsToBounds = YES;
    self.segmentedControl.layer.cornerRadius = 7;
    self.segmentedControl.layer.borderWidth = 1;
    self.segmentedControl.layer.borderColor = [UIColor colorGrayColor].CGColor;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.tintColor = [UIColor colorWithRGBString:@"#ffd801" alpha:1];
    self.segmentedControl.selectedSegmentIndex = 0;
    
    NSDictionary *selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [self.segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    NSDictionary *unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                               NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    [self.segmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    [self.segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:self.segmentedControl];
}

-(void)setupChilidVc{
    ODMyReleaseTopicViewController *releaseTopic = [[ODMyReleaseTopicViewController alloc]init];
    releaseTopic.view.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-50);
    ODMyReplyTopicViewController *replyTopic = [[ODMyReplyTopicViewController alloc]init];
    replyTopic.view.frame = CGRectMake(kScreenSize.width, 0, kScreenSize.width, kScreenSize.height-64-50);
    
    [self.scrollView addSubview:releaseTopic.view];
    [self.scrollView addSubview:replyTopic.view];
    
    [self addChildViewController:releaseTopic];
    [self addChildViewController:replyTopic];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isEqual:self.scrollView])
        return;
    int index = scrollView.contentOffset.x / self.view.frame.size.width;
    self.segmentedControl.selectedSegmentIndex = index;
}

#pragma mark - UISegmentDelegate
- (void)segmentAction:(UISegmentedControl *)sender {
    CGPoint point = CGPointMake(self.scrollView.frame.size.width * sender.selectedSegmentIndex, 0);
    [self.scrollView setContentOffset:point animated:YES];
}





@end
