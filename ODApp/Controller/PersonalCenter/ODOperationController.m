//
//  ODOperationController.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODOperationController.h"
#import "ODLandSecondCell.h"
#import "ODTabBarController.h"
@interface ODOperationController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;


@end

@implementation ODOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    self.navigationItem.title = @"设置";
    
    
      [self createCollectionView];
    
    
    
}

#pragma mark - 初始化
-(void)createCollectionView
{
    
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) collectionViewLayout:self.flowLayout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
      [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandSecondCell" bundle:nil] forCellWithReuseIdentifier:@"second"];
    
    [self.view addSubview:self.collectionView];
    
    
    
    
}




#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
  
        ODLandSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        
        
        if (indexPath.section == 0) {
            cell.titleLabel.text = @"清理缓存";
            
        }else if (indexPath.section == 1) {
            cell.titleLabel.text = @"退出登录";
            
        }
            
            
            
    return cell;
        
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        ;
    }else {
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ODTabBarController *tabBar = (ODTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            ;
            tabBar.selectedIndex = 0;
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            //清空数据
            [ODUserInformation sharedODUserInformation].openID = @"";
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:@"" forKey:KUserDefaultsOpenId];
            
            [self createProgressHUDWithAlpha:0.6f withAfterDelay:1.0 title:@"已退出登录"];
            
            tabBar.selectedIndex = tabBar.currentIndex;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
    
    
}



//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
          return CGSizeMake(kScreenSize.width , 40);
    
}


//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    return CGSizeMake(0, 5);
    
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
