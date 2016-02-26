//
//  ODWithdrawalDetailController.m
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODWithdrawalDetailController.h"
#import "ODWithdrawalCell.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODBalanceModel.h"
@interface ODWithdrawalDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *noReusltLabel;


@end

@implementation ODWithdrawalDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.navigationItem.title = @"提现明细";
    
    self.dataArray = [[NSMutableArray alloc] init];
    [self getData];
    [self createCollectionView];
    
    
}


#pragma mark - 请求数据
- (void)getData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    
    NSDictionary *parameters = @{@"open_id":openId};
    
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kBalanceListUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            
            
            
         
            
            
            [self.dataArray removeAllObjects];
            
            NSMutableDictionary *dic = responseObject[@"result"];
            
            NSLog(@"_____%@"  ,dic);
            
            
            for (NSMutableDictionary *miniDic in dic) {
                ODBalanceModel *model = [[ODBalanceModel alloc] init];
                [model setValuesForKeysWithDictionary:miniDic];
                [self.dataArray addObject:model];
            }
            
            if (self.dataArray.count == 0) {
                weakSelf.noReusltLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenSize.width - 160)/2, kScreenSize.height/2, 160, 30)];
                weakSelf.noReusltLabel.text = @"暂无提现记录";
                weakSelf.noReusltLabel.font = [UIFont systemFontOfSize:16];
                weakSelf.noReusltLabel.textAlignment = NSTextAlignmentCenter;
                weakSelf.noReusltLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
                [weakSelf.view addSubview:weakSelf.noReusltLabel];
            }
            
            
            [self.collectionView reloadData];
            
        }
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            
            
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
            
        }

             
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}





#pragma mark - 初始化
-(void)createCollectionView
{
    
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) collectionViewLayout:self.flowLayout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODWithdrawalCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
    
    
    
    
}




#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
            
    ODWithdrawalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    
    ODBalanceModel *model = self.dataArray[indexPath.section];
    
    cell.model = model;
    
    
    
    return cell;
        
    
}


//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width , 55);
    
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    return self.dataArray.count;
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
