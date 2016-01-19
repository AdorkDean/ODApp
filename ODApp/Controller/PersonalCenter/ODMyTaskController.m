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

@property (nonatomic , strong) UIButton *allTaskButton;


@property (nonatomic, copy) NSString *openID;


@end

@implementation ODMyTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.firstPage = 1;
    self.secondPage = 1;
    
    
    self.FirstDataArray = [NSMutableArray array];
    self.secondDataArray = [NSMutableArray array];
    
    
    self.type = @"0";
    
    
  
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.showType = YES;
    
    
    [self navigationInit];
    [self creatSegment];
    [self creatScroller];
    
    
       
}

#pragma mark - lifeCycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
    
    
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
    [confirmButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
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
    self.segmentedControl.layer.borderColor = [ODColorConversion colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    
    self.segmentedControl.tintColor = [ODColorConversion colorWithHexString:@"#ffd801" alpha:1];
    
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
    self.firstCollectionView.backgroundColor = [ODColorConversion colorWithHexString:@"#d9d9d9" alpha:1];
    self.firstCollectionView.dataSource = self;
    self.firstCollectionView.delegate = self;
    [self.firstCollectionView registerNib:[UINib nibWithNibName:@"ODTaskCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    
    self.firstCollectionView.tag = 111;
    
    
    
    
    self.firstCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self firstDownRefresh];
    }];
    
    
    self.firstCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self firstLoadMoreData];
    }];
    
    
    
    [self.firstCollectionView.mj_header beginRefreshing];
    
    [self.scrollView addSubview:self.firstCollectionView];
    
    
    
    self.secondFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.secondCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width,0, self.scrollView.frame.size.width,self.scrollView.frame.size.height - 102) collectionViewLayout:self.secondFlowLayout];
    self.secondCollectionView.backgroundColor = [ODColorConversion colorWithHexString:@"#d9d9d9" alpha:1];
    self.secondCollectionView.dataSource = self;
    self.secondCollectionView.delegate = self;
    [self.secondCollectionView registerNib:[UINib nibWithNibName:@"ODTaskCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    
    self.secondCollectionView.tag = 222;
    
    self.secondCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self secondDownRefresh];
    }];
    
    
    self.secondCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self secondLoadMoreData];
    }];
    
    
    
    [self.secondCollectionView.mj_header beginRefreshing];
    
    
    [self.scrollView addSubview:self.secondCollectionView];
    
    
    
    
}

- (void)createTypeView
{
    
    self.typeView = [ODTypeView getView];
    self.typeView.backgroundColor = [ODColorConversion colorWithHexString:@"#d9d9d9" alpha:1];
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
    
    NSDictionary *parameters = @{@"suggest":@"0", @"task_status":self.type, @"page":countNumber, @"my":@"1" , @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.odong.com/1.0/task/list";
    
    [self.firstManager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([countNumber isEqualToString:@"1"]) {
            [self.FirstDataArray removeAllObjects];
            
        }
        
        
        
        if (responseObject) {
            
            
            NSDictionary *result = responseObject[@"result"];
            NSArray *tasks = result[@"tasks"];
            
            
            for (NSDictionary *itemDict in tasks) {
                ODBazaarModel *model = [[ODBazaarModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [self.FirstDataArray addObject:model];
            }
            
            
            
        }
        
        
        [self.firstCollectionView.mj_header endRefreshing];
        [self.firstCollectionView.mj_footer endRefreshing];
        [self.firstCollectionView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    

    
    
    
}

-(void)secondGetData
{
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.secondPage];
    
    
    self.secondManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"suggest":@"0", @"task_status":self.type, @"page":countNumber, @"my":@"2" , @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.odong.com/1.0/task/list";
    
    [self.secondManager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([countNumber isEqualToString:@"1"]) {
            [self.secondDataArray removeAllObjects];
            
        }
        
        
        
        if (responseObject) {
            
            
            NSDictionary *result = responseObject[@"result"];
            NSArray *tasks = result[@"tasks"];
            
            
            for (NSDictionary *itemDict in tasks) {
                ODBazaarModel *model = [[ODBazaarModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [self.secondDataArray addObject:model];
            }
            
            
            
        }
        
        
        [self.secondCollectionView.mj_header endRefreshing];
        [self.secondCollectionView.mj_footer endRefreshing];
        [self.secondCollectionView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    
    
    
    
    
}


#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    ODTaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    cell.userImageView.layer.masksToBounds = YES;
    cell.userImageView.layer.cornerRadius = 30;
    cell.userImageView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.userImageView.layer.borderWidth = 1;

    
    
    if (collectionView.tag == 111) {
        ODBazaarModel *model = self.FirstDataArray[indexPath.row];
        
        
        
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        
        cell.nickLabel.text = model.user_nick;
        cell.titleLabel.text = model.title;
        cell.contentLabel.text = model.content;
        
        
        NSString *status = [NSString stringWithFormat:@"%@" , model.task_status];
        
        if ([status isEqualToString:@"1"]) {
            cell.typeLabel.text = @"等待派单";
             cell.typeLabel.textColor = [UIColor redColor];
            
        }else if ([status isEqualToString:@"2"]) {
            
            cell.typeLabel.text = @"进行中";
        }else if ([status isEqualToString:@"3"]) {
            
            cell.typeLabel.text = @"交付";
        }else if ([status isEqualToString:@"4"]) {
            
            cell.typeLabel.text = @"确认完成";
        }else if ([status isEqualToString:@"-1"]) {
            
            cell.typeLabel.text = @"违规";
        }else if ([status isEqualToString:@"-2"]) {
            
            cell.typeLabel.text = @"过期任务";
            cell.typeLabel.textColor = [UIColor lightGrayColor];
        }else if ([status isEqualToString:@"0"]) {
            
            cell.typeLabel.text = @"无效";
        }
        
               
        //设置Label显示不同大小的字体
        NSString *time = [[[model.task_start_date substringFromIndex:5] stringByReplacingOccurrencesOfString:@"/" withString:@"."] stringByReplacingOccurrencesOfString:@" " withString:@"."];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:time];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 5)];
        cell.timeLabel.attributedText = noteStr;
        

    }else if (collectionView.tag == 222) {
        ODBazaarModel *model = self.secondDataArray[indexPath.row];
        
        
        
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        
        cell.nickLabel.text = model.user_nick;
        cell.titleLabel.text = model.title;
        cell.contentLabel.text = model.content;
        
        
        NSString *status = [NSString stringWithFormat:@"%@" , model.task_status];
        
        if ([status isEqualToString:@"1"]) {
            cell.typeLabel.text = @"等待派单";
             cell.typeLabel.textColor = [UIColor redColor];
            
        }else if ([status isEqualToString:@"2"]) {
            
            cell.typeLabel.text = @"进行中";
        }else if ([status isEqualToString:@"3"]) {
            
            cell.typeLabel.text = @"交付";
        }else if ([status isEqualToString:@"4"]) {
            
            cell.typeLabel.text = @"确认完成";
        }else if ([status isEqualToString:@"-1"]) {
            
            cell.typeLabel.text = @"违规";
        }else if ([status isEqualToString:@"-2"]) {
            
            cell.typeLabel.text = @"过期任务";
            cell.typeLabel.textColor = [UIColor lightGrayColor];
        }else if ([status isEqualToString:@"0"]) {
            
            cell.typeLabel.text = @"无效";
        }
        
        
        //设置Label显示不同大小的字体
        NSString *time = [[[model.task_start_date substringFromIndex:5] stringByReplacingOccurrencesOfString:@"/" withString:@"."] stringByReplacingOccurrencesOfString:@" " withString:@"."];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:time];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 5)];
        cell.timeLabel.attributedText = noteStr;

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
    }
    else {
        return self.secondDataArray.count;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 111) {
        ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc]init];
        ODBazaarModel *model = self.FirstDataArray[indexPath.row];
        bazaarDetail.task_id = [NSString stringWithFormat:@"%@",model.task_id];
        bazaarDetail.task_status = [NSString stringWithFormat:@"%@",model.task_status];
        [self.navigationController pushViewController:bazaarDetail animated:YES];
    }else if (collectionView.tag == 222) {
        ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc]init];
        ODBazaarModel *model = self.secondDataArray[indexPath.row];
        bazaarDetail.task_id = [NSString stringWithFormat:@"%@",model.task_id];
        bazaarDetail.task_status = [NSString stringWithFormat:@"%@",model.task_status];
        [self.navigationController pushViewController:bazaarDetail animated:YES];

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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
