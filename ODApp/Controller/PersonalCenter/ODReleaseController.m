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
    
    self.navigationItem.title = @"已发布的任务";
    
    self.dataArray = [[NSArray alloc] init];
    [self createCollectionView];
    [self createRequestData];
    
}

- (void)createRequestData
{

    __weakSelf
    NSDictionary *parameter = @{@"page":@"1",@"city_id":@"0",@"my":@"0", @"open_id":[ODUserInformation sharedODUserInformation].openID};
    [ODHttpTool getWithURL:ODPersonalReleaseTaskUrl parameters:parameter modelClass:[ODReleaseModel class] success:^(id model) {
        
        self.dataArray = [model result];
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Action
- (void)editButtonClick:(UIButton *)button
{

    
}

- (void)deleteButtonClick:(UIButton *)button
{

    ODReleaseCell *cell = (ODReleaseCell *)button.superview.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    ODReleaseModel *model = self.dataArray[indexPath.row];
    
    self.swap_id = model.swap_id;
 
    [self deleteSkillRequest];
}

- (void)deleteSkillRequest{

    self.manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"swap_id":self.swap_id};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weakSelf
    [self.manager GET:ODPersonReleaseTaskDeleteUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [weakSelf createRequestData];
        NSLog(@"_____________%@", self.swap_id);
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"删除任务成功"];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - Create UICollectionView
- (void)createCollectionView
{

    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumLineSpacing = 1;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight) collectionViewLayout:self.flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODReleaseCell" bundle:nil] forCellWithReuseIdentifier:ODReleaseCellID];
    
    [self.view addSubview:self.collectionView];
}

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

    ODLazyViewController *vc = [[ODLazyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
