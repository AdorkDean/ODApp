//
//  ODHomeFoundViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODHomeFoundViewController.h"
#import "ODUserInformation.h"
#import "ODHomeInfoModel.h"

#define cellID @"ODBazaarExchangeSkillCollectionCell"
@interface ODHomeFoundViewController ()
{
    NSMutableDictionary *userInfoDic;
    AMapSearchAPI *_search;
    MAMapView *_mapView;
}
@end

@implementation ODHomeFoundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weakSelf
    self.navigationItem.title = @"首页";
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pictureArray = [[NSMutableArray alloc] init];

    self.dataArray = [[NSMutableArray alloc] init];
    userInfoDic = [NSMutableDictionary dictionary];
    
    [self createCollectionView];
    [self getScrollViewRequest];
    [self getSkillChangeRequest];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshdata];
        
    }];
    
        [MAMapServices sharedServices].apiKey = @"82b3b9feaca8b2c33829a156672a5fd0";
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [_mapView setZoomLevel:20 animated:YES];
    
        //配置用户Key
        [AMapSearchServices sharedServices].apiKey = @"82b3b9feaca8b2c33829a156672a5fd0";
        //初始化检索对象
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self locationCity];
}

- (void)locationCity
{

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithType:(ODBarButtonTypeImageLeft) target:self action:@selector(locationButtonClick:) image:[UIImage imageNamed:@"icon_location"] highImage:nil textColor:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:[ODUserInformation sharedODUserInformation].locationCity];
}

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
    NSDictionary *parameter = @{@"city_id":@"0"};
    __weakSelf
    [ODHttpTool getWithURL:ODHomeFoundUrl parameters:parameter modelClass:[ODHomeInfoModel class] success:^(id model)
    {
        weakSelf.pictureArray = [[[model result]activitys]valueForKeyPath:@"detail_md5"];
        weakSelf.pictureIdArray = [[[model result]activitys] valueForKeyPath:@"id"];
        [weakSelf.collectionView reloadData];
    }
                   failure:^(NSError *error)
     {
        
    }];
}

// Skill Change



- (void)getSkillChangeRequest

{
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"city_id":@"0"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:ODHomeChangeSkillUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            NSArray *swaps = result[@"swaps"];
            for (NSDictionary *itemDict in swaps) {
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
    
    ODFindJobController *vc = [[ODFindJobController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    self.tabBarController.selectedIndex = 2;
}

- (void)moreButtonClick:(UIButton *)button
{
    
    
}

//Hot Activity
- (void)imageButtonClick:(UIButton *)button
{

    ODNewActivityDetailViewController *vc = [[ODNewActivityDetailViewController alloc] init];
    
    
    vc.acitityId = [self.pictureIdArray[button.tag - 100] intValue];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//Search Circle
- (void)emotionButtonClick:(UIButton *)button
{
    
    self.tabBarController.selectedIndex = 3;
}

- (void)funnyButtonClick:(UIButton *)button
{
    
    self.tabBarController.selectedIndex = 3;
}

- (void)moviesButtonClick:(UIButton *)button
{
    
    self.tabBarController.selectedIndex = 3;
}

- (void)quadraticButtonClick:(UIButton *)button
{
    
    self.tabBarController.selectedIndex = 3;
}

- (void)lifeButtonClick:(UIButton *)button
{
    
    self.tabBarController.selectedIndex = 3;
}

- (void)starButtonClick:(UIButton *)button
{
    
    self.tabBarController.selectedIndex = 3;
}

- (void)beautifulButtonClick:(UIButton *)button
{
    
    self.tabBarController.selectedIndex = 3;
}

- (void)petButtonClick:(UIButton *)button
{
    
    self.tabBarController.selectedIndex = 3;
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
            [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:self.pictureArray[i]] forState:UIControlStateNormal];
            
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
        [self.rsusableView.starButton addTarget:self action:@selector(starButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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

//地图定位成功回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
        _mapView.showsUserLocation = NO;
        [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];

        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeo.radius = 10000;
        regeo.requireExtension = YES;

        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeo];

        //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];

        // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
        // POI的类型共分为20种大类别，分别为：
        // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
        // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
        // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
        request.keywords = @"";
        request.types = @"";
        request.sortrule = 0;
        request.requireExtension = YES;

        //发起周边搜索
        [_search AMapPOIAroundSearch: request];
    }
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOIAroundSearchRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
    for (AMapPOI *p in response.pois) {
        NSString *strPoi = [NSString stringWithFormat:@"%@", p.name];

        NSLog(@"strPoi ->____%@" , strPoi);
    }
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"%@", response.regeocode.addressComponent.city];
        if (result.length == 0) {
            result = [NSString stringWithFormat:@"%@", response.regeocode.addressComponent.province];
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"当前定位到%@",result] message:nil preferredStyle:UIAlertControllerStyleAlert];
    
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [ODUserInformation sharedODUserInformation].locationCity = result;
            [self locationCity];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [ODUserInformation sharedODUserInformation].locationCity = [NSString stringWithFormat:@"全国"];
            [self locationCity];
        }]];

        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
