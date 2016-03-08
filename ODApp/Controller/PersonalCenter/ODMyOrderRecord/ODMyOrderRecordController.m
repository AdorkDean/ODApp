//
//  ODMyOrderRecordController.m
//  ODApp
//
//  Created by Bracelet on 16/1/8.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODMyOrderRecordController.h"
#import "ODUserInformation.h"

#define kMyOrderRecordCellId @"ODMyOrderRecordCell"

@interface ODMyOrderRecordController ()

@property (nonatomic, assign) long cancelOrderRow;

@end

@implementation ODMyOrderRecordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.centerTitle;

    self.count = 1;

    self.orderArray = [[NSMutableArray alloc] init];    

    [self createCollectionView];
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
                                     {
                                         self.count = 1;
                                         [weakSelf createRequest];
                                     }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^
                                     {
                                         [weakSelf loadMoreData];
                                     }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:ODNotificationCancelOrder object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isRefresh) {
        [self.collectionView.mj_header beginRefreshing];
        self.isRefresh = NO;
    }
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)reloadData:(NSNotification *)text
{
    @try {
        ODMyOrderRecordModel *model = self.orderArray[self.cancelOrderRow];
        model.status_str = [NSString stringWithFormat:@"%@", text.userInfo[@"status_str"]];
        [self.orderArray replaceObjectAtIndex:self.cancelOrderRow withObject:model];
        [self.collectionView reloadData];
    }
    @catch (NSException *exception) {
        
    }
}


- (void)loadMoreData
{
    self.count ++;
    [self createRequest];
}

#pragma mark - 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 加载数据请求
- (void)createRequest
{
    
    NSDictionary *parameter = @{@"open_id":[NSString stringWithFormat:@"%@",self.open_id],@"page":[NSString stringWithFormat:@"%ld",(long)self.count]};
    self.noReusltLabel.hidden = YES;
    __weakSelf
    [ODHttpTool getWithURL:ODUrlStoreOrders parameters:parameter modelClass:[ODMyOrderRecordModel class] success:^(id model)
    {
        
        for (ODMyOrderRecordModel *orderModel in [model result])
        {
            if (![[weakSelf.orderArray valueForKey:@"order_id"] containsObject:[orderModel order_id]]) {
                [weakSelf.orderArray addObject:orderModel];
            }
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        if ([[model result] count] == 0)
        {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
        [weakSelf.collectionView reloadData];
        
        if (self.count == 1 && self.orderArray.count == 0)
        {
            weakSelf.noReusltLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenSize.width - 160)/2, kScreenSize.height/2, 160, 30)];
            weakSelf.noReusltLabel.text = @"暂无技能";
            weakSelf.noReusltLabel.font = [UIFont systemFontOfSize:16];
            weakSelf.noReusltLabel.textAlignment = NSTextAlignmentCenter;
            weakSelf.noReusltLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
            [weakSelf.view addSubview:weakSelf.noReusltLabel];
        }
        
    }
                   failure:^(NSError *error)
    {
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];  
}

#pragma mark - Crate UICollectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[ UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(4, 4, 0, 4);
    flowLayout.minimumLineSpacing = 5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODMyOrderRecordCell" bundle:nil] forCellWithReuseIdentifier:kMyOrderRecordCellId];

    [self.view addSubview:self.collectionView];    
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.orderArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODMyOrderRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMyOrderRecordCellId forIndexPath:indexPath];
    ODMyOrderRecordModel *model = self.orderArray[indexPath.row];
    [cell showDatawithModel:model];
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    cell.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    cell.layer.borderWidth = 0.5;
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    float height;
    ODMyOrderRecordModel *model = self.orderArray[indexPath.row];
    height = [ODHelp textHeightFromTextString:model.purpose width:KScreenWidth - 126 fontSize:13] - 13;
    height = height + [ODHelp textHeightFromTextString:model.position_str width:KScreenWidth - 126 fontSize:13] - 13;
    
    return CGSizeMake(KScreenWidth - 8, 130 + height);
   
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODMyOrderDetailController *vc = [[ODMyOrderDetailController alloc] init];
    ODMyOrderRecordModel *model = self.orderArray[indexPath.row];
    self.cancelOrderRow = indexPath.row;
    vc.isOther = self.isOther;
    vc.open_id = self.open_id;    
    vc.order_id = [NSString stringWithFormat:@"%@",model.order_id];
    
    [self.navigationController pushViewController:vc animated:YES];
    vc.status_str = [self.orderArray[indexPath.row]status_str];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


@end
