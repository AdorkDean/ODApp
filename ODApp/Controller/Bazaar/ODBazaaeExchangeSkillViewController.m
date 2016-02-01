//
//  ODBazaaeExchangeSkillViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBazaaeExchangeSkillViewController.h"

#define cellID @"ODBazaarExchangeSkillCollectionCell"

@interface ODBazaaeExchangeSkillViewController ()

@end

@implementation ODBazaaeExchangeSkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    [self createRequest];
    [self joiningTogetherParmeters];
}

-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc]init];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    self.page = 1;
    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%ld",self.page],@"city_id":@"0"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kBazaarExchangeSkillUrl parameter:signParameter];
}

-(void)downLoadDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    __weakSelf
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *result = dict[@"result"];
            for (NSDictionary *itemDict in result) {
                ODBazaarExchangeSkillModel *model = [[ODBazaarExchangeSkillModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf createCollectionView];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64, kScreenSize.width, kScreenSize.height - 64 - 55) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODBazaarExchangeSkillCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarExchangeSkillCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    [cell.headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.user[@"avatar"]] forState:UIControlStateNormal];
    cell.nickLabel.text = model.user[@"nick"];
    [cell showDatasWithModel:model];
    CGFloat height = [ODHelp textHeightFromTextString:model.content width:kScreenSize.width-115 fontSize:13];
    cell.contentLabelConstraintHeight.constant = height;
    if (model.imgs_small.count) {
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        if (model.imgs_small.count==4) {
            for (NSInteger i = 0; i < model.imgs_small.count; i++) {
                NSDictionary *dict = model.imgs_small[i];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((90+5)*(i%2), (90+5)*(i/2), 90, 90)];
                [imageView sd_setImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]]];
                [cell.picView addSubview:imageView];
            }
            cell.picViewConstraintHeight.constant = 195;
        }else{
            for (NSInteger i = 0;i < model.imgs_small.count ; i++) {
                NSDictionary *dict = model.imgs_small[i];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((90+5)*(i%3), (90+5)*(i/3), 90, 90)];
                [imageView sd_setImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]]];
                [cell.picView addSubview:imageView];
            }
            cell.picViewConstraintHeight.constant = 90+(90+5)*(model.imgs_small.count/3);
        }
    }else{
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        cell.picViewConstraintHeight.constant = 0;
    }

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, [self returnHight:self.dataArray[indexPath.row]]);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODBazaarExchangeSkillDetailViewController *detailControler = [[ODBazaarExchangeSkillDetailViewController alloc]init];
    detailControler.swap_id = [NSString stringWithFormat:@"%@",model.swap_id];
    [self.navigationController pushViewController:detailControler animated:YES];
    
}

//动态计算cell的高度
-(CGFloat)returnHight:(ODBazaarExchangeSkillModel *)model
{
    if (model.imgs_small.count==0) {
        return 148+[ODHelp textHeightFromTextString:model.content width:kScreenSize.width-115 fontSize:13];
    }else if (model.imgs_small.count>0&&model.imgs_small.count<4){
        return 148+[ODHelp textHeightFromTextString:model.content width:kScreenSize.width-115 fontSize:13]+90;
    }else if (model.imgs_small.count>=4&&model.imgs_small.count<7){
        return 148+[ODHelp textHeightFromTextString:model.content width:kScreenSize.width-115 fontSize:13]+185;
    }else if (model.imgs_small.count>=7&&model.imgs_small.count<9){
        return 148+[ODHelp textHeightFromTextString:model.content width:kScreenSize.width-115 fontSize:13]+280;
    }else{
        return 148+[ODHelp textHeightFromTextString:model.content width:kScreenSize.width-115 fontSize:13]+280;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
