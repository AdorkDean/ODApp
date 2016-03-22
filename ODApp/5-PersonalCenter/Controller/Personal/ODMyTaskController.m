//
//  ODMyTaskController.m
//  ODApp
//
//  Created by zhz on 16/1/11.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODMyTaskController.h"
#import "ODMyReleaseTaskViewController.h"
#import "ODMyAcceptTaskViewController.h"

@interface ODMyTaskController () <UIScrollViewDelegate,UIPopoverPresentationControllerDelegate>

@property(nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSString *type;

@end

@implementation ODMyTaskController

#pragma mark - lazyload
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

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatSegmentControll];
    [self setupChilidVc];
    self.navigationItem.title = @"我的任务";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithType:ODBarButtonTypeTextLeft target:self action:@selector(typeAction:) image:[UIImage imageNamed:@"任务筛选下拉箭头"] highImage:nil textColor:nil highColor:nil title:@"全部任务"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)creatSegmentControll {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我发布的", @"我接受的"]];
    self.segmentedControl.frame = CGRectMake(4, 10, kScreenSize.width - 8, 30);
    self.segmentedControl.clipsToBounds = YES;
    self.segmentedControl.layer.cornerRadius = 7;
    self.segmentedControl.layer.borderWidth = 1;
    self.segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.tintColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    
    NSDictionary *selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [self.segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    
    NSDictionary *unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                               NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    [self.segmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];

    [self.segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
}

-(void)setupChilidVc{
    ODMyReleaseTaskViewController *releaseTask = [[ODMyReleaseTaskViewController alloc]init];
    releaseTask.view.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-50);
    ODMyAcceptTaskViewController *acceptTask = [[ODMyAcceptTaskViewController alloc]init];
    acceptTask.view.frame = CGRectMake(kScreenSize.width, 0, kScreenSize.width, kScreenSize.height-64-50);
    
    
    [self.scrollView addSubview:releaseTask.view];
    [self.scrollView addSubview:acceptTask.view];
    
    [self addChildViewController:releaseTask];
    [self addChildViewController:acceptTask];
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

#pragma mark - UIPopDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - action  
- (void)typeAction:(UIButton *)button {
    UIViewController *controller = [[UIViewController alloc]init];
    controller.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    controller.view.layer.borderColor = [UIColor colorWithHexString:@"484848" alpha:1].CGColor;
    controller.view.layer.borderWidth = 0.5;
    controller.view.layer.cornerRadius = 12;
    
    NSArray *array = @[@"全部任务",@"等待派遣",@"等待完成",@"完成任务",@"过期任务",@"违规任务"];
    for (NSInteger i = 0 ; i < array.count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(0, 30*i, 112, 29.5)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(taskClassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [controller.view addSubview:button];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(7, CGRectGetMaxY(button.frame)+0.5, 98, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [controller.view addSubview:lineView];
    }
    //设置弹出模式
    controller.modalPresentationStyle = UIModalPresentationPopover;
    controller.preferredContentSize = CGSizeMake(112, 180);
    UIPopoverPresentationController *popVC = controller.popoverPresentationController;
    controller.popoverPresentationController.sourceView = button;
    controller.popoverPresentationController.sourceRect = button.bounds;
    popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popVC.delegate = self;
    [self presentViewController:controller animated:YES completion:^{
    }];
}

-(void)taskClassButtonClick:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"全部任务"]) {
        self.type = @"0";
    }else if ([button.titleLabel.text isEqualToString:@"等待派遣"]){
        self.type = @"1";
    }else if ([button.titleLabel.text isEqualToString:@"等待完成"]){
        self.type = @"2";
    }else if ([button.titleLabel.text isEqualToString:@"完成任务"]){
        self.type = @"4";
    }else if ([button.titleLabel.text isEqualToString:@"过期任务"]){
        self.type = @"-2";
    }else if ([button.titleLabel.text isEqualToString:@"违规任务"]){
        self.type = @"-1";
    }
    
    NSDictionary *dict = @{@"type":self.type};
    [[NSNotificationCenter defaultCenter]postNotificationName:ODNotificationRefreshTask object:nil userInfo:dict];
    [self dismissViewControllerAnimated:NO completion:nil];
}




@end
