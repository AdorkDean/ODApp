//
//  ODMyTaskController.m
//  ODApp
//
//  Created by zhz on 16/1/11.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODMyTaskController.h"
#import "ODTypeView.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODTaskCell.h"
#import "ODBazaarModel.h"
#import "UIImageView+WebCache.h"
#import "ODBazaarDetailViewController.h"
#import "ODViolationsCell.h"
#import "ODOthersInformationController.h"
@interface ODMyTaskController ()<UIScrollViewDelegate,UICollectionViewDataSource , UICollectionViewDelegate>

@property(nonatomic , strong) UIView *headView;
@property(nonatomic , strong) ODTypeView *typeView;
@property (nonatomic , strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) BOOL showType;


@property (nonatomic , strong) UICollectionViewFlowLayout *firstFlowLayout;
@property (nonatomic , strong) UICollectionView *firstCollectionView;
@property (nonatomic , assign) NSInteger firstPage;
@property (nonatomic, strong) AFHTTPRequestOperationManager *firstManager;
@property (nonatomic, strong) NSMutableArray *FirstDataArray;
@property (nonatomic , copy) NSString *type;

@property (nonatomic , strong) UICollectionViewFlowLayout *secondFlowLayout;
@property (nonatomic , strong) UICollectionView *secondCollectionView;
@property (nonatomic , assign) NSInteger secondPage;
@property (nonatomic, strong) AFHTTPRequestOperationManager *secondManager;
@property (nonatomic, strong) NSMutableArray *secondDataArray;


@property (nonatomic, strong) AFHTTPRequestOperationManager *delateManager;

@property (nonatomic , strong) UIButton *allTaskButton;


@property (nonatomic, copy) NSString *openID;

@property (nonatomic , strong) UILabel *firstLabel;
@property (nonatomic , strong) UILabel *secondLabel;


@end

@implementation ODMyTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firstPage = 1;
    self.secondPage = 1;
    self.type = @"0";
    self.isRefresh = @"";
    self.showType = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.FirstDataArray = [NSMutableArray array];
    self.secondDataArray = [NSMutableArray array];
    
    [self navigationInit];
    [self creatSegment];
    [self creatScroller];
    
    
       
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    __weakSelf
    [[NSNotificationCenter defaultCenter]addObserverForName:ODNotificationMyTaskRefresh object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.firstCollectionView.mj_header beginRefreshing];
        [weakSelf.secondCollectionView.mj_header beginRefreshing];
    }];

    
    
    if (![self.isRefresh isEqualToString:@""]) {
        
        [self.firstCollectionView.mj_header beginRefreshing];
        [self.secondCollectionView.mj_header beginRefreshing];
        
    }
    
    
    self.showType = YES;
    [self.typeView removeFromSuperview];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isRefresh = @"";

    
}



#pragma mark - 初始化

-(void)navigationInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 180) / 2, 28, 180, 20) text:@"我的任务" font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];

    [self.headView addSubview:confirmButton];
    
    
    self.allTaskButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 100, 16,90, 44) target:self sel:@selector(typeAction:) tag:0 image:nil title:@"全部任务V" font:16];
    
    self.allTaskButton.tintColor= [UIColor blackColor];
    
    [self.headView addSubview:self.allTaskButton];
    
}


-(void)creatSegment
{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我发布的", @"我接受的"]];
    self.segmentedControl.frame = CGRectMake(4, 68, kScreenSize.width - 8, 30);
    self.segmentedControl.clipsToBounds = YES;
    self.segmentedControl.layer.cornerRadius = 7;
    self.segmentedControl.layer.borderWidth = 1;
    self.segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    
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


- (void)creatScroller
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 102, kScreenSize.width, kScreenSize.height)];
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width * 2, kScreenSize.height - 102);
    self.scrollView.backgroundColor =[UIColor whiteColor];
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
    self.firstCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width,self.scrollView.frame.size.height - 102) collectionViewLayout:self.firstFlowLayout];
    self.firstCollectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
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
    self.secondCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width,0, self.scrollView.frame.size.width,self.scrollView.frame.size.height - 102) collectionViewLayout:self.secondFlowLayout];
    self.secondCollectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
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

- (void)createTypeView
{
    
    self.typeView = [ODTypeView getView];
    self.typeView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.typeView.layer.borderWidth = 1;
    self.typeView.layer.borderColor = [UIColor blackColor].CGColor;
    self.typeView.frame = CGRectMake(kScreenSize.width - 100, 64, 100, 185);
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

#pragma mark - 点击事件
- (void)typeAction:(UIButton *)sender
{
    if (self.showType) {
        [self createTypeView];
    }else{
        [self.typeView removeFromSuperview];
    }
    
    
    
    self.showType = !self.showType;
    
}

-(void)fanhui:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteAction:(UIButton *)sender

{
    
    ODTaskCell *cell = (ODTaskCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.firstCollectionView indexPathForCell:cell];
    ODBazaarModel *model = self.FirstDataArray[indexPath.row];
    NSString *taskId = [NSString stringWithFormat:@"%@" , model.task_id];
    [self delegateTaskWith:taskId];
    
   
}

- (void)othersInformationClick:(UIButton *)sender{
    
    ODTaskCell *cell = (ODTaskCell *)sender.superview.superview;
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    
    
    if (sender.tag == 111) {
        
    NSIndexPath *indexpath = [self.firstCollectionView indexPathForCell:cell];
    ODBazaarModel *model = self.FirstDataArray[indexpath.row];
    vc.open_id = model.open_id;
    [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        NSIndexPath *indexpath = [self.secondCollectionView indexPathForCell:cell];
        ODBazaarModel *model = self.secondDataArray[indexpath.row];
        vc.open_id = model.open_id;
        [self.navigationController pushViewController:vc animated:YES];

        
    }
    
    
    
    
    
    
    
}



- (void)delegateTaskWith:(NSString *)taskId
{
    self.delateManager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"id":taskId , @"type":@"2",@"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/bbs/del";
    __weak typeof (self)weakSelf = self;
    [self.delateManager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                
                
                [weakSelf.firstCollectionView.mj_header beginRefreshing];
                [weakSelf.secondCollectionView.mj_header beginRefreshing];
                
                
            }else if ([responseObject[@"status"]isEqualToString:@"error"]) {
                
                
               [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:responseObject[@"message"]];
                
                
            }
            
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.firstCollectionView.mj_header beginRefreshing];
        [weakSelf.secondCollectionView.mj_header beginRefreshing];
        [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"网络异常"];
    }];

    
    
}


#pragma mark - 选择类型
- (void)allTaskAction
{
    self.type = @"0";
    
    [self.firstCollectionView.mj_header beginRefreshing];
    [self.secondCollectionView.mj_header beginRefreshing];
    
    [self.allTaskButton setTitle:@"全部任务V" forState:UIControlStateNormal];
    
    [self.typeView removeFromSuperview];
    self.showType = YES;

}

- (void)waitTaskAction
{
    self.type = @"1";
    
    [self.firstCollectionView.mj_header beginRefreshing];
    [self.secondCollectionView.mj_header beginRefreshing];
    
    [self.allTaskButton setTitle:@"等待派单V" forState:UIControlStateNormal];
    
    [self.typeView removeFromSuperview];
    self.showType = YES;

}

- (void)waitCompleteAction
{

    self.type = @"2";
    
      [self.firstCollectionView.mj_header beginRefreshing];
      [self.secondCollectionView.mj_header beginRefreshing];
    
      [self.allTaskButton setTitle:@"等待完成V" forState:UIControlStateNormal];
    
    [self.typeView removeFromSuperview];
    self.showType = YES;
    
}

- (void)completeTaskAction
{
    self.type = @"4";
    
    [self.firstCollectionView.mj_header beginRefreshing];
    [self.secondCollectionView.mj_header beginRefreshing];
    
    [self.allTaskButton setTitle:@"完成任务V" forState:UIControlStateNormal];
    
    [self.typeView removeFromSuperview];
    self.showType = YES;

}


- (void)overdueTaskAction
{
    self.type = @"-2";
    
    [self.firstCollectionView.mj_header beginRefreshing];
    [self.secondCollectionView.mj_header beginRefreshing];
    
    [self.allTaskButton setTitle:@"过期任务V" forState:UIControlStateNormal];
    
    [self.typeView removeFromSuperview];
    self.showType = YES;

}

- (void)violationsTaskAction
{
    self.type = @"-1";
    
    [self.firstCollectionView.mj_header beginRefreshing];
    [self.secondCollectionView.mj_header beginRefreshing];
    
    [self.allTaskButton setTitle:@"违规任务V" forState:UIControlStateNormal];
    
    [self.typeView removeFromSuperview];
    self.showType = YES;

}



#pragma mark - 刷新
- (void)firstDownRefresh
{
    
    self.firstPage = 1;
    [self firstGetData];
    
    
}


- (void)firstLoadMoreData
{
    self.firstPage++;
    [self firstGetData];
    
}

- (void)secondDownRefresh
{
    
    self.secondPage = 1;
    [self secondGetData];
    
    
}


- (void)secondLoadMoreData
{
    self.secondPage++;
    [self secondGetData];
    
}


#pragma mark - 请求数据
-(void)firstGetData
{
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.firstPage];
    
    
    self.firstManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{ @"city_id":@"321" , @"suggest":@"0", @"task_status":self.type, @"page":countNumber, @"my":@"1" , @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/task/list";
    __weak typeof (self)weakSelf = self;
    [self.firstManager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
        if (responseObject) {
            
            if ([countNumber isEqualToString:@"1"]) {
                [weakSelf.FirstDataArray removeAllObjects];
                
                [weakSelf.firstLabel removeFromSuperview];
    
            }
   
            NSDictionary *result = responseObject[@"result"];
            NSArray *tasks = result[@"tasks"];
            
            
            for (NSDictionary *itemDict in tasks) {
                ODBazaarModel *model = [[ODBazaarModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.FirstDataArray addObject:model];
            }

            if (weakSelf.FirstDataArray.count == 0) {
                weakSelf.firstLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(self.scrollView.center.x - 40, self.scrollView.center.y / 2, 80, 30) text:@"暂无任务" font:16 alignment:@"center" color:@"#000000" alpha:1];
                [weakSelf.scrollView addSubview:self.firstLabel];
            }
            [weakSelf.firstCollectionView reloadData];
            [weakSelf.firstCollectionView.mj_header endRefreshing];
            [weakSelf.firstCollectionView.mj_footer endRefreshing];
            
            if (tasks.count == 0) {
                [weakSelf.firstCollectionView.mj_footer noticeNoMoreData];
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [weakSelf.firstCollectionView.mj_header endRefreshing];
        [weakSelf.firstCollectionView.mj_footer endRefreshing];
        [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"网络异常"];
    }];
}

-(void)secondGetData
{
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.secondPage];
        
    self.secondManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"city_id":@"321" ,@"suggest":@"0", @"task_status":self.type, @"page":countNumber, @"my":@"2" , @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/task/list";
    __weak typeof (self)weakSelf = self;
    [self.secondManager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (responseObject) {
            
            if ([countNumber isEqualToString:@"1"]) {
                [weakSelf.secondDataArray removeAllObjects];
                [weakSelf.secondLabel removeFromSuperview];
                
            }
     
            NSDictionary *result = responseObject[@"result"];
            NSArray *tasks = result[@"tasks"];
            
            
            for (NSDictionary *itemDict in tasks) {
                
                NSString *task_status = [NSString stringWithFormat:@"%@" ,  itemDict[@"task_status"]];
                
                
                if (![task_status isEqualToString:@"-1"]) {
                    ODBazaarModel *model = [[ODBazaarModel alloc]init];
                    [model setValuesForKeysWithDictionary:itemDict];
                    [weakSelf.secondDataArray addObject:model];
                }

            }
            
            if (weakSelf.secondDataArray.count == 0) {
                weakSelf.secondLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(weakSelf.scrollView.center.x - 40 + weakSelf.scrollView.frame.size.width, weakSelf.scrollView.center.y / 2, 80, 30) text:@"暂无任务" font:16 alignment:@"center" color:@"#000000" alpha:1];
                [weakSelf.scrollView addSubview:self.secondLabel];
            }
            
            [weakSelf.secondCollectionView.mj_header endRefreshing];
            [weakSelf.secondCollectionView.mj_footer endRefreshing];
            [weakSelf.secondCollectionView reloadData];
            
            if (tasks.count == 0) {
                [weakSelf.secondCollectionView.mj_footer noticeNoMoreData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [weakSelf.secondCollectionView.mj_header endRefreshing];
        [weakSelf.secondCollectionView.mj_footer endRefreshing];
        [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"网络异常"];
    }];
    
      
}


#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 111) {
        
        ODBazaarModel *model = self.FirstDataArray[indexPath.row];
        NSString *status = [NSString stringWithFormat:@"%@" , model.task_status];
        
        if ([status isEqualToString:@"-1"]) {
            ODViolationsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
            
            cell.model = model;
            [cell.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;


        }else{
            
            ODTaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            
            cell.model = model;
            [cell.userImageViewButton addTarget:self action:@selector(othersInformationClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.userImageViewButton.tag = 111;

            
            return cell;

        }
        
    }else {
        
        ODBazaarModel *model = self.secondDataArray[indexPath.row];
     
        ODTaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        
        cell.model = model;
        [cell.userImageViewButton addTarget:self action:@selector(othersInformationClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.userImageViewButton.tag = 222;

        
        return cell;
        
        
    }
    


}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 111) {
        return self.FirstDataArray.count;
    }
    else {
        return self.secondDataArray.count;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 111) {
        
         ODBazaarModel *model = self.FirstDataArray[indexPath.row];
        NSString *status = [NSString stringWithFormat:@"%@" , model.task_status];
        if ([status isEqualToString:@"-1"]) {
            ;
        }else{
            ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc]init];
            bazaarDetail.myBlock = ^(NSString *del){
                
            self.isRefresh = del;
                
                
            };
            
            bazaarDetail.task_id = [NSString stringWithFormat:@"%@",model.task_id];
            bazaarDetail.open_id = [NSString stringWithFormat:@"%@",model.open_id];
            bazaarDetail.task_status_name = [NSString stringWithFormat:@"%@",model.task_status_name];
            [self.navigationController pushViewController:bazaarDetail animated:YES];
        }
        
        
      
    }else if (collectionView.tag == 222) {
        
         ODBazaarModel *model = self.secondDataArray[indexPath.row];
          NSString *status = [NSString stringWithFormat:@"%@" , model.task_status];
        
        if ([status isEqualToString:@"-1"]) {
            ;
        }else{
            ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc]init];
            
            bazaarDetail.myBlock = ^(NSString *del){
                
                self.isRefresh = del;
                
                
            };

            
            
            bazaarDetail.task_id = [NSString stringWithFormat:@"%@",model.task_id];
            bazaarDetail.open_id = [NSString stringWithFormat:@"%@",model.open_id];
            bazaarDetail.task_status_name = [NSString stringWithFormat:@"%@",model.task_status_name];
            [self.navigationController pushViewController:bazaarDetail animated:YES];

        }
      
    }
    
    
}




//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width , 140);
    
}
//动态设置每个分区的缩进量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//动态返回不同区的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
    
}
//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.scrollView])
        return;
    
    int page = scrollView.contentOffset.x / self.view.frame.size.width;
  
    
    self.showType = YES;
    [self.typeView removeFromSuperview];
    
    self.segmentedControl.selectedSegmentIndex  = page;
    
    
}


#pragma mark - UISegmentDelegate
- (void)segmentAction:(UISegmentedControl *)sender
{
    self.showType = YES;
    [self.typeView removeFromSuperview];

    
    CGPoint point = CGPointMake(self.scrollView.frame.size.width * sender.selectedSegmentIndex, 0);
    [self.scrollView setContentOffset:point animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
