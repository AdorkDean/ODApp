//
//  ODEvaluationController.m
//  ODApp
//
//  Created by zhz on 16/2/23.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODEvaluationController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "ODCommunityBbsModel.h"
#import "ODCommunityDetailViewController.h"
#import "ODOthersInformationController.h"
#import "ODEvaluationCell.h"
#import "ODSecondEvaluationModel.h"

#import "ODEvaluationView.h"

NSString *const ODEvaluationViewID = @"ODEvaluationViewID";

@interface ODEvaluationController ()< UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) UIScrollView * scrollView;

// 页数
@property (nonatomic , assign) NSInteger taskPageNumber;
@property (nonatomic , assign) NSInteger skillPageNumber;

// 数据数组
@property (nonatomic, strong) NSMutableArray *taskDataArray;
@property (nonatomic, strong) NSMutableArray *skillDataArray;


// UITableView
@property (nonatomic, strong) UITableView *taskTableView;
@property (nonatomic, strong) UITableView *skillTableView;

@property (nonatomic, strong) ODEvaluationView *evaluationView;

@end

@implementation ODEvaluationController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我收到的评价";
    self.taskPageNumber = 1;
    self.skillPageNumber = 1;
    self.taskDataArray = [[NSMutableArray alloc] init];
    self.skillDataArray = [NSMutableArray array];
  
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.typeTitle;
    
    [self creatSegment];
    [self taskGetRequestData];
    [self skillGetRequestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 初始化
-(void)creatSegment {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"任务评价", @"技能评价"]];
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

#pragma mark - Lazy Load

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, kScreenSize.width, kScreenSize.height - 40)];
        self.scrollView.contentSize = CGSizeMake(kScreenSize.width * 2, kScreenSize.height - 50);
        self.scrollView.backgroundColor =[UIColor backgroundColor];
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
    }
    return _scrollView;
}

- (UITableView *)taskTableView {
    if (!_taskTableView) {
        _taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width,self.scrollView.frame.size.height - 64) style:UITableViewStylePlain];
        _taskTableView.backgroundColor = [UIColor backgroundColor];
        _taskTableView.delegate = self;
        _taskTableView.dataSource = self;
        _taskTableView.tag = 111;
        _taskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_taskTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODEvaluationView class]) bundle:nil] forCellReuseIdentifier:ODEvaluationViewID];
        [self.scrollView addSubview:_taskTableView];
        
        __weakSelf
        _taskTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.taskPageNumber = 1;
            [weakSelf taskGetRequestData];
        }];
        _taskTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.taskPageNumber++;
            [weakSelf taskGetRequestData];
        }];
    }
    return _taskTableView;
}

- (UITableView *)skillTableView {
    if (!_skillTableView) {
        _skillTableView = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, self.scrollView.frame.size.width,self.scrollView.frame.size.height - 64) style:UITableViewStylePlain];
        _skillTableView.backgroundColor = [UIColor backgroundColor];
        _skillTableView.delegate = self;
        _skillTableView.dataSource = self;
        _skillTableView.tag = 222;
        _skillTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_skillTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODEvaluationView class]) bundle:nil] forCellReuseIdentifier:ODEvaluationViewID];
        [self.scrollView addSubview:_skillTableView];
        __weakSelf
        _skillTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.skillPageNumber = 1;
            [weakSelf skillGetRequestData];
        }];
        _skillTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.skillPageNumber++                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ;
            [weakSelf skillGetRequestData];
        }];
    }
    return _skillTableView;
}

#pragma mark - Load Data Request

#pragma mark - 任务评价
-(void)taskGetRequestData {
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.taskPageNumber];
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"1";
    params[@"page"] = countNumber;
    params[@"open_id"] = self.openId;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlUserCommentList parameters:params modelClass:[ODEvaluationModel class] success:^(id model) {
        if ([countNumber isEqualToString:@"1"]) {
            [weakSelf.taskDataArray removeAllObjects];
        }
        NSArray *evaluationDatas = [model result];
        [weakSelf.taskDataArray addObjectsFromArray:evaluationDatas];
        
        [ODHttpTool od_endRefreshWith:weakSelf.taskTableView array:evaluationDatas];
        
        ODNoResultLabel *noResultLabel = [[ODNoResultLabel alloc] init];
        if (weakSelf.taskDataArray.count == 0) {
            [noResultLabel showOnSuperView:weakSelf.taskTableView title:@"暂无评价"];
        }
        else {
            [noResultLabel hidden];
        }
     } failure:^(NSError *error) {
         [weakSelf.taskTableView.mj_header endRefreshing];
         [weakSelf.taskTableView.mj_footer endRefreshing];
     }];
}

#pragma mark - 技能评价
-(void)skillGetRequestData {
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.skillPageNumber];
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"3";
    params[@"page"] = countNumber;
    params[@"open_id"] = self.openId;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlUserCommentList parameters:params modelClass:[ODSecondEvaluationModel class] success:^(id model) {
        if ([countNumber isEqualToString:@"1"]) {
            [weakSelf.skillDataArray removeAllObjects];
        }
        NSArray *evaluationDatas = [model result];
        [weakSelf.skillDataArray addObjectsFromArray:evaluationDatas];
         
        [ODHttpTool od_endRefreshWith:weakSelf.skillTableView array:evaluationDatas];
        ODNoResultLabel *noResultLabel = [[ODNoResultLabel alloc] init];
        if (weakSelf.skillDataArray.count == 0) {
            [noResultLabel showOnSuperView:weakSelf.skillTableView title:@"暂无评价"];
        }
        else {
            [noResultLabel hidden];
        }
     } failure:^(NSError *error) {
         [weakSelf.skillTableView.mj_header endRefreshing];
         [weakSelf.skillTableView.mj_footer endRefreshing];
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 111) {
        return self.taskDataArray.count;
    }
    else {
        return self.skillDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODEvaluationView *cell = [tableView dequeueReusableCellWithIdentifier:ODEvaluationViewID];
    if (tableView.tag == 111) {
        ODEvaluationModel *model = self.taskDataArray[indexPath.row];
        [cell setTaskModel:model];
    }
    else {
        
        ODSecondEvaluationModel *model = self.skillDataArray[indexPath.row];
        [cell setSkillModel:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 111) {
        ODEvaluationModel *model = self.taskDataArray[indexPath.row];
        return [ODHelp textHeightFromTextString:model.comment width:KScreenWidth - ODLeftMargin * 2 miniHeight:40 fontSize:12.5];
    }
    else {
        ODSecondEvaluationModel *model = self.skillDataArray[indexPath.row];
        return [ODHelp textHeightFromTextString:model.reason width:KScreenWidth - ODLeftMargin * 2 miniHeight:40 fontSize:12.5];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isEqual:self.scrollView])
        return;
    
    int page = scrollView.contentOffset.x / self.view.frame.size.width;
    
    self.segmentedControl.selectedSegmentIndex  = page;
}


#pragma mark - UISegmentDelegate
- (void)segmentAction:(UISegmentedControl *)sender
{
    CGPoint point = CGPointMake(self.scrollView.frame.size.width * sender.selectedSegmentIndex, 0);
    [self.scrollView setContentOffset:point animated:YES];
    
}


@end
