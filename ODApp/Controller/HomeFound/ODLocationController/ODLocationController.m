//
//  ODLocationController.m
//  ODApp
//
//  Created by Bracelet on 16/2/2.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODLocationController.h"

NSString *const ODLocationCellID = @"ODLocationCell";

@interface ODLocationController ()
{
    AMapSearchAPI *_search;
    MAMapView *_mapView;
}

@end

@implementation ODLocationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"选择城市";
    
    self.cityListArray = [[NSMutableArray alloc] init];
    self.cityIdArray = [[NSMutableArray alloc] init];
    [self createCollectionView];
    [self getCityListRequest];
}

- (void)getCityListRequest
{
    __weakSelf
    NSDictionary *parameter = @{@"region_name":@"上海"};
    [ODHttpTool getWithURL:ODUrlCityList parameters:parameter modelClass:[ODLocationModel class] success:^(id model)
    {
        ODLocationModel *mode = [model result];
        weakSelf.cityListArray = [mode.all valueForKeyPath:@"name"];
        weakSelf.cityIdArray = [mode.all valueForKey:@"id"];
        [weakSelf.collectionView reloadData];
        
    }
                   failure:^(NSError *error)
    {
        
    }];
}

- (void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight) collectionViewLayout:self.flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLocationCell" bundle:nil] forCellWithReuseIdentifier:ODLocationCellID];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODLocationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ODLocationCellID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    
    cell.cityNameLabel.text = self.cityListArray[indexPath.row];
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cityListArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [ODUserInformation sharedODUserInformation].locationCity = self.cityListArray[indexPath.row];
    [ODUserInformation sharedODUserInformation].cityID = self.cityIdArray[indexPath.row];

    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationLocationSuccessRefresh object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width , 40);
}

//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
