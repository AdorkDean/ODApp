//
//  ODCenterActivityViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCenterActivityViewController.h"
#import "CenterActivityCell.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "CenterActivityModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ODChoseCenterController.h"
#import "ODCenterDetailController.h"
#import "ODCenterYuYueController.h"
#import "ODActivityDetailController.h"
#import "SDCycleScrollView.h"
#import "ODActivityHeadView.h"
#import "ODCenterPactureController.h"
#import "ODTabBarController.h"
#import "ChoseCenterModel.h"
#import "ODUserInformation.h"
#import "ODPersonalCenterViewController.h"
#import "ODTabBarController.h"
@interface ODCenterActivityViewController ()<UIScrollViewDelegate ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , SDCycleScrollViewDelegate>

@property(nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic, strong) ODActivityHeadView *firstHeader;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)AFHTTPRequestOperationManager *managers;
@property(nonatomic,strong)AFHTTPRequestOperationManager *centerManager;
@property(nonatomic,strong)AFHTTPRequestOperationManager *phoneManager;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *pictureArray;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *pictureDetailArray;
@property(nonatomic,strong)NSMutableArray *centerArray;
@property (nonatomic , assign) NSInteger centerNumber;

@property (nonatomic , copy) NSString *phoneNumber;

@end

@implementation ODCenterActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isChange = NO;
    
    self.centerNumber = 1;
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.centerArray = [[NSMutableArray alloc] init];
    self.pictureArray = [[NSMutableArray alloc] init];
    self.pictureDetailArray = [[NSMutableArray alloc] init];
    self.titleArray = [[NSMutableArray alloc] init];

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
  

    [self navigationInit];
    [self createCollectionView];
    [self getCenter];
   
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downRefresh];
    }];
    
    
}




#pragma mark - 初始化
-(void)navigationInit
{
    
    self.view.backgroundColor = [ODColorConversion colorWithHexString:@"#d9d9d9" alpha:1];
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 中心活动label
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80) / 2, 28, 80, 20) text:@"中心活动" font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    
    // 场地预约button
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 100, 28,90, 20) target:self sel:@selector(rightClick:) tag:0 image:nil title:@"场地预约" font:17];
    [confirmButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    
    confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    UIImageView *releaseImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(0, 0, 17, 17) imageName:@"场地预约icon@3x" tag:0];
    [confirmButton addSubview:releaseImageView];
    [self.headView addSubview:confirmButton];
    
}




#pragma mark - 刷新
- (void)downRefresh
{
     [self getCenter];
   
    
}


#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 1;

    if (self.isChange == YES) {
        [self.collectionView.mj_header beginRefreshing];
    }
    
    

}


#pragma mark - 请求数据
- (void)getCenter
{
    self.centerManager = [AFHTTPRequestOperationManager manager];
    self.centerManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameter = @{@"show_type":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    NSString *url = @"http://woquapi.odong.com/1.0/other/store/list";
    
    
    [self.centerManager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            
            [self.centerArray removeAllObjects];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *result = dict[@"result"];
            
            for (NSMutableDictionary *dic in result) {
                ChoseCenterModel *model = [[ChoseCenterModel alloc] initWithDict:dic];
                [self.centerArray addObject:model];
            }
            
            
            ChoseCenterModel *model = self.centerArray[self.centerNumber - 1];
            NSString *storeId = [NSString stringWithFormat:@"%ld" , (long)model.storeId];
            self.storeId = storeId;
            self.centerName = model.name;
            [self getLunBoPicture];
            [self getData];
            [self getPhoneNumber];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
        
        
    }];
    
    
    
}

- (void)getPhoneNumber
{
    
    self.phoneManager = [AFHTTPRequestOperationManager manager];
    self.phoneManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameter = @{@"store_id":self.storeId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    NSString *url = @"http://woquapi.odong.com/1.0/other/store/detail";
    
       [self.phoneManager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *result = dict[@"result"];
            
            
            self.phoneNumber = result[@"tel"];
            
                      
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
        
        
    }];

    
}

- (void)getLunBoPicture
{
    
    
    self.managers = [AFHTTPRequestOperationManager manager];
    self.managers.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"position":@"4" , @"store_id":self.storeId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    NSString *url = @"http://woquapi.odong.com/1.0/other/banner";
    
    __weak typeof (self)weakSelf = self;
    [self.managers GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        
        
        if (responseObject) {
            
            
              [self.pictureArray removeAllObjects];
              [self.pictureDetailArray removeAllObjects];
              [self.titleArray removeAllObjects];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *result = dict[@"result"];
            
                        
            for (NSDictionary *itemDict in result) {
             
                NSString *picture = itemDict[@"img_url"];
                NSString *pictureDetail = itemDict[@"banner_url"];
                NSString *title = itemDict[@"title"];
                
                
                [weakSelf.pictureArray addObject:picture];
                [weakSelf.pictureDetailArray addObject:pictureDetail];
                [weakSelf.titleArray addObject:title];
                
            }
            
            [weakSelf.collectionView reloadData];
          
           
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
             
    }];
    
    
    
}


-(void)getData
{
    
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameter = @{@"store_id":self.storeId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    NSString *url = @"http://woquapi.odong.com/1.0/store/apply/list";
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *result = dict[@"result"];
            
            [weakSelf.dataArray removeAllObjects];
            
            for (NSDictionary *itemDict in result) {
                CenterActivityModel *model = [[CenterActivityModel alloc] initWithDict:itemDict];
                
                
                [weakSelf.dataArray addObject:model];
            }
            [self.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
   
}



#pragma mark - 点击事件
-(void)rightClick:(UIButton *)button
{
    
    
    if ([ODUserInformation getData].openID == nil) {
        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else {
        ODCenterYuYueController *vc = [[ODCenterYuYueController alloc] init];
        
        vc.centerName = self.centerName;
        vc.storeId = self.storeId;
        vc.phoneNumber = self.phoneNumber;
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    
    
    
}


- (void)centerDetail:(UIButton *)sender
{
    
    
    if (![self.storeId isEqualToString:@"0"]) {
        ODCenterDetailController *vc = [[ODCenterDetailController alloc] init];
        
       
        vc.storeId = self.storeId;
        
        
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        ;
    }
   
    
}


- (void)searchButtonClick:(UIButton *)sender
{
    
    self.isChange = YES;
    
    ODChoseCenterController *vc = [[ODChoseCenterController alloc] init];
    
    
      vc.storeCenterNameBlock = ^(NSString *name , NSString *storeId , NSInteger storeNumber){
       
      
          self.centerNumber = storeNumber;
          
          
          [self.firstHeader.searchButton setTitle:name forState:UIControlStateNormal];
          
          
    };

    
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)createCollectionView
{
    
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64 - 55) collectionViewLayout:self.flowLayout];

 
    [self.collectionView registerClass:[ODActivityHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"firstHeader"];

    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [ODColorConversion colorWithHexString:@"#d9d9d9" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CenterActivityCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];

    
    
    
}


#pragma mark - UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CenterActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    
    
    if (iPhone4_4S) {
        cell.toRightSpace.constant = 210;
    }else if (iPhone5_5s){
        cell.toRightSpace.constant = 210;
    }else if (iPhone6_6s){
        cell.toRightSpace.constant = 260;
    }else{
        cell.toRightSpace.constant = 300;

    }

  
    cell.coverImageView.layer.masksToBounds = YES;
    cell.coverImageView.layer.cornerRadius = 5;
    cell.coverImageView.layer.borderColor = [ODColorConversion colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    cell.coverImageView.layer.borderWidth = 1;
    
    
   
    CenterActivityModel *model = self.dataArray[indexPath.row];
    
    
    cell.titleLabel.text = model.content;
    cell.timeLabel.text = model.date_str;
    cell.addressLabel.text = model.address;
    cell.timeLabel.textColor = [ODColorConversion colorWithHexString:@"#b1b1b1" alpha:1];
    cell.addressLabel.textColor = [ODColorConversion colorWithHexString:@"#b1b1b1" alpha:1];
    [cell.ActivityImageView sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    
    
    
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ODActivityDetailController *vc = [[ODActivityDetailController alloc] init];
    
     CenterActivityModel *model = self.dataArray[indexPath.row];
    
    
    if ([ODUserInformation getData].openID == nil) {
        

        
        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

        
        

    }else{
        
   
        
        vc.activityId = [NSString stringWithFormat:@"%ld" , (long)model.activity_id];
        vc.storeId = self.storeId;
        vc.openId =   [ODUserInformation getData].openID;

        [self.navigationController pushViewController:vc animated:YES];

    }
    
    
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
   
    self.firstHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"firstHeader" forIndexPath:indexPath];
    
    
    
    self.firstHeader.cycleScrollerView.delegate = self;
    [self.firstHeader.cycleScrollerView setImageURLStringsGroup:self.pictureArray];
    [self.firstHeader.cycleScrollerView setTitlesGroup:self.titleArray];

    
    [self.firstHeader.searchButton setTitleColor:[ODColorConversion colorWithHexString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];
    self.firstHeader.searchButton.layer.masksToBounds = YES;
    self.firstHeader.searchButton.layer.cornerRadius = 5;
    self.firstHeader.searchButton.layer.borderColor = [ODColorConversion colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    self.firstHeader.searchButton.layer.borderWidth = 1;
    self.firstHeader.searchButton.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    
    
    
    self.firstHeader.searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 5);
    self.firstHeader.searchButton.layer.masksToBounds = YES;
    self.firstHeader.searchButton.layer.cornerRadius = 5;
    self.firstHeader.searchButton.layer.borderColor = [ODColorConversion colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    self.firstHeader.searchButton.layer.borderWidth = 1;
   UIImageView *image = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width - 120 - 30, 8, 15, 15) imageName:@"场地预约icon2@3x" tag:0];
    
    [self.firstHeader.searchButton addSubview:image];
    [self.firstHeader.searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.firstHeader.centerButton setTitleColor:[ODColorConversion colorWithHexString:@"#484848" alpha:1] forState:UIControlStateNormal];
    self.firstHeader.centerButton.layer.masksToBounds = YES;
    self.firstHeader.centerButton.layer.cornerRadius = 5;
    self.firstHeader.centerButton.layer.borderColor = [ODColorConversion colorWithHexString:@"b0b0b0" alpha:1].CGColor;
    self.firstHeader.centerButton.layer.borderWidth = 1;
    self.firstHeader.centerButton.backgroundColor = [ODColorConversion colorWithHexString:@"#ffd801" alpha:1];
    [self.firstHeader.centerButton addTarget:self action:@selector(centerDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.firstHeader.searchButton setTitle:self.centerName forState:UIControlStateNormal];
    
    
    return self.firstHeader;
    
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
    return 0;
}
//动态返回不同区的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, kScreenSize.height / 3.2 + 45);
    
}
//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    
  
    ODCenterPactureController *vc = [[ODCenterPactureController alloc] init];
    
    
    vc.activityName = self.titleArray[index];
    vc.webUrl = self.pictureDetailArray[index];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
