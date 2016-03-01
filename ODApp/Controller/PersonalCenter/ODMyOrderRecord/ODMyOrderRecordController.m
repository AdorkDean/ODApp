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
    ODMyOrderRecordModel *model = self.orderArray[self.cancelOrderRow];
    model.status_str = [NSString stringWithFormat:@"%@", text.userInfo[@"status_str"]];
    [self.orderArray replaceObjectAtIndex:self.cancelOrderRow withObject:model];
    [self.collectionView reloadData];
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
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"open_id":[NSString stringWithFormat:@"%@",self.open_id],@"page":[NSString stringWithFormat:@"%ld",(long)self.count]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];

    __weak typeof (self)weakSelf = self;
    [self.manager GET:kMyOrderRecordUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        [weakSelf.noReusltLabel removeFromSuperview];
        
        if (weakSelf.count == 1)
        {
            [weakSelf.orderArray removeAllObjects];
        }
        
        if (responseObject)
        {
 
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            for (NSDictionary *itemDict in result)
            {
                ODMyOrderRecordModel *model = [[ODMyOrderRecordModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];

                if (![[weakSelf.orderArray valueForKeyPath:@"order_id"]containsObject:model.order_id])
                {
                    [weakSelf.orderArray addObject:model];
                }
            }
            if (weakSelf.count == 1 && weakSelf.orderArray.count == 0)
            {
                weakSelf.noReusltLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80)/2, kScreenSize.height/2, 80, 30) text:@"暂无预约" font:16 alignment:@"center" color:@"#000000" alpha:1];
                [weakSelf.view addSubview:weakSelf.noReusltLabel];
            }
            
            [weakSelf.collectionView.mj_header endRefreshing];
            if (!result.count == 0)
            {                
                [weakSelf.collectionView.mj_footer endRefreshing];
            }else
            {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.collectionView reloadData];
        }
        

    }
              failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error)
    {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
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
    cell.layer.borderWidth = 1;
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODMyOrderRecordModel *model = self.orderArray[indexPath.row];
    NSString *purpose = model.purpose;
    NSDictionary *purposeDict = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGSize purposeSize = [purpose boundingRectWithSize:CGSizeMake(kScreenSize.width-125.5, 35) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) attributes:purposeDict context:nil].size;
    NSString *name = model.position_str;
    NSDictionary *nameDict = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGSize nameSize = [name boundingRectWithSize:CGSizeMake(kScreenSize.width-125.5, 35) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) attributes:nameDict context:nil].size;
    

    return CGSizeMake(kScreenSize.width - 8, purposeSize.height+nameSize.height+120);
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
}


- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


@end
