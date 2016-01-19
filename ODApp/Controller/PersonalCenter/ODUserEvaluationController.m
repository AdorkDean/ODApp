//
//  ODUserEvaluationController.m
//  ODApp
//
//  Created by zhz on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODUserEvaluationController.h"
#import "MJRefresh.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "ODEvaluationCell.h"
#import "ODEvaluationModel.h"
@interface ODUserEvaluationController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) NSInteger pageNumber;
@end

@implementation ODUserEvaluationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageNumber = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    
   
    
    [self navigationInit];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
  
    [self createCollectionView];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downRefresh];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMoreData];
    }];


    [self getData];
    
}

-(void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width,kScreenSize.height - 64 - 55) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [ODColorConversion colorWithHexString:@"#d9d9d9" alpha:1];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ODEvaluationCell class] forCellWithReuseIdentifier:@"item"];
    
    [self.view addSubview:self.collectionView];
}

- (void)downRefresh
{
    self.pageNumber = 1;
    [self getData];

}

- (void)loadMoreData
{
    self.pageNumber++;
    [self getData];

}

- (void)getData
{
    
    
    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.pageNumber];
    
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"type":@"1", @"page":countNumber, @"open_id":self.openId};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.odong.com/1.0/user/comment/list";
    
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([countNumber isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            
        }
        
        
        
        if (responseObject) {
            
            
          
            NSMutableDictionary *dic = responseObject[@"result"];
            for (NSMutableDictionary *miniDic in dic) {
                ODEvaluationModel *model = [[ODEvaluationModel alloc] init];
                [model setValuesForKeysWithDictionary:miniDic];
                [self.dataArray addObject:model];
                
             
                
                
            }
            
            
            
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];

            
            
        }
        
        
      
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    
    
    
  
    
    
}


#pragma mark - 初始化
-(void)navigationInit
{
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [ODColorConversion colorWithHexString:@"#d9d9d9" alpha:1];;
    self.navigationController.navigationBar.hidden = YES;
    
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 登陆label
    UILabel *centerNameLabe = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width / 2 - 110, 28, 220, 20) text:self.typeTitle font:17 alignment:@"center" color:@"#000000" alpha:1];
    
    centerNameLabe.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:centerNameLabe];
    
    
    
    // 返回button
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(backAction:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
    
    
    
    
    
}

#pragma mark - 点击事件

- (void)backAction:(UIButton *)sender
{
   
    
   [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODEvaluationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.dataArray[indexPath.row];
    
    
    return cell;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}




//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width , [ODEvaluationCell returnHight:self.dataArray[indexPath.row]]);
    
    
    
}
//动态设置每个分区的缩进量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//动态返回不同区的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
    
}
//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
