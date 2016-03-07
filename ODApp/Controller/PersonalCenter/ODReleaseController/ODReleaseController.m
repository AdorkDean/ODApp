//
//  ODReleaseController.m
//  ODApp
//
//  Created by Bracelet on 16/2/18.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODReleaseController.h"
#import "ODBazaarExchangeSkillDetailViewController.h"


NSString * const ODReleaseCellID = @"ODReleaseCell";
@interface ODReleaseController ()

@property (nonatomic, assign) long deleteRow;
@property (nonatomic, assign) long loveRow;

@end

@implementation ODReleaseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"已发布";
    
    self.pageCount = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self createRequestData];
    __weakSelf;
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationEditSkill object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note)
    {
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:ODNotificationloveSkill object:nil];

}

- (void)loadMoreData
{
    self.pageCount ++;
    [self createRequestData];
}

- (void)reloadData:(NSNotification *)text
{
    ODReleaseModel *model = self.dataArray[self.loveRow];
    model.love_num = [NSString stringWithFormat:@"%@" , text.userInfo[@"loveNumber"]];
    [self.dataArray replaceObjectAtIndex:self.loveRow withObject:model];
    [self.collectionView reloadData];
}

#pragma mark - 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 加载数据请求
- (void)createRequestData
{
    
    __weakSelf
    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%i", self.pageCount],@"city_id":@"1",@"my":@"1",@"open_id":[ODUserInformation sharedODUserInformation].openID};
    [ODHttpTool getWithURL:ODUrlPersonalReleaseTask parameters:parameter modelClass:[ODReleaseModel class] success:^(id model)
     {
         if (self.pageCount == 1)
         {
             [self.dataArray removeAllObjects];
             [self.noReusltLabel removeFromSuperview];
         }
       
        for (ODReleaseModel *md in [model result])
        {
            if (![[weakSelf.dataArray valueForKeyPath:@"swap_id" ] containsObject:[md swap_id]])
            {
                [weakSelf.dataArray addObject: md];
            }
        }
         
        [weakSelf.collectionView.mj_header endRefreshing];
        if ([[model result]count] == 0)
        {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
         [weakSelf.collectionView.mj_footer endRefreshing];
        }
        [weakSelf.collectionView reloadData];
        
        if (self.pageCount == 1 && self.dataArray.count == 0)
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

#pragma mark - 删除技能请求
- (void)deleteSkillRequest
{
    NSDictionary *parameter = @{@"open_id":[ODUserInformation sharedODUserInformation].openID, @"swap_id":self.swap_id};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlSwapDel parameters:parameter modelClass:[NSObject class] success:^(id model)
    {
        [ODProgressHUD showInfoWithStatus:@"删除任务成功"];
        [weakSelf.dataArray removeObject:weakSelf.dataArray[self.deleteRow]];
        [weakSelf.collectionView reloadData];
    }
                   failure:^(NSError *error)
    {
        
    }];
}

#pragma mark - Action

#pragma mark - 编辑 点击事件
- (void)editButtonClick:(UIButton *)button
{
    ODReleaseCell *cell = (ODReleaseCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODReleaseModel *model = self.dataArray[indexPath.row];
    
    if (![[NSString stringWithFormat:@"%@", model.status] isEqualToString:@"-1"])
    {
        ODBazaarReleaseSkillViewController *vc = [[ODBazaarReleaseSkillViewController alloc] init];
        vc.swap_id = [NSString stringWithFormat:@"%@",model.swap_id];
        vc.skillTitle = model.title;
        vc.content = model.content;
        vc.price = model.price;
        vc.unit = model.unit;
        vc.swap_type = [NSString stringWithFormat:@"%@",model.swap_type];
        vc.type = @"编辑";
        vc.imageArray = [model.imgs_small valueForKeyPath:@"img_url"];
        [vc.strArray addObjectsFromArray:[model.imgs_small valueForKeyPath:@"md5"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 删除 点击事件
- (void)deleteButtonClick:(UIButton *)button
{
    __weakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除技能" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        ODReleaseCell *cell = (ODReleaseCell *)button.superview.superview;
        NSIndexPath *indexPath = [weakSelf.collectionView indexPathForCell:cell];
        ODReleaseModel *model = weakSelf.dataArray[indexPath.row];
        self.deleteRow = indexPath.row;
        weakSelf.swap_id = model.swap_id;
        [weakSelf deleteSkillRequest];

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Create UICollectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        __weakSelf
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout.minimumLineSpacing = 5;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight) collectionViewLayout:self.flowLayout];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
        [self.collectionView registerNib:[UINib nibWithNibName:@"ODReleaseCell" bundle:nil] forCellWithReuseIdentifier:ODReleaseCellID];
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
                                         {
                                             weakSelf.pageCount = 1;
                                             [weakSelf createRequestData];
                                         }];
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^
                                         {
                                             [weakSelf loadMoreData];
                                         }];
        [self.view addSubview:self.collectionView];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODReleaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ODReleaseCellID forIndexPath:indexPath];
    self.model = self.dataArray[indexPath.row];
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [cell.editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell setModel:self.model];
    
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(KScreenWidth, 138);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarExchangeSkillDetailViewController *vc = [[ODBazaarExchangeSkillDetailViewController alloc] init];
    ODReleaseModel *model = self.dataArray[indexPath.row];
    self.loveRow = indexPath.row;
    if (![[NSString stringWithFormat:@"%@", model.status] isEqualToString:@"-1"])
    {
        vc.swap_id = [NSString stringWithFormat:@"%@",model.swap_id];
        vc.nick = model.user[@"nick"];
        NSLog(@"%@",vc.swap_id);
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning
{
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
