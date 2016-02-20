//
//  ODOperationController.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODOperationController.h"

#import "ODTabBarController.h"
#import "ODOperationFirstCell.h"
#import "ODOperationSeccondCell.h"
@interface ODOperationController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property(nonatomic, assign)BOOL isClean;
@property (nonatomic , strong) UILabel *cachesLabel;

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
      [self.collectionView registerNib:[UINib nibWithNibName:@"ODOperationSeccondCell" bundle:nil] forCellWithReuseIdentifier:@"second"];
    
      [self.collectionView registerNib:[UINib nibWithNibName:@"ODOperationFirstCell" bundle:nil] forCellWithReuseIdentifier:@"first"];
    
    
    [self.view addSubview:self.collectionView];
    
    
    
    
}




#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
  
    
        
        
        if (indexPath.section == 0) {
            
            
        ODOperationSeccondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
            
            
            self.cachesLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 150 , 10 , 60 , 20)];
            self.cachesLabel.backgroundColor = [UIColor whiteColor];
            self.cachesLabel.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:self.cachesLabel];
            self.cachesLabel.text = [NSString stringWithFormat:@"%.2fM",[self filePath]];

            
       
            return cell;
            
            
            
        }else{
            
            
        
            
            ODOperationFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
            
            cell.titleLabel.text = @"退出登录";
            
            return cell;

            
            
          

            
        }
            
            
            
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        
        if ([self.cachesLabel.text isEqualToString:@"0.00M"]) {
              [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"没有缓存可清理"];
        }else{
            
          
            __weakSelf
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否清理缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
           
                [self cleanCach];
            
            
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
         
            [weakSelf presentViewController:alert animated:YES completion:nil];

            

            
        }
        
        
        
        
        
    }else {
        
        __weakSelf
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ODTabBarController *tabBar = (ODTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            ;
            tabBar.selectedIndex = 0;
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            //清空数据
            [ODUserInformation sharedODUserInformation].openID = @"";
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:@"" forKey:KUserDefaultsOpenId];
            
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:1.0 title:@"已退出登录"];
            
            tabBar.selectedIndex = tabBar.currentIndex;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
        
        
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


- (void)cleanCach
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *pathArray = [fileManager subpathsAtPath:cachesPath];
    // 遍历缓存文件中所有文件
    for (NSString *filePath in pathArray) {
        NSString *deletePath = [cachesPath stringByAppendingPathComponent:filePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:deletePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:deletePath error:nil];
            
        }
    }
    
    
   self.cachesLabel.text = @"0.00M";
    
    
}
// 显示缓存大小 filePath 方法实现
- (float)filePath
{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [self folderSizeAtPath:cachPath];
}

// 遍历文件夹 获得文件的大小，返回多少M 提示：你可以在工程界设置（m）
- (float)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024 * 1024);
}
// fileSizeAtPath
- (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
