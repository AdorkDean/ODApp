//
//  ODOperationController.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODOperationController.h"
#import "ODTabBarController.h"

@interface ODOperationController ()
@property(nonatomic, assign)BOOL isClean;
@property (nonatomic , strong) UILabel *cachesLabel;

@end

@implementation ODOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    __weakSelf
    [[NSNotificationCenter defaultCenter]addObserverForName:ODNotificationloveSkill object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [self createClearCacheView];
    [self createQuitButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createClearCacheView{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearCacheClick)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44)];
    [view addGestureRecognizer:tapGesture];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 0, 120, 44)];
    label.text = @"清理缓存";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    
    self.cachesLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-140, 0, 100, 44)];
    self.cachesLabel.text = [NSString stringWithFormat:@"%.2fM",[self filePath]];
    self.cachesLabel.textAlignment = NSTextAlignmentRight;
    self.cachesLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:self.cachesLabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.cachesLabel.frame)+14.5, 15, 8, 14)];
    imageView.image = [UIImage imageNamed:@"场地预约icon2"];
    [view addSubview:imageView];
}

-(void)createQuitButton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(17.5, 64, kScreenSize.width-35, 35)];
    [button addTarget:self action:@selector(quitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorRedColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    button.layer.borderWidth = 1;
    [self.view addSubview:button];
}

#pragma mark - action
-(void)clearCacheClick{
    if ([self.cachesLabel.text isEqualToString:@"0.00M"]) {
        [ODProgressHUD showInfoWithStatus:@"没有缓存可清理"];
    }else{
        __weakSelf
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否清理缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cleanCach];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }
}

-(void)quitButtonClick{
    __weakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        self.tabBarController.selectedIndex = 0;
        [weakSelf dismissViewControllerAnimated:YES completion:^{
        }];
        //清空数据
        [ODUserInformation sharedODUserInformation].openID = @"";
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"" forKey:KUserDefaultsOpenId];

        [ODUserInformation sharedODUserInformation].avatar = @"";
        [user setObject:@"" forKey:KUserDefaultsAvatar];

        [ODUserInformation sharedODUserInformation].mobile = @"";
        [user setObject:@"" forKey:KUserDefaultsMobile];
        [ODProgressHUD showInfoWithStatus:@"已退出登录"];
        [[NSNotificationCenter defaultCenter]postNotificationName:ODNotificationQuit object:self];
                  }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [weakSelf presentViewController:alert animated:YES completion:^{
    }];
}

- (void)cleanCach{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *pathArray = [fileManager subpathsAtPath:cachesPath];
    for (NSString *filePath in pathArray) {
        NSString *deletePath = [cachesPath stringByAppendingPathComponent:filePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:deletePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:deletePath error:nil];
        }
    }
   self.cachesLabel.text = @"0.00M";
}

- (float)filePath{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [self folderSizeAtPath:cachPath];
}

// 遍历文件夹 获得文件的大小，返回多少M 提示：你可以在工程界设置（m）
- (float)folderSizeAtPath:(NSString *)folderPath{
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

- (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
@end
