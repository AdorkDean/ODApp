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
#import "ODOthersInformationController.h"
@interface ODMyTopicController ()<UIScrollViewDelegate,UICollectionViewDataSource , UICollectionViewDelegate>

@property (nonatomic , strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic , strong) UICollectionViewFlowLayout *firstFlowLayout;
@property (nonatomic , strong) UICollectionView *firstCollectionView;
@property (nonatomic , assign) NSInteger firstPage;
@property (nonatomic, strong) AFHTTPRequestOperationManager *firstManager;
@property (nonatomic, strong) NSMutableArray *FirstDataArray;
@property (nonatomic , strong) NSMutableDictionary *firstUserInfoDic;
@property (nonatomic , strong) UILabel *firstLabel;

@property (nonatomic , strong) UICollectionViewFlowLayout *secondFlowLayout;
@property (nonatomic , strong) UICollectionView *secondCollectionView;
@property (nonatomic , assign) NSInteger secondPage;
@property (nonatomic, strong) AFHTTPRequestOperationManager *secondManager;
@property (nonatomic, strong) NSMutableArray *secondDataArray;
@property (nonatomic , strong) NSMutableDictionary *secondUserInfoDic;
@property (nonatomic , strong) UILabel *secondLabel;

@property (nonatomic , copy) NSString *type;
@property (nonatomic, copy) NSString *openID;

@property (nonatomic , assign) NSInteger firstIndex;
@property (nonatomic , assign) NSInteger secondIndex;

@end

@implementation ODMyTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firstPage = 1;
    self.secondPage = 1;
    
    self.FirstDataArray = [NSMutableArray array];
    self.secondDataArray = [NSMutableArray array];
    self.firstUserInfoDic = [[NSMutableDictionary alloc] init];
    self.secondUserInfoDic = [[NSMutableDictionary alloc] init];
    
    
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的话题";
    
    [self creatSegment];
    [self creatScroller];
    [self createCollectionView];
}

#pragma mark - lifeCycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyAction:) name:ODNotificationReplySuccess object:nil];

    
    
    if ([self.isFirstRefresh isEqualToString:@"refresh"]){
        [self.FirstDataArray removeObjectAtIndex:self.firstIndex];
        [self.firstCollectionView reloadData];
    }
    
    if ([self.isSecondRefresh isEqualToString:@"refresh"]){
        [self.secondDataArray removeObjectAtIndex:self.secondIndex];
        [self.secondCollectionView reloadData];
    }
    

    
    
    
    
}


//- (void)replyAction:(NSNotification *)text
//{
//    
//    [self.firstCollectionView.mj_header beginRefreshing];
//    [self.secondCollectionView.mj_header beginRefreshing];
//    
//}



#pragma mark - 初始化
-(void)creatSegment
{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我发表的", @"我回复的"]];
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
    self.firstCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, self.scrollView.frame.size.width,self.scrollView.frame.size.height - 74) collectionViewLayout:self.firstFlowLayout];
    self.firstCollectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.firstCollectionView.dataSource = self;
    self.firstCollectionView.delegate = self;
    self.firstCollectionView.tag = 111;
    [self.firstCollectionView registerNib:[UINib nibWithNibName:@"ODCommunityCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
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
    self.secondCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width,10, self.scrollView.frame.size.width,self.scrollView.frame.size.height - 74) collectionViewLayout:self.secondFlowLayout];
    self.secondCollectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.secondCollectionView.dataSource = self;
    self.secondCollectionView.delegate = self;
    self.secondCollectionView.tag = 222;
    [self.secondCollectionView registerNib:[UINib nibWithNibName:@"ODCommunityCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
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
    
    
    self.firstManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{ @"type":@"1",@"page":countNumber , @"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID] ,@"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    __weak typeof (self)weakSelf = self;
    [self.firstManager GET:kCommunityBbsLatestUrl parameters:signParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        if ([countNumber isEqualToString:@"1"]) {
            [weakSelf.FirstDataArray removeAllObjects];
            [weakSelf.firstLabel removeFromSuperview];
            [weakSelf.firstUserInfoDic removeAllObjects];
        }
        
        if (responseObject) {
            NSDictionary *result = responseObject[@"result"];
            NSDictionary *bbs_list = result[@"bbs_list"];
            
            
                     
            if (bbs_list.count != 0) {
                NSArray *allkeys = [bbs_list allKeys];
                allkeys = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    NSComparisonResult result = [obj1 compare:obj2];
                    return result == NSOrderedAscending;
                }];
                
                
                for (id bbsKey in allkeys) {
                    NSString *key = [NSString stringWithFormat:@"%@",bbsKey];
                    NSDictionary *itemDict = bbs_list[key];
                    ODCommunityModel *model = [[ODCommunityModel alloc]init];
                    [model setValuesForKeysWithDictionary:itemDict];
                    [weakSelf.FirstDataArray addObject:model];
                }

            }
            
            
            NSDictionary *users = result[@"users"];
            for (id userKey in users) {
                NSString *key = [NSString stringWithFormat:@"%@",userKey];
                NSDictionary *itemDict = users[key];
                ODCommunityModel *model = [[ODCommunityModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.firstUserInfoDic setObject:model forKey:userKey];
            }
            if (weakSelf.FirstDataArray.count == 0) {
                weakSelf.firstLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(weakSelf.scrollView.center.x - 40, weakSelf.scrollView.center.y / 2, 80, 30) text:@"暂无话题" font:16 alignment:@"center" color:@"#000000" alpha:1];
                [weakSelf.scrollView addSubview:weakSelf.firstLabel];
            }

            [weakSelf.firstCollectionView reloadData];
            [weakSelf.firstCollectionView.mj_header endRefreshing];
            [weakSelf.firstCollectionView.mj_footer endRefreshing];
            
            if (bbs_list.count == 0) {
                [weakSelf.firstCollectionView.mj_footer noticeNoMoreData];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [weakSelf.firstCollectionView.mj_header endRefreshing];
        [weakSelf.firstCollectionView.mj_footer endRefreshing];
        [ODProgressHUD showInfoWithStatus:@"网络异常"];
    }];
    
}

-(void)secondGetData
{
    
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.secondPage];
    
    
    
    self.secondManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{ @"type":@"2",@"page":countNumber, @"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID] , @"open_id":self.open_id  , @"call_array":@"1"};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
      
    __weak typeof (self)weakSelf = self;
    [self.secondManager GET:kCommunityBbsLatestUrl parameters:signParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        if ([countNumber isEqualToString:@"1"]) {
            [weakSelf.secondDataArray removeAllObjects];
            [weakSelf.secondLabel removeFromSuperview];
            [weakSelf.secondUserInfoDic removeAllObjects];
        }
        
        
        if (responseObject)
        {
            NSDictionary *result = responseObject[@"result"];
            NSDictionary *bbs_list = result[@"bbs_list"];
            NSDictionary *users = result[@"users"];
            for (NSMutableDictionary *dic in bbs_list)
            {
                ODCommunityModel *model = [[ODCommunityModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.secondDataArray addObject:model];
            }
            for (id userKey in users)
            {
                NSString *key = [NSString stringWithFormat:@"%@",userKey];
                NSDictionary *itemDict = users[key];
                ODCommunityModel *model = [[ODCommunityModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.secondUserInfoDic setObject:model forKey:userKey];
            }
            
            
            if (weakSelf.secondDataArray.count == 0) {
                weakSelf.secondLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(weakSelf.scrollView.center.x - 40 + weakSelf.scrollView.frame.size.width, weakSelf.scrollView.center.y / 2, 80, 30) text:@"暂无话题" font:16 alignment:@"center" color:@"#000000" alpha:1];
                [weakSelf.scrollView addSubview:weakSelf.secondLabel];
            }
 
            [weakSelf.secondCollectionView reloadData];
            [weakSelf.secondCollectionView.mj_header endRefreshing];
            [weakSelf.secondCollectionView.mj_footer endRefreshing];
            
            if (bbs_list.count == 0) {
                [weakSelf.secondCollectionView.mj_footer noticeNoMoreData];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [weakSelf.secondCollectionView.mj_header endRefreshing];
        [weakSelf.secondCollectionView.mj_footer endRefreshing];
        [ODProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

#pragma mark - 点击事件
-(void)firstImageButtonClick:(UIButton *)button
{
    ODCommunityCollectionCell *cell = (ODCommunityCollectionCell *)button.superview.superview.superview;
    NSIndexPath *indexPath = [self.firstCollectionView indexPathForCell:cell];
    ODCommunityModel *model = self.FirstDataArray[indexPath.row];
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc]init];
    picController.photos = model.imgs;
    picController.selectedIndex = button.tag-10*indexPath.row;
   [self presentViewController:picController animated:YES completion:nil];

   
    
}

-(void)secondImageButtonClick:(UIButton *)button
{
    ODCommunityCollectionCell *cell = (ODCommunityCollectionCell *)button.superview.superview.superview;
    NSIndexPath *indexPath = [self.secondCollectionView indexPathForCell:cell];
    ODCommunityModel *model = self.secondDataArray[indexPath.row];
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc]init];
    picController.photos = model.imgs;
    picController.selectedIndex = button.tag-10*indexPath.row;
    [self presentViewController:picController animated:YES completion:nil];

}



- (void)othersInformationClick:(UIButton *)sender
{
    
    ODCommunityCollectionCell *cell = (ODCommunityCollectionCell *)sender.superview.superview;
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    
    
    if (sender.tag == 111) {

        
    }else{
        
        NSIndexPath *indexpath = [self.secondCollectionView indexPathForCell:cell];
        ODCommunityModel *model = self.secondDataArray[indexpath.row];
        NSString *userId = [NSString stringWithFormat:@"%@",model.user_id];

        
        NSString *openId = [ODUserInformation sharedODUserInformation].openID;
        if ([openId isEqualToString:[self.secondUserInfoDic[userId]open_id]]) {
            ;
        }else{
            vc.open_id = [self.secondUserInfoDic[userId]open_id];
            [self.navigationController pushViewController:vc animated:YES];

        }
        
        
        
        
    }
    
    
}

#pragma mark - UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ODCommunityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    if (collectionView.tag == 111) {
        ODCommunityModel *model = self.FirstDataArray[indexPath.row];
        NSString *userId = [NSString stringWithFormat:@"%@",model.user_id];
        cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [cell.headButton addTarget:self action:@selector(othersInformationClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.headButton sd_setBackgroundImageWithURL: [NSURL OD_URLWithString:[self.firstUserInfoDic[userId]avatar_url] ] forState:UIControlStateNormal];
        cell.nickLabel.text = [self.firstUserInfoDic[userId]nick];
        cell.signLabel.text = [self.firstUserInfoDic[userId]sign];
        [cell showDateWithModel:model];
        CGFloat width=kScreenSize.width>320?90:70;
        if (model.imgs.count) {
            for (id vc in cell.picView.subviews) {
                [vc removeFromSuperview];
            }
            if (model.imgs.count==4) {
                for (NSInteger i = 0; i < model.imgs.count; i++) {
                    UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake((width+5)*(i%2), (width+5)*(i/2), width, width)];
                    [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.imgs[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error){
                            [imageButton setBackgroundImage:[UIImage imageNamed:@"errorplaceholderImage"] forState:UIControlStateNormal];
                        }
                    }];
                    [imageButton addTarget:self action:@selector(firstImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    imageButton.tag = 10*indexPath.row+i;
                    [cell.picView addSubview:imageButton];
                }
                cell.PicConstraintHeight.constant = 2*width+5;
            }else{
                for (NSInteger i = 0;i < model.imgs.count ; i++) {
                    UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake((width+5)*(i%3), (width+5)*(i/3), width, width)];
                    [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.imgs[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error){
                            [imageButton setBackgroundImage:[UIImage imageNamed:@"errorplaceholderImage"] forState:UIControlStateNormal];
                        }
                    }];
                    [imageButton addTarget:self action:@selector(firstImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    imageButton.tag = 10*indexPath.row+i;
                    [cell.picView addSubview:imageButton];
                }
                cell.PicConstraintHeight.constant = width+(width+5)*(model.imgs.count/3);
            }
        }else{
            for (id vc in cell.picView.subviews) {
                [vc removeFromSuperview];
            }
            cell.PicConstraintHeight.constant = 0;
        }
        cell.headButton.tag = 111;

        
    }else if (collectionView.tag == 222) {
        
        ODCommunityModel *model = self.secondDataArray[indexPath.row];
        NSString *userId = [NSString stringWithFormat:@"%@",model.user_id];
        cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [cell.headButton addTarget:self action:@selector(othersInformationClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.headButton sd_setBackgroundImageWithURL: [NSURL OD_URLWithString:[self.secondUserInfoDic[userId]avatar_url] ] forState:UIControlStateNormal];
        cell.nickLabel.text = [self.secondUserInfoDic[userId]nick];
        cell.signLabel.text = [self.secondUserInfoDic[userId]sign];
        [cell showDateWithModel:model];
        CGFloat width=kScreenSize.width>320?90:70;
        if (model.imgs.count) {
            for (id vc in cell.picView.subviews) {
                [vc removeFromSuperview];
            }
            if (model.imgs.count==4) {
                for (NSInteger i = 0; i < model.imgs.count; i++) {
                    UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake((width+5)*(i%2), (width+5)*(i/2), width, width)];
                    [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.imgs[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error){
                            [imageButton setBackgroundImage:[UIImage imageNamed:@"errorplaceholderImage"] forState:UIControlStateNormal];
                        }
                    }];
                    [imageButton addTarget:self action:@selector(secondImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    imageButton.tag = 10*indexPath.row+i;
                    [cell.picView addSubview:imageButton];
                }
                cell.PicConstraintHeight.constant = 2*width+5;
            }else{
                for (NSInteger i = 0;i < model.imgs.count ; i++) {
                    UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake((width+5)*(i%3), (width+5)*(i/3), width, width)];
                    [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.imgs[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error){
                            [imageButton setBackgroundImage:[UIImage imageNamed:@"errorplaceholderImage"] forState:UIControlStateNormal];
                        }
                    }];
                    [imageButton addTarget:self action:@selector(secondImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    imageButton.tag = 10*indexPath.row+i;
                    [cell.picView addSubview:imageButton];
                }
                cell.PicConstraintHeight.constant = width+(width+5)*(model.imgs.count/3);
            }
        }else{
            for (id vc in cell.picView.subviews) {
                [vc removeFromSuperview];
            }
            cell.PicConstraintHeight.constant = 0;
        }
        cell.headButton.tag = 222;


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
    
  
    if (collectionView.tag == 111) {
        
        
        self.firstIndex = indexPath.row;
        
        detailController.myBlock = ^(NSString *refresh){
            self.isFirstRefresh = refresh;
        };
       
        
        ODCommunityModel *model = self.FirstDataArray[indexPath.row];
        detailController.bbs_id = [NSString stringWithFormat:@"%@",model.id];
        [self.navigationController pushViewController:detailController animated:YES];

    }else if (collectionView.tag == 222) {
       
           self.secondIndex = indexPath.row;
        
        
        
        detailController.myBlock = ^(NSString *refresh){
            self.isSecondRefresh = refresh;
        };

        
        ODCommunityModel *model = self.secondDataArray[indexPath.row];
        detailController.bbs_id = [NSString stringWithFormat:@"%@",model.id];
        [self.navigationController pushViewController:detailController animated:YES];
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 111) {
        
         return CGSizeMake(kScreenSize.width, [self returnHight:self.FirstDataArray[indexPath.row]]);
        
    }else{
        
        return CGSizeMake(kScreenSize.width, [self returnHight:self.secondDataArray[indexPath.row]]);

    }
   
    
}

//动态计算cell的高度
-(CGFloat)returnHight:(ODCommunityModel *)model
{
    CGFloat width=kScreenSize.width>320?90:70;
    if (model.imgs.count==0) {
        return 135;
    }else if (model.imgs.count>0&&model.imgs.count<4){
        return 135+width;
    }else if (model.imgs.count>=4&&model.imgs.count<7){
        return 135+2*width+5;
    }else if (model.imgs.count>=7&&model.imgs.count<9){
        return 135+3*width+10;
    }else{
        return 135+3*width+10;
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

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
