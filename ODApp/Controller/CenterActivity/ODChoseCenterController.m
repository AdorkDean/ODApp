//
//  ODChoseCenterController.m
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODChoseCenterController.h"
#import "ChoseCenterCell.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "ChoseCenterModel.h"
#import "ODCenterActivityViewController.h"
@interface ODChoseCenterController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic , strong) UIView *headView;

@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;

@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)NSMutableArray *dataArray;



@end

@implementation ODChoseCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self navigationInit];
     [self createCollectionView];
     [self getData];
    
}

#pragma mark - 请求数据
- (void)getData
{
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    
    NSDictionary *parameter = @{@"show_type":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    NSString *url = @"http://woquapi.odong.com/1.0/other/store/list";
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSMutableDictionary *result = dict[@"result"];
            
            for (NSMutableDictionary *dic in result) {
                ChoseCenterModel *model = [[ChoseCenterModel alloc] initWithDict:dic];
                [self.dataArray addObject:model];
            }
            
            
            [weakSelf.collectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
        
        
    }];
    
    
    
}


#pragma mark - 初始化
-(void)createCollectionView
{
    
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64 - 55) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
   
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChoseCenterCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
    
    
    
    
}


-(void)navigationInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 选择中心label
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80) / 2, 28, 80, 20) text:@"选择中心" font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    
    // 返回button
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [confirmButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:confirmButton];
    
}


#pragma mark - 点击事件
-(void)fanhui:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChoseCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    
    ChoseCenterModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.name;
    
   

    
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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    ChoseCenterModel *model = self.dataArray[indexPath.row];
    
    
    NSString *storeId = [NSString stringWithFormat:@"%ld" , (long)model.storeId];
    
       
        if (self.storeCenterNameBlock) {
            self.storeCenterNameBlock(model.name , storeId , model.storeId);
        }

    
    [self.navigationController popViewControllerAnimated:YES];
    
}


//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        return CGSizeMake(kScreenSize.width , 50);

    
    
}
//动态设置每个分区的缩进量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
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




@end
