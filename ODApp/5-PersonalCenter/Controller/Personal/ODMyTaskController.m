//
//  ODMyTaskController.m
//  ODApp
//
//  Created by zhz on 16/1/11.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODMyTaskController.h"
#import "ODTypeView.h"
#import "MJRefresh.h"
#import "ODTaskCell.h"
#import "ODBazaarModel.h"
#import "UIImageView+WebCache.h"
#import "ODBazaarDetailViewController.h"
#import "ODViolationsCell.h"
#import "ODOthersInformationController.h"

@interface ODMyTaskController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) ODTypeView *typeView;
@property(nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) BOOL showType;


@property(nonatomic, strong) UICollectionViewFlowLayout *firstFlowLayout;
@property(nonatomic, strong) UICollectionView *firstCollectionView;
@property(nonatomic, assign) NSInteger firstPage;
@property(nonatomic, strong) NSMutableArray *FirstDataArray;
@property(nonatomic, copy) NSString *type;

@property(nonatomic, strong) UICollectionViewFlowLayout *secondFlowLayout;
@property(nonatomic, strong) UICollectionView *secondCollectionView;
@property(nonatomic, assign) NSInteger secondPage;
@property(nonatomic, strong) NSMutableArray *secondDataArray;
@property(nonatomic, strong) UIButton *allTaskButton;


@property(nonatomic, copy) NSString *openID;
@property(nonatomic, strong) UILabel *firstLabel;
@property(nonatomic, strong) UILabel *secondLabel;


@property(nonatomic, assign) NSInteger firstIndex;
@property(nonatomic, assign) NSInteger secondIndex;


@end

@implementation ODMyTaskController

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([self.isFirstRefresh isEqualToString:@"del"]) {
        
        [self.FirstDataArray removeObject:self.FirstDataArray[self.firstIndex]];
        
        [self.firstCollectionView reloadData];
        
    }
    
    
    if (!([self.isFirstRefresh isEqualToString:@""] || [self.isFirstRefresh isEqualToString:@"del"])) {
        
        
        ODBazaarModel *model = self.FirstDataArray[self.firstIndex];
        
        
        model.task_status = self.isFirstRefresh;
        
        [self.FirstDataArray replaceObjectAtIndex:self.firstIndex withObject:model];
        
        [self.firstCollectionView reloadData];
        
        
    }
    
    if (!([self.isSecondRefresh isEqualToString:@""] || [self.isSecondRefresh isEqualToString:@"del"])) {
        
        
        ODBazaarModel *model = self.secondDataArray[self.secondIndex];
        
        model.task_status = self.isSecondRefresh;
        
        [self.secondDataArray replaceObjectAtIndex:self.secondIndex withObject:model];
        
        [self.secondCollectionView reloadData];
        
        
    }
    
    
    self.showType = YES;
    [self.typeView removeFromSuperview];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isFirstRefresh = @"";
    self.isSecondRefresh = @"";
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.firstPage = 1;
    self.secondPage = 1;
    self.type = @"0";
    self.isFirstRefresh = @"";
    self.isSecondRefresh = @"";
    self.showType = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.FirstDataArray = [NSMutableArray array];
    self.secondDataArray = [NSMutableArray array];
    [self navigationInit];
    [self creatSegment];
    [self creatScroller];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 初始化方法
- (void)navigationInit {
    self.navigationItem.title = @"我的任务";
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithType:ODBarButtonTypeTextLeft target:self action:@selector(typeAction:) image:[UIImage imageNamed:@"任务筛选下拉箭头"] highImage:nil textColor:nil highColor:nil title:@"全部任务"];
}

- (void)creatSegment {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我发布的", @"我接受的"]];
    self.segmentedControl.frame = CGRectMake(4, 10, kScreenSize.width - 8, 30);
    self.segmentedControl.clipsToBounds = YES;
    self.segmentedControl.layer.cornerRadius = 7;
    self.segmentedControl.layer.borderWidth = 1;
    self.segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;

    self.segmentedControl.tintColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.selectedSegmentIndex = 0;

    NSDictionary *selectedTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15],
            NSForegroundColorAttributeName : [UIColor blackColor]};
    [self.segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];

    NSDictionary *unselectedTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15],
            NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    [self.segmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];

    [self.segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:self.segmentedControl];
}

- (void)creatScroller {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenSize.width, kScreenSize.height - 40)];
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width * 2, kScreenSize.height - 40);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.alwaysBounceVertical = YES;

    // 弹簧效果
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 是否开启分页
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];


    self.firstFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.firstCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, self.scrollView.frame.size.width, self.scrollView.frame.size.height - 74) collectionViewLayout:self.firstFlowLayout];
    self.firstCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    self.firstCollectionView.dataSource = self;
    self.firstCollectionView.delegate = self;

    [self.firstCollectionView registerNib:[UINib nibWithNibName:@"ODTaskCell" bundle:nil] forCellWithReuseIdentifier:@"first"];
    [self.firstCollectionView registerNib:[UINib nibWithNibName:@"ODViolationsCell" bundle:nil] forCellWithReuseIdentifier:@"second"];

    __weakSelf


    self.firstCollectionView.tag = 111;
    self.firstCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf firstDownRefresh];
    }];
    self.firstCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        [weakSelf firstLoadMoreData];
    }];
    [self.firstCollectionView.mj_header beginRefreshing];
    [self.scrollView addSubview:self.firstCollectionView];


    self.secondFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.secondCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width, 10, self.scrollView.frame.size.width, self.scrollView.frame.size.height - 74) collectionViewLayout:self.secondFlowLayout];
    self.secondCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    self.secondCollectionView.dataSource = self;
    self.secondCollectionView.delegate = self;

    [self.secondCollectionView registerNib:[UINib nibWithNibName:@"ODTaskCell" bundle:nil] forCellWithReuseIdentifier:@"first"];
    [self.secondCollectionView registerNib:[UINib nibWithNibName:@"ODViolationsCell" bundle:nil] forCellWithReuseIdentifier:@"second"];

    self.secondCollectionView.tag = 222;
    self.secondCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf secondDownRefresh];
    }];
    self.secondCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        [weakSelf secondLoadMoreData];
    }];
    [self.secondCollectionView.mj_header beginRefreshing];


    [self.scrollView addSubview:self.secondCollectionView];
}

- (void)createTypeView {

    self.typeView = [ODTypeView getView];
    self.typeView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.typeView.layer.borderWidth = 1;
    self.typeView.layer.borderColor = [UIColor blackColor].CGColor;
    self.typeView.frame = CGRectMake(kScreenSize.width - 100, 0, 100, 185);
    [self.view addSubview:self.typeView];


    UITapGestureRecognizer *allTaskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allTaskAction)];
    [self.typeView.allTaskImageView addGestureRecognizer:allTaskTap];


    UITapGestureRecognizer *waitCompleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waitCompleteAction)];
    [self.typeView.waitingCompleteImageView addGestureRecognizer:waitCompleteTap];


    UITapGestureRecognizer *waitTaskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waitTaskAction)];
    [self.typeView.watingTaskImageView addGestureRecognizer:waitTaskTap];

    UITapGestureRecognizer *completeTaskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeTaskAction)];
    [self.typeView.completeTaskImageView addGestureRecognizer:completeTaskTap];

    UITapGestureRecognizer *overdueTaskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overdueTaskAction)];
    [self.typeView.overdueTaskImageView addGestureRecognizer:overdueTaskTap];


    UITapGestureRecognizer *violationsTaskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(violationsTaskAction)];
    [self.typeView.violationsTaskImageView addGestureRecognizer:violationsTaskTap];
}

#pragma mark - 请求数据

- (void)firstGetData {
    NSString *countNumber = [NSString stringWithFormat:@"%ld", (long) self.firstPage];
    
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city_id"] = [NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID];
    params[@"suggest"] = @"0";
    params[@"task_status"] = self.type;
    params[@"page"] = countNumber;
    params[@"my"] = @"1";
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlTaskList parameters:params modelClass:[ODBazaarTasksModel class] success:^(id model)
     {
         if ([countNumber isEqualToString:@"1"]) {
             [weakSelf.FirstDataArray removeAllObjects];
             
             [weakSelf.firstLabel removeFromSuperview];
         }
         
         ODBazaarTasksModel *tasksModel = [model result];
         
         [weakSelf.FirstDataArray addObjectsFromArray:tasksModel.tasks];
         
         if (weakSelf.FirstDataArray.count == 0) {
             weakSelf.firstLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(self.scrollView.center.x - 40, KScreenHeight / 2, 80, 30) text:@"暂无任务" font:16 alignment:@"center" color:@"#000000" alpha:1];
             [weakSelf.scrollView addSubview:self.firstLabel];
         }
         [weakSelf.firstCollectionView.mj_header endRefreshing];
         if (tasksModel.tasks.count == 0) {
             [weakSelf.firstCollectionView.mj_footer endRefreshingWithNoMoreData];
         }
         else
         {
             [weakSelf.firstCollectionView.mj_footer endRefreshing];
         }
         [weakSelf.firstCollectionView reloadData];
         
     } failure:^(NSError *error) {
         [weakSelf.secondCollectionView.mj_header endRefreshing];
         [weakSelf.secondCollectionView.mj_footer endRefreshing];
         [ODProgressHUD showInfoWithStatus:@"网络异常"];
     }];
}

- (void)secondGetData {
    NSString *countNumber = [NSString stringWithFormat:@"%ld", (long) self.secondPage];
    
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city_id"] = [NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID];
    params[@"suggest"] = @"0";
    params[@"task_status"] = self.type;
    params[@"page"] = countNumber;
    params[@"my"] = @"2";
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlTaskList parameters:params modelClass:[ODBazaarTasksModel class] success:^(id model)
     {
         if ([countNumber isEqualToString:@"1"]) {
             [weakSelf.secondDataArray removeAllObjects];
             [weakSelf.secondLabel removeFromSuperview];
         }
         
         ODBazaarTasksModel *tasksModel = [model result];
         [weakSelf.secondDataArray addObjectsFromArray:tasksModel.tasks];
         
         if (weakSelf.secondDataArray.count == 0) {
             weakSelf.secondLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(weakSelf.scrollView.center.x - 40 + weakSelf.scrollView.frame.size.width, KScreenHeight / 2, 80, 30) text:@"暂无任务" font:16 alignment:@"center" color:@"#000000" alpha:1];
             [weakSelf.scrollView addSubview:self.secondLabel];
         }
         
         [weakSelf.secondCollectionView.mj_header endRefreshing];
         
         if (tasksModel.tasks.count == 0) {
             [weakSelf.secondCollectionView.mj_footer endRefreshingWithNoMoreData];
         }
         else
         {
             [weakSelf.secondCollectionView.mj_footer endRefreshing];
         }
         
         [weakSelf.secondCollectionView reloadData];
         
     } failure:^(NSError *error) {
         [weakSelf.secondCollectionView.mj_header endRefreshing];
         [weakSelf.secondCollectionView.mj_footer endRefreshing];
         [ODProgressHUD showInfoWithStatus:@"网络异常"];
     }];
}

#pragma mark - UICollectionView 数据源方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == 111) {
        
        ODBazaarModel *model = self.FirstDataArray[indexPath.row];
        NSString *status = [NSString stringWithFormat:@"%@", model.task_status];
        
        if ([status isEqualToString:@"-1"]) {
            ODViolationsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
            
            cell.model = model;
            [cell.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
            
        } else {
            
            ODTaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            
            cell.model = model;
            [cell.userImageViewButton addTarget:self action:@selector(othersInformationClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.userImageViewButton.tag = 111;
            
            
            return cell;
            
        }
        
    } else {
        
        ODBazaarModel *model = self.secondDataArray[indexPath.row];
        NSString *status = [NSString stringWithFormat:@"%@", model.task_status];
        
        if ([status isEqualToString:@"-1"]) {
            ODViolationsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
            
            cell.model = model;
            [cell.deleteButton removeFromSuperview];
            return cell;
            
            
        } else {
            
            ODTaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            
            cell.model = model;
            [cell.userImageViewButton addTarget:self action:@selector(othersInformationClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.userImageViewButton.tag = 222;
            
            
            return cell;
            
        }
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 111) {
        return self.FirstDataArray.count;
    }
    else {
        return self.secondDataArray.count;
    }
}

#pragma mark - UICollectionView 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == 111) {
        
        
        self.firstIndex = indexPath.row;
        
        
        ODBazaarModel *model = self.FirstDataArray[indexPath.row];
        NSString *status = [NSString stringWithFormat:@"%@", model.task_status];
        if ([status isEqualToString:@"-1"]) {;
        } else {
            ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc] init];
            bazaarDetail.myBlock = ^(NSString *del) {
                
                self.isFirstRefresh = del;
                
                
            };
            
            bazaarDetail.task_id = [NSString stringWithFormat:@"%@", model.task_id];
            bazaarDetail.open_id = [NSString stringWithFormat:@"%@", model.open_id];
            bazaarDetail.task_status_name = [NSString stringWithFormat:@"%@", model.task_status_name];
            [self.navigationController pushViewController:bazaarDetail animated:YES];
        }
        
        
    } else if (collectionView.tag == 222) {
        
        
        self.secondIndex = indexPath.row;
        
        ODBazaarModel *model = self.secondDataArray[indexPath.row];
        NSString *status = [NSString stringWithFormat:@"%@", model.task_status];
        
        if ([status isEqualToString:@"-1"]) {;
        } else {
            ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc] init];
            
            bazaarDetail.myBlock = ^(NSString *del) {
                
                self.isSecondRefresh = del;
                
                
            };
            
            
            bazaarDetail.task_id = [NSString stringWithFormat:@"%@", model.task_id];
            bazaarDetail.open_id = [NSString stringWithFormat:@"%@", model.open_id];
            bazaarDetail.task_status_name = [NSString stringWithFormat:@"%@", model.task_status_name];
            [self.navigationController pushViewController:bazaarDetail animated:YES];
            
        }
        
    }
    
    
}
//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kScreenSize.width, 140);
    
}
//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - UIScrollView 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isEqual:self.scrollView])
        return;
    
    int page = scrollView.contentOffset.x / self.view.frame.size.width;
    
    
    self.showType = YES;
    [self.typeView removeFromSuperview];
    
    self.segmentedControl.selectedSegmentIndex = page;
    
    
}

#pragma mark - UISegmentDelegate
- (void)segmentAction:(UISegmentedControl *)sender {
    self.showType = YES;
    [self.typeView removeFromSuperview];
    
    
    CGPoint point = CGPointMake(self.scrollView.frame.size.width * sender.selectedSegmentIndex, 0);
    [self.scrollView setContentOffset:point animated:YES];
}

#pragma mark - 事件方法

- (void)typeAction:(UIButton *)sender {
    if (self.showType) {
        [self createTypeView];
    } else {
        [self.typeView removeFromSuperview];
    }


    self.showType = !self.showType;

}

- (void)deleteAction:(UIButton *)sender {

    ODTaskCell *cell = (ODTaskCell *) sender.superview.superview;
    NSIndexPath *indexPath = [self.firstCollectionView indexPathForCell:cell];
    ODBazaarModel *model = self.FirstDataArray[indexPath.row];

    [self.FirstDataArray removeObject:self.FirstDataArray[indexPath.row]];


    [self.firstCollectionView reloadData];


    NSString *taskId = [NSString stringWithFormat:@"%@", model.task_id];
    [self delegateTaskWith:taskId];


}

- (void)othersInformationClick:(UIButton *)sender {

    ODTaskCell *cell = (ODTaskCell *) sender.superview.superview;
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];


    if (sender.tag == 111) {

        ;


    } else {

        NSIndexPath *indexpath = [self.secondCollectionView indexPathForCell:cell];
        ODBazaarModel *model = self.secondDataArray[indexpath.row];
        vc.open_id = model.open_id;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)delegateTaskWith:(NSString *)taskId {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = taskId;
    params[@"type"] = @"2";
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlBbsDel parameters:params modelClass:[NSObject class] success:^(id model)
     {
         [ODProgressHUD showInfoWithStatus:@"删除成功"];
     } failure:^(NSError *error) {
         [weakSelf.firstCollectionView.mj_header endRefreshing];
         [weakSelf.secondCollectionView.mj_header endRefreshing];
     }];
}


// 选择类型
- (void)allTaskAction {
    self.type = @"0";

    [self.firstCollectionView.mj_header beginRefreshing];
    [self.secondCollectionView.mj_header beginRefreshing];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithType:ODBarButtonTypeTextLeft target:self action:@selector(typeAction:) image:[UIImage imageNamed:@"任务筛选下拉箭头"] highImage:nil textColor:nil highColor:nil title:@"全部任务"];


    [self.typeView removeFromSuperview];
    self.showType = YES;

}

- (void)waitTaskAction {
    self.type = @"1";

    [self.firstCollectionView.mj_header beginRefreshing];
    [self.secondCollectionView.mj_header beginRefreshing];


    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithType:ODBarButtonTypeTextLeft target:self action:@selector(typeAction:) image:[UIImage imageNamed:@"任务筛选下拉箭头"] highImage:nil textColor:nil highColor:nil title:@"等待派单"];

    [self.typeView removeFromSuperview];
    self.showType = YES;

}

- (void)waitCompleteAction {

    self.type = @"2";

    [self.firstCollectionView.mj_header beginRefreshing];
    [self.secondCollectionView.mj_header beginRefreshing];


    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithType:ODBarButtonTypeTextLeft target:self action:@selector(typeAction:) image:[UIImage imageNamed:@"任务筛选下拉箭头"] highImage:nil textColor:nil highColor:nil title:@"等待完成"];


    [self.typeView removeFromSuperview];
    self.showType = YES;

}

- (void)completeTaskAction {
    self.type = @"4";

    [self.firstCollectionView.mj_header beginRefreshing];
    [self.secondCollectionView.mj_header beginRefreshing];


    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithType:ODBarButtonTypeTextLeft target:self action:@selector(typeAction:) image:[UIImage imageNamed:@"任务筛选下拉箭头"] highImage:nil textColor:nil highColor:nil title:@"完成任务"];


    [self.typeView removeFromSuperview];
    self.showType = YES;

}


- (void)overdueTaskAction {
    self.type = @"-2";

    [self.firstCollectionView.mj_header beginRefreshing];
    [self.secondCollectionView.mj_header beginRefreshing];


    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithType:ODBarButtonTypeTextLeft target:self action:@selector(typeAction:) image:[UIImage imageNamed:@"任务筛选下拉箭头"] highImage:nil textColor:nil highColor:nil title:@"过期任务"];


    [self.typeView removeFromSuperview];
    self.showType = YES;

}

- (void)violationsTaskAction {
    self.type = @"-1";

    [self.firstCollectionView.mj_header beginRefreshing];
    [self.secondCollectionView.mj_header beginRefreshing];


    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithType:ODBarButtonTypeTextLeft target:self action:@selector(typeAction:) image:[UIImage imageNamed:@"任务筛选下拉箭头"] highImage:nil textColor:nil highColor:nil title:@"违规任务"];


    [self.typeView removeFromSuperview];
    self.showType = YES;

}

- (void)firstDownRefresh {

    self.firstPage = 1;
    [self firstGetData];


}


- (void)firstLoadMoreData {
    self.firstPage++;
    [self firstGetData];

}

- (void)secondDownRefresh {

    self.secondPage = 1;
    [self secondGetData];


}

- (void)secondLoadMoreData {
    self.secondPage++;
    [self secondGetData];

}

@end
