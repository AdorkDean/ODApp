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
    
}

- (void) createRequestData
{

    __weakSelf
    NSDictionary *parameter = @{@"page":@"1",@"city_id":@"0",@"my":@"1"};
    [ODHttpTool getWithURL:ODPersonalReleaseTaskUrl parameters:parameter modelClass:[ODReleaseModel class] success:^(id model) {
        
        
    } failure:^(NSError *error) {
        
        
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

    return nil;
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{

    return CGSizeMake(KScreenWidth, 180);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
