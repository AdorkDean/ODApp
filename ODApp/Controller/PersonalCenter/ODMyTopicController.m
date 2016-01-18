//
//  ODMyTopicController.m
//  ODApp
//
//  Created by zhz on 16/1/11.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODMyTopicController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "UIImageView+WebCache.h"
#import "ODCommunityCollectionCell.h"
#import "ODCommunityModel.h"
#import "ODCommunityDetailViewController.h"

@interface ODMyTopicController ()<UIScrollViewDelegate,UICollectionViewDataSource , UICollectionViewDelegate>

@property(nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView * scrollView;



@property (nonatomic , strong) UICollectionViewFlowLayout *firstFlowLayout;
@property (nonatomic , strong) UICollectionView *firstCollectionView;
@property (nonatomic , assign) NSInteger firstPage;
@property (nonatomic, strong) AFHTTPRequestOperationManager *firstManager;
@property (nonatomic, strong) NSMutableArray *FirstDataArray;
@property (nonatomic, strong) NSMutableArray *firstUserArray;
@property (nonatomic , copy) NSString *type;

@property (nonatomic , strong) UICollectionViewFlowLayout *secondFlowLayout;
@property (nonatomic , strong) UICollectionView *secondCollectionView;
@property (nonatomic , assign) NSInteger secondPage;
@property (nonatomic, strong) AFHTTPRequestOperationManager *secondManager;
@property (nonatomic, strong) NSMutableArray *secondDataArray;
@property (nonatomic, strong) NSMutableArray *secondUserArray;


@property (nonatomic, copy) NSString *openID;


@end

@implementation ODMyTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.firstPage = 1;
    self.secondPage = 1;
    
    
    self.FirstDataArray = [NSMutableArray array];
    self.firstUserArray = [NSMutableArray array];
    self.secondDataArray = [NSMutableArray array];
    self.secondUserArray = [NSMutableArray array];
    
        
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self navigationInit];
    [self creatSegment];
    [self creatScroller];
    
    
    self.openID = [ODUserInformation getData].openID;
    
    
}

#pragma mark - lifeCycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.refresh isEqualToString:@"refresh"]) {
        [self.firstCollectionView.mj_header beginRefreshing];
        [self.secondCollectionView.mj_header beginRefreshing];
    }
    
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
    
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80) / 2, 28, 80, 20) text:@"我的话题" font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    
    
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(-10, 28,90, 20) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:17];
    [confirmButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:confirmButton];
    
    
    
}


-(void)creatSegment
{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我发表的", @"我回复的"]];
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
    [self.firstCollectionView registerNib:[UINib nibWithNibName:@"ODCommunityCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    
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
    [self.secondCollectionView registerNib:[UINib nibWithNibName:@"ODCommunityCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    
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



-(void)fanhui:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSDictionary *parameters = @{@"type":@"1",@"page":countNumber , @"open_id":self.openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.odong.com/1.0/bbs/list";
    
    [self.firstManager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([countNumber isEqualToString:@"1"]) {
            [self.FirstDataArray removeAllObjects];
            [self.firstUserArray removeAllObjects];
        }
        
        
        
        if (responseObject) {
            
            
            
            NSMutableDictionary *result = responseObject[@"result"];
            NSMutableDictionary *bbs_list = result[@"bbs_list"];
            
            NSArray *allkeys = [bbs_list allKeys];
            allkeys = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSComparisonResult result = [obj1 compare:obj2];
                return result == NSOrderedAscending;
            }];
            
            
            for (id bbsKey in allkeys) {
                NSString *key = [NSString stringWithFormat:@"%@",bbsKey];
                NSMutableDictionary *itemDict = bbs_list[key];
                ODCommunityModel *model = [[ODCommunityModel alloc] init];
                
                [model setValuesForKeysWithDictionary:itemDict];
                
                
                
                
                [self.FirstDataArray addObject:model];
            }
            
            NSMutableDictionary *users = result[@"users"];
            for (id userKey in users) {
                NSString *key = [NSString stringWithFormat:@"%@",userKey];
                NSMutableDictionary *itemDict = users[key];
                ODCommunityModel *model = [[ODCommunityModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];
                
                
                
                
                [self.firstUserArray addObject:model];
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
    
    NSDictionary *parameters = @{@"type":@"2",@"page":countNumber , @"open_id":self.openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.odong.com/1.0/bbs/list";
    
    [self.secondManager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if (responseObject) {
            
            if ([countNumber isEqualToString:@"1"]) {
                [self.secondDataArray removeAllObjects];
                [self.secondUserArray removeAllObjects];
            }
            
            
            
            NSMutableDictionary *result = responseObject[@"result"];
            NSMutableDictionary *bbs_list = result[@"bbs_list"];
            
            
            
            NSArray *allkeys = [bbs_list allKeys];
            allkeys = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSComparisonResult result = [obj1 compare:obj2];
                return result == NSOrderedDescending;
            }];
            
            
            
            for (id bbsKey in allkeys) {
                NSString *key = [NSString stringWithFormat:@"%@",bbsKey];
                NSMutableDictionary *itemDict = bbs_list[key];
                ODCommunityModel *model = [[ODCommunityModel alloc] init];
                
                [model setValuesForKeysWithDictionary:itemDict];
                
                
                [self.secondDataArray addObject:model];
            }
            
            NSMutableDictionary *users = result[@"users"];
            for (id userKey in users) {
                NSString *key = [NSString stringWithFormat:@"%@",userKey];
                NSMutableDictionary *itemDict = users[key];
                ODCommunityModel *model = [[ODCommunityModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];
                
                
                
                
                [self.secondUserArray addObject:model];
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
    
    
    
    ODCommunityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    
    cell.backgroundColor = [UIColor whiteColor];
    
    
    if (collectionView.tag == 111) {
        ODCommunityModel *userModel = self.firstUserArray[0];
        ODCommunityModel *detailModel = self.FirstDataArray[indexPath.row];
        cell.nameLabel.text = userModel.nick;
        [cell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:userModel.avatar_url] forState:UIControlStateNormal];
        cell.titleLabel.text = detailModel.title;
        cell.contentLabel.text = detailModel.content;
        NSString *count = [NSString stringWithFormat:@"%@" , detailModel.view_num];
        cell.countLabel.text = [NSString stringWithFormat:@"浏览次数:%@" , count];

        
        
    }else if (collectionView.tag == 222) {
        
        ODCommunityModel *userModel = self.secondUserArray[0];
        ODCommunityModel *detailModel = self.secondDataArray[indexPath.row];
        cell.nameLabel.text = userModel.nick;
        [cell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:userModel.avatar_url] forState:UIControlStateNormal];
        cell.titleLabel.text = detailModel.title;
        cell.contentLabel.text = detailModel.content;
        NSString *count = [NSString stringWithFormat:@"%@" , detailModel.view_num];
        cell.countLabel.text = [NSString stringWithFormat:@"浏览次数:%@" , count];

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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
      ODCommunityDetailViewController *detailController = [[ODCommunityDetailViewController alloc]init];
    
    
    detailController.myBlock = ^(NSString *refresh){
        self.refresh = refresh;
    };

    
    
    if (collectionView.tag == 111) {
      
        
        ODCommunityModel *model = self.FirstDataArray[indexPath.row];
        detailController.bbs_id = [NSString stringWithFormat:@"%@",model.id];
        [self.navigationController pushViewController:detailController animated:YES];

    }else if (collectionView.tag == 222) {
       
        ODCommunityModel *model = self.secondDataArray[indexPath.row];
        detailController.bbs_id = [NSString stringWithFormat:@"%@",model.id];
        [self.navigationController pushViewController:detailController animated:YES];
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



@end
