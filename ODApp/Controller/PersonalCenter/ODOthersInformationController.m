//
//  ODOthersInformationController.m
//  ODApp
//
//  Created by 代征钏 on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOthersInformationController.h"

@interface ODOthersInformationController ()

@end

@implementation ODOthersInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigation];
    [self createRequest];
}

- (void)navigation
{

    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"#f3f3f3"];
    [self.view addSubview:self.headView];
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 160) / 2, 28, 160, 20) text:@"个人中心" font:17 alignment:@"center" color:@"#000000" alpha:1];
    [self.headView addSubview:label];
    
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 28, 32, 20) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    [backButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
}

- (void)backButtonClick:(UIButton *)button{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createRequest{

    self.manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parameter = @{@"open_id":self.open_id};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    [self.manager GET:kOthersInformationUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSMutableDictionary *dict = responseObject[@"result"];
        self.model = [[ODUserModel alloc] initWithDict:dict];
        
        [self createCollectionView];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
    }];
}

- (void)createCollectionView
{

    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 20) collectionViewLayout:self.flowLayout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [ODColorConversion colorWithHexString:@"#d9d9d9" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandFirstCell" bundle:nil] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandSecondCell" bundle:nil] forCellWithReuseIdentifier:@"second"];

    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        ODLandFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        
        cell.userImageView.layer.masksToBounds = YES;
        cell.userImageView.layer.cornerRadius = 35;
        cell.userImageView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.userImageView.layer.borderWidth = 1;
        
        
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar]];
        [cell.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:self.model.qrcode]];
        
        [cell.qrcodeImageView removeFromSuperview];
        [cell.centerImageView removeFromSuperview];
        
        cell.nickNameLabel.text = self.model.nick;
        cell.signatureLabel.text = self.model.sign;
        
        return cell;
        
    }else{
        ODLandSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        
        if (indexPath.section == 1) {
            cell.titleLabel.text = @"他的中心预约";
            
        }else if (indexPath.section == 2) {
            cell.titleLabel.text = @"他发表的话题";
            
        }else if (indexPath.section == 3) {
            cell.titleLabel.text = @"他发起的任务";
        }else if (indexPath.section == 4) {
            cell.titleLabel.text = @"他收到的评价";
        }
        return cell;        
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        
    }else if (indexPath.section == 1){
        
        ODMyOrderRecordController *vc = [[ODMyOrderRecordController alloc] init];
        
        vc.open_id = self.model.open_id;
        vc.centerTitle = @"他的中心预约";
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 2) {
        ODOtherTopicViewController *vc = [[ODOtherTopicViewController alloc]init];
        vc.open_id = self.open_id;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 3) {
        
        ODOtherTaskController *vc = [[ODOtherTaskController alloc] init];
        
        vc.openId = self.model.open_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (indexPath.section == 4) {
        
        ODUserEvaluationController *vc = [[ODUserEvaluationController alloc] init];
        vc.typeTitle = @"他收到的评价";
        vc.openId = self.model.open_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenSize.width , 90);
    }else {
        return CGSizeMake(kScreenSize.width , 30);
    }
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
    return CGSizeMake(0,0);
}

//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
   
    return CGSizeMake(0, 5);
}



- (void)viewWillAppear:(BOOL)animated
{
    
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
    
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
