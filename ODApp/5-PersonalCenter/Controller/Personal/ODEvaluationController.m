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
#import "ODCommunityCollectionCell.h"
#import "ODCommunityBbsModel.h"
#import "ODCommunityDetailViewController.h"
#import "ODOthersInformationController.h"
#import "ODEvaluationCell.h"
#import "ODSecondEvaluationModel.h"
@interface ODEvaluationController ()<UIScrollViewDelegate,UICollectionViewDataSource , UICollectionViewDelegate>

@property (nonatomic , strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic , strong) UICollectionViewFlowLayout *firstFlowLayout;
@property (nonatomic , strong) UICollectionView *firstCollectionView;
@property (nonatomic , assign) NSInteger firstPage;
@property (nonatomic, strong) NSMutableArray *FirstDataArray;
@property (nonatomic , strong) UILabel *firstLabel;

@property (nonatomic , strong) UICollectionViewFlowLayout *secondFlowLayout;
@property (nonatomic , strong) UICollectionView *secondCollectionView;
@property (nonatomic , assign) NSInteger secondPage;
@property (nonatomic, strong) NSMutableArray *secondDataArray;
@property (nonatomic , strong) UILabel *secondLabel;



@end

@implementation ODEvaluationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.title = @"我收到的评价";
    
    self.firstPage = 1;
    self.secondPage = 1;
    
    self.FirstDataArray = [NSMutableArray array];
    self.secondDataArray = [NSMutableArray array];
  
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.typeTitle;
    
    [self creatSegment];
    [self creatScroller];
    [self createCollectionView];

    
}

#pragma mark - 初始化
-(void)creatSegment
{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"任务评价", @"技能评价"]];
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


- (void)creatScroller
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenSize.width, kScreenSize.height - 40)];
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width * 2, kScreenSize.height - 40);
    self.scrollView.backgroundColor =[UIColor whiteColor];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    
}

- (void)createCollectionView
{
    __weakSelf
    
    // 我发表的collectionView
    self.firstFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.firstFlowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.firstCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, self.scrollView.frame.size.width,self.scrollView.frame.size.height - 74) collectionViewLayout:self.firstFlowLayout];
    self.firstCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    self.firstCollectionView.dataSource = self;
    self.firstCollectionView.delegate = self;
    self.firstCollectionView.tag = 111;
    [self.firstCollectionView registerClass:[ODEvaluationCell class] forCellWithReuseIdentifier:@"item"];
    self.firstCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf firstDownRefresh];
    }];
    self.firstCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf firstLoadMoreData];
    }];
    
    [self.firstCollectionView.mj_header beginRefreshing];
    [self.scrollView addSubview:self.firstCollectionView];
    
    // 我回复的collectionView
    self.secondFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.secondFlowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.secondCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width,10, self.scrollView.frame.size.width,self.scrollView.frame.size.height - 74) collectionViewLayout:self.secondFlowLayout];
    self.secondCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    self.secondCollectionView.dataSource = self;
    self.secondCollectionView.delegate = self;
    self.secondCollectionView.tag = 222;
    [self.secondCollectionView registerClass:[ODEvaluationCell class] forCellWithReuseIdentifier:@"item"];
    self.secondCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf secondDownRefresh];
    }];
    self.secondCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf secondLoadMoreData];
    }];
    
    [self.secondCollectionView.mj_header beginRefreshing];
    [self.scrollView addSubview:self.secondCollectionView];
    
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
    
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"1";
    params[@"page"] = countNumber;
    params[@"open_id"] = self.openId;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlUserCommentList parameters:params modelClass:[ODEvaluationModel class] success:^(id model)
     {
         if ([countNumber isEqualToString:@"1"]) {
             [weakSelf.FirstDataArray removeAllObjects];
             [weakSelf.firstLabel removeFromSuperview];
         }
         
         NSArray *evaluationDatas = [model result];
         [weakSelf.FirstDataArray addObjectsFromArray:evaluationDatas];

         if (weakSelf.FirstDataArray.count == 0)
         {
             weakSelf.firstLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80)/2, kScreenSize.height/2, 80, 30) text:@"暂无评价" font:16 alignment:@"center" color:@"#000000" alpha:1];
             [weakSelf.scrollView addSubview:weakSelf.firstLabel];
         }

         [weakSelf.firstCollectionView.mj_header endRefreshing];

         if (evaluationDatas.count == 0) {
             [weakSelf.firstCollectionView.mj_footer endRefreshingWithNoMoreData];
         }
         else
         {
             [weakSelf.firstCollectionView.mj_footer endRefreshing];
         }
         
         [weakSelf.firstCollectionView reloadData];
  
     } failure:^(NSError *error) {
         [weakSelf.firstCollectionView.mj_header endRefreshing];
         [weakSelf.firstCollectionView.mj_footer endRefreshing];
     }];
}

-(void)secondGetData
{
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.secondPage];
    
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"3";
    params[@"page"] = countNumber;
    params[@"open_id"] = self.openId;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlUserCommentList parameters:params modelClass:[ODSecondEvaluationModel class] success:^(id model)
     {
         if ([countNumber isEqualToString:@"1"]) {
             [weakSelf.secondDataArray removeAllObjects];
             [weakSelf.secondLabel removeFromSuperview];
         }
         
         NSArray *evaluationDatas = [model result];
         [weakSelf.secondDataArray addObjectsFromArray:evaluationDatas];
         
         if (weakSelf.secondDataArray.count == 0)
         {
             weakSelf.secondLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 160)/2 + KScreenWidth, kScreenSize.height/2, 160, 30) text:@"暂无评价" font:16 alignment:@"center" color:@"#000000" alpha:1];
             [weakSelf.scrollView addSubview:weakSelf.secondLabel];
         }

         [weakSelf.secondCollectionView.mj_header endRefreshing];

         if (evaluationDatas.count == 0) {
             [weakSelf.secondCollectionView.mj_footer endRefreshingWithNoMoreData];
         }
         else
         {
             [weakSelf.secondCollectionView.mj_footer endRefreshing];
         }
         
         [weakSelf.secondCollectionView reloadData];
 
     } failure:^(NSError *error) {
         [weakSelf.firstCollectionView.mj_header endRefreshing];
         [weakSelf.firstCollectionView.mj_footer endRefreshing];
     }];
}



#pragma mark - UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   

    ODEvaluationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    cell.layer.borderWidth = 0.5;
    
    if (collectionView.tag == 111) {
        
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.model = self.FirstDataArray[indexPath.row];
        
    }else{
        
        cell.backgroundColor = [UIColor whiteColor];
        
        
        ODSecondEvaluationModel *model = self.secondDataArray[indexPath.row];
        
        
        
        [cell dealWithModel:model];
        
        
        


        
        
    }
    


    
    
    
    return cell;
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 111) {
        
        
        return self.FirstDataArray.count;
    }else{
        
        
          return self.secondDataArray.count;
        
    }
}


//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (collectionView.tag == 111) {
        
        
           return CGSizeMake(kScreenSize.width , [ODEvaluationCell returnHight:self.FirstDataArray[indexPath.row]]);
    }else{
        
        return CGSizeMake(kScreenSize.width , [ODEvaluationCell returnSecondHight:self.secondDataArray[indexPath.row]]);

        
        
    }
 
    
    
    
}
//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}



@end