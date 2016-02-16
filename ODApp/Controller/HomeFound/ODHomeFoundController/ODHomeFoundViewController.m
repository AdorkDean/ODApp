//
//  ODHomeFoundViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODHomeFoundViewController.h"
#import "ODUserInformation.h"


#define cellID @"ODBazaarExchangeSkillCollectionCell"
@interface ODHomeFoundViewController ()
{
    NSMutableDictionary *userInfoDic;
}
@end

@implementation ODHomeFoundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithType:(ODBarButtonTypeImageLeft) target:self action:@selector(locationButtonClick:) image:[UIImage imageNamed:@"icon_location"] highImage:nil textColor:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:self.locationButton.titleLabel.text];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pictureArray = [[NSMutableArray alloc] init];
    self.titleArray = [[NSMutableArray alloc] init];
    self.pictureDetailArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    userInfoDic = [NSMutableDictionary dictionary];
    
    [self createCollectionView];
    [self getScrollViewRequest];
    [self getSkillChangeRequest];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshdata];
        
    }];
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
////    [self getSkillChangeRequest];
//}

- (void)refreshdata
{
    
    [self getSkillChangeRequest];
}

-(NSMutableArray *)mySort:(NSMutableArray *)mArray
{
    
    NSInteger i ,j ,count;
    NSObject *temp;
    count = mArray.count+1;
    for (i = count - 1; i >= 0; i--) {
        for (j= 0 ; j < i - 1 ; j++) {
            ODCommunityModel *model1 = [self.dataArray objectAtIndex:j];
            ODCommunityModel *model2 = [self.dataArray objectAtIndex:j+1];
            if ([model1.view_num compare:model2.view_num]<0) {
                temp = [mArray objectAtIndex:j];
                [mArray replaceObjectAtIndex:j withObject:[mArray objectAtIndex:j+1]];
                [mArray replaceObjectAtIndex:j+1 withObject:temp];
            }
        }
    }
    return mArray;
}

#pragma mark - Location Button

- (void)CreateLocationButtonAction
{

    [self.locationButton addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Request Data

// Hot Activity
- (void)getScrollViewRequest
{
    
    self.managers = [AFHTTPRequestOperationManager manager];
    self.managers.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"position":@"3",@"store_id":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weak typeof (self)weakSelf = self;
    [self.managers GET:kHomeFoundPictureUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            [weakSelf.pictureArray removeAllObjects];
            [weakSelf.titleArray removeAllObjects];
            [weakSelf.pictureDetailArray removeAllObjects];
            
            NSMutableArray *result = dict[@"result"];
            
            for (NSDictionary *itemDict in result) {
                
                NSString *img_url = itemDict[@"img_url"];
                NSString *banner_url = itemDict[@"banner_url"];
                NSString *title = itemDict[@"title"];
                
                [weakSelf.titleArray addObject:title];
                [weakSelf.pictureArray addObject:img_url];
                [weakSelf.pictureDetailArray addObject:banner_url];
            }
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        
    }];
}

// Skill Change
- (void)getSkillChangeRequest
{
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"city_id":@"0",@"page":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kBazaarExchangeSkillUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
        [weakSelf.collectionView.mj_header endRefreshing];
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
        
    }];
}




#pragma mark - Action

// Location Button
- (void)locationButtonClick:(UIButton *)button
{
    
    ODLocationController *vc = [[ODLocationController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//Toop Eight Button
- (void)findActivityButtonClick:(UIButton *)button
{

    self.tabBarController.selectedIndex = 1;
}

- (void)orderPlaceButtonClick:(UIButton *)button
{
    
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        ODCenterYuYueController *vc = [[ODCenterYuYueController alloc] init];
        
        vc.centerName = @"上海第二工业大学体验中心";
        vc.phoneNumber = @"13524776010";
        vc.storeId = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)findFavorableButtonClick:(UIButton *)button
{
    
    
}

- (void)findJobButtonClick:(UIButton *)button
{
    
    
}

- (void)searchCircleButtonClick:(UIButton *)button
{
    
    self.tabBarController.selectedIndex = 3;
}

- (void)searchHelpButtonClick:(UIButton *)button
{
    
    self.tabBarController.selectedIndex = 2;
}

- (void)changeSkillButtonClick:(UIButton *)button
{
    
    
}

- (void)moreButtonClick:(UIButton *)button
{
    
    
}

//Hot Activity
- (void)imageButtonClick:(UIButton *)button
{

    ODCenterIntroduceController *vc = [[ODCenterIntroduceController alloc] init];
    
    vc.activityTitle = self.titleArray[button.tag - 100];
    vc.webUrl = self.pictureDetailArray[button.tag - 100];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//Search Circle
- (void)emotionButtonClick:(UIButton *)button
{
    
    
}

- (void)funnyButtonClick:(UIButton *)button
{
    
    
}

- (void)moviesButtonClick:(UIButton *)button
{
    
    
}

- (void)quadraticButtonClick:(UIButton *)button
{
    
    
}

- (void)lifeButtonClick:(UIButton *)button
{
    
    
}

- (void)starButtonClick:(UIButton *)button
{
    
    
}

- (void)beautifulButtonClick:(UIButton *)button
{
    
    
}

- (void)petButtonClick:(UIButton *)button
{
    
    
}

- (void)gestureButtonClick:(UIButton *)button
{
    
    self.tabBarController.selectedIndex = 3;
}

// Skill Change
- (void)headButtonClick:(UIButton *)button
{
    
    ODCommunityCollectionCell *cell = (ODCommunityCollectionCell *)button.superview.superview;
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    ODCommunityModel *model = self.dataArray[indexpath.row];
    NSString *userId = [NSString stringWithFormat:@"%@",model.user_id];
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    vc.open_id = [userInfoDic[userId]open_id];
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:[userInfoDic[userId]open_id]]) {
        
    }else{
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)moreSkillButtonClick:(UIButton *)button
{

    self.tabBarController.selectedIndex = 2;
}

#pragma mark - CreateUICollectionView

- (void)createCollectionView
{

    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight-ODTabBarHeight) collectionViewLayout:self.flowLayout];
    
    self.flowLayout.minimumInteritemSpacing = 5;
    self.flowLayout.minimumLineSpacing = 5;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.collectionView registerClass:[ODhomeViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"supple"];
   
    [self.collectionView registerClass:[ODHomeFoundFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"supple"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODBazaarExchangeSkillCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ODBazaarExchangeSkillCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    [cell.headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.user[@"avatar"]] forState:UIControlStateNormal];
    [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.nickLabel.text = model.user[@"nick"];
    [cell showDatasWithModel:model];
    CGFloat width=kScreenSize.width>320?90:70;
    if (model.imgs_small.count) {
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        if (model.imgs_small.count==4) {
            for (NSInteger i = 0; i < model.imgs_small.count; i++) {
                NSDictionary *dict = model.imgs_small[i];
                UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake((width+5)*(i%2), (width+5)*(i/2), width, width)];
                [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]] forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                imageButton.tag = 10*indexPath.row+i;
                [cell.picView addSubview:imageButton];
            }
            cell.picViewConstraintHeight.constant = 2*width+5;
        }else{
            for (NSInteger i = 0;i < model.imgs_small.count ; i++) {
                NSDictionary *dict = model.imgs_small[i];
                UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake((width+5)*(i%3), (width+5)*(i/3), width, width)];
                [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]] forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                imageButton.tag = 10*indexPath.row+i;
                [cell.picView addSubview:imageButton];
            }
            cell.picViewConstraintHeight.constant = width+(width+5)*(model.imgs_small.count/3);
        }
    }else{
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        cell.picViewConstraintHeight.constant = 0;
    }

    
    return cell;
}

-(void)imageButtonClicked:(UIButton *)button
{
    ODBazaarExchangeSkillCollectionCell *cell = (ODBazaarExchangeSkillCollectionCell *)button.superview.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc]init];
    picController.photos = model.imgs_small;
    picController.selectedIndex = button.tag-10*indexPath.row;
    picController.skill = @"skill";
    [self.navigationController pushViewController:picController animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODBazaarExchangeSkillDetailViewController *detailControler = [[ODBazaarExchangeSkillDetailViewController alloc]init];
    detailControler.swap_id = [NSString stringWithFormat:@"%@",model.swap_id];
    [self.navigationController pushViewController:detailControler animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *viewId = @"supple";
    
    self.rsusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:viewId forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        self.rsusableView.scrollView.contentSize = CGSizeMake((kScreenSize.width - 15) * 2/3 * self.pictureArray.count , 0);
        self.rsusableView.scrollView.contentOffset = CGPointMake((kScreenSize.width - 15) * 2/3, 0);
        //    self.rsusableView.scrollView.pagingEnabled = YES;
        self.rsusableView.scrollView.delegate = self;
        self.rsusableView.scrollView.showsHorizontalScrollIndicator = NO;
        self.rsusableView.scrollView.showsVerticalScrollIndicator = NO;
        
        for (int i = 0; i < self.pictureArray.count; i++) {
            
            UIButton *imageButton;
            if (i < self.pictureArray.count - 1) {
                imageButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenSize.width - 15) * 2/3 * i, 0, (kScreenSize.width - 15) * 2/3 - 8, 120)];
            }else{
                imageButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenSize.width - 15) * 2/3 * i, 0, (kScreenSize.width - 15) * 2/3, 120)];
            }
            [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.pictureArray[i]] forState:UIControlStateNormal];
            
            imageButton.tag = 100 + i;
            [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.rsusableView.scrollView addSubview:imageButton];
        }
        
        // Top Eight Button
        [self.rsusableView.findActivityButton addTarget:self action:@selector(findActivityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.orderPlaceButton addTarget:self action:@selector(orderPlaceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.findFavorableButton addTarget:self action:@selector(findFavorableButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.findJobButton addTarget:self action:@selector(findJobButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.searchCircleButton addTarget:self action:@selector(searchCircleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.searchHelpButton addTarget:self action:@selector(searchHelpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.changeSkillButton addTarget:self action:@selector(changeSkillButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // Search Circle
        [self.rsusableView.emotionButton addTarget:self action:@selector(emotionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.funnyButton addTarget:self action:@selector(funnyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.moviesButton addTarget:self action:@selector(moviesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.quadraticButton addTarget:self action:@selector(quadraticButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.lifeButton addTarget:self action:@selector(lifeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.lifeButton addTarget:self action:@selector(lifeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.beautifulButton addTarget:self action:@selector(beautifulButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rsusableView.petButton addTarget:self action:@selector(petButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.rsusableView.gestureButton addTarget:self action:@selector(gestureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
    
        [self.rsusableView.moreSkillButton addTarget:self action:@selector(moreSkillButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self.rsusableView;
}

//动态计算cell的高度
-(CGFloat)returnHight:(ODBazaarExchangeSkillModel *)model
{
    CGFloat width=kScreenSize.width>320?90:70;
    if (model.imgs_small.count==0) {
        return 180;
    }else if (model.imgs_small.count>0&&model.imgs_small.count<4){
        return 180+width;
    }else if (model.imgs_small.count>=4&&model.imgs_small.count<7){
        return 180+2*width+5;
    }else if (model.imgs_small.count>=7&&model.imgs_small.count<9){
        return 180+3*width+10;
    }else{
        return 180+3*width+10;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width, [self returnHight:self.dataArray[indexPath.row]]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(0, 1 + CGRectGetMaxY(self.rsusableView.changeSkillView.frame));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{

    return CGSizeMake(0, 42);
}




@end
