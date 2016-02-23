//
//  ODReleaseController.m
//  ODApp
//
//  Created by 代征钏 on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODReleaseController.h"


NSString * const ODReleaseCellID = @"ODReleaseCell";
@interface ODReleaseController ()

@end

@implementation ODReleaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"已发布";
    self.pageCount = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self createCollectionView];
}

- (void)loadMoreData
{
    self.pageCount ++;
    [self createRequestData];
}

#pragma mark - 加载数据请求
- (void)createRequestData
{

    __weakSelf
    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%i", self.pageCount],@"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID],@"my":@"1", @"open_id":[ODUserInformation sharedODUserInformation].openID};
    [ODHttpTool getWithURL:ODPersonalReleaseTaskUrl parameters:parameter modelClass:[ODReleaseModel class] success:^(id model) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        
        if (model == nil) {
            UILabel *noResultLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenSize.width - 80)/2, kScreenSize.height/2, 80, 30)];
            noResultLabel.text = @"暂无发布任务";
            noResultLabel.font = [UIFont systemFontOfSize:16];
            noResultLabel.textAlignment = NSTextAlignmentCenter;
            noResultLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
            [weakSelf.view addSubview:noResultLabel];
        }
        
        if ([[model result]count] == 0)
        {
            [weakSelf.collectionView.mj_footer noticeNoMoreData];
        }
        for (id md in [model result])
        {
            if ([[weakSelf.dataArray valueForKeyPath:@"swap_id" ] containsObject:[md swap_id]])
            {
                
            }
            else
            {
                [weakSelf.dataArray addObject: md];
            }
        }
        [weakSelf.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_footer endRefreshing];

        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}

#pragma mark - Action

- (void)editButtonClick:(UIButton *)button
{
    ODReleaseCell *cell = (ODReleaseCell *)button.superview.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODReleaseModel *model = self.dataArray[indexPath.row];
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

- (void)deleteButtonClick:(UIButton *)button
{

    __weakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除技能" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ODReleaseCell *cell = (ODReleaseCell *)button.superview.superview.superview;
        NSIndexPath *indexPath = [weakSelf.collectionView indexPathForCell:cell];
        
        ODReleaseModel *model = weakSelf.dataArray[indexPath.row];
        weakSelf.swap_id = model.swap_id;
        [weakSelf deleteSkillRequest];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 删除技能请求
- (void)deleteSkillRequest{

    self.manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"open_id":[ODUserInformation sharedODUserInformation].openID, @"swap_id":self.swap_id};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weakSelf
    [self.manager GET:ODPersonReleaseTaskDeleteUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [weakSelf createRequestData];
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"删除任务成功"];
            
//            [weakSelf.collectionView reloadData];
            [weakSelf.dataArray removeAllObjects];
            [weakSelf createRequestData];
            
        }else{
        
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:responseObject[@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Create UICollectionView
- (void)createCollectionView
{
    __weakSelf
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumLineSpacing = 1;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight) collectionViewLayout:self.flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODReleaseCell" bundle:nil] forCellWithReuseIdentifier:ODReleaseCellID];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageCount = 1;
        [weakSelf createRequestData];
    }];
   
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

    [self.collectionView.mj_header beginRefreshing];
    [self.view addSubview:self.collectionView];
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


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
