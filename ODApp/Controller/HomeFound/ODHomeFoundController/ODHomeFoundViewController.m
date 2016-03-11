//
//  ODHomeFoundViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong Bracelet. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaarViewController.h"
#import "ODHomeFoundViewController.h"
#import "ODUserInformation.h"
#import "ODStorePlaceListModel.h"
#import "ODHomeInfoModel.h"

#define cellID @"ODBazaarExchangeSkillCollectionCell"

@interface ODHomeFoundViewController () {
    NSMutableDictionary *userInfoDic;
    AMapSearchAPI *_search;
    MAMapView *_mapView;
}
@end

@implementation ODHomeFoundViewController

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"首页";

    self.automaticallyAdjustsScrollViewInsets = NO;

    [ODUserInformation sharedODUserInformation].cityID = @"1";

    self.pictureArray = [[NSMutableArray alloc] init];
    self.pictureIdArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    self.cityListArray = [[NSMutableArray alloc] init];

    userInfoDic = [NSMutableDictionary dictionary];

    [self getLocationCityRequest];
    [self createCollectionView];
    [self getScrollViewRequest];
    [self getSkillChangeRequest];

    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [_mapView setZoomLevel:20 animated:YES];

    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;

    __weakSelf
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationLocationSuccessRefresh object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note)
    {
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self locationCity];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)refreshdata
{
    [self getSkillChangeRequest];
    [self getScrollViewRequest];
}

#pragma mark - 显示定位城市

- (void)locationCity {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithType:(ODBarButtonTypeImageLeft) target:self action:@selector(locationButtonClick:) image:[UIImage imageNamed:@"icon_locationNew"] highImage:nil textColor:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:[ODUserInformation sharedODUserInformation].locationCity];
}

#pragma mark - Request Data

#pragma mark - 定位城市数据请求

- (void)getLocationCityRequest {
    __weakSelf
    NSDictionary *parameter = @{@"region_name" : @""};
    [ODHttpTool getWithURL:ODUrlOtherCityList parameters:parameter modelClass:[ODLocationModel class] success:^(id model) {
                ODLocationModel *mode = [model result];
                weakSelf.cityListArray = mode.all;
                [weakSelf.collectionView reloadData];
            }
    failure:^(NSError *error) {
        
    }];
}


#pragma mark - 热门活动数据请求

- (void)getScrollViewRequest {
    __weakSelf
    NSDictionary *parameter = @{};
    [ODHttpTool getWithURL:ODUrlOtherHome parameters:parameter modelClass:[ODHomeInfoModel class] success:^(id model) {
        [weakSelf.pictureArray removeAllObjects];
        [weakSelf.pictureIdArray removeAllObjects];
        [weakSelf.pictureArray addObjectsFromArray:[[[model result] activitys] valueForKeyPath:@"detail_md5"]];
        [weakSelf.pictureIdArray addObjectsFromArray:[[[model result] activitys] valueForKeyPath:@"id"]];
        [weakSelf.collectionView reloadData];
    }
    failure:^(NSError *error) {

    }];
}

#pragma mark - 技能交换数据请求

- (void)getSkillChangeRequest {
    NSDictionary *parameter = @{};
    __weak typeof(self) weakSelf = self;

    [ODHttpTool getWithURL:ODUrlOtherHome parameters:parameter modelClass:[ODHomeInfoModel class] success:^(id model) {
        [weakSelf.dataArray removeAllObjects];
        ODHomeInfoModel *infoModel = [model result];
        for (ODHomeInfoSwapModel *swapModel in infoModel.swaps) {
            [weakSelf.dataArray addObject:swapModel];
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView reloadData];

    }
    failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}
#pragma mark - 获得默认的体验中心的Store_id

- (void)getDefaultCenterNameRequest
{
    NSDictionary *parameter = @{@"show_type" : @"1",@"call_array":@"1"};
    __weak typeof(self) weakSelf = self;
    [ODHttpTool getWithURL:ODUrlOtherStoreList parameters:parameter modelClass:[ODStorePlaceListModel class] success:^(ODStorePlaceListModelResponse *model)
    {
        ODStorePlaceListModel *listModel = model.result.firstObject;
        weakSelf.storeId = [@(listModel.id)stringValue];
        [weakSelf pushToPlace];
    }
    failure:^(NSError *error) {
        
    }];
}

#pragma mark - Create UICollectionView

- (void)createCollectionView {
    __weakSelf
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight - ODTabBarHeight) collectionViewLayout:self.flowLayout];

    self.flowLayout.minimumLineSpacing = 6;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

    [self.collectionView registerClass:[ODhomeViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"supple"];
    [self.collectionView registerClass:[ODHomeFoundFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"supple"];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODBazaarExchangeSkillCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshdata];
    }];

    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarExchangeSkillCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    ODHomeInfoSwapModel *model = self.dataArray[indexPath.row];
    [cell.headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.user[@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];

    [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.nickLabel.text = model.user[@"nick"];
    [cell showDatasWithModel:model];

    CGFloat width = kScreenSize.width > 320 ? 90 : 70;
    if (model.imgs_small.count) {
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        if (model.imgs_small.count == 4) {
            for (NSInteger i = 0; i < model.imgs_small.count; i++) {
                NSDictionary *dict = model.imgs_small[i];
                UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake((width + 5) * (i % 2), (width + 5) * (i / 2), width, width)];
                [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]] forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                imageButton.tag = 10 * indexPath.row + i;
                [cell.picView addSubview:imageButton];
            }
            cell.picViewConstraintHeight.constant = 2 * width + 5;
        }
        else {
            for (NSInteger i = 0; i < model.imgs_small.count; i++) {
                NSDictionary *dict = model.imgs_small[i];
                UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake((width + 5) * (i % 3), (width + 5) * (i / 3), width, width)];
                [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]] forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                imageButton.tag = 10 * indexPath.row + i;
                [cell.picView addSubview:imageButton];
            }
            cell.picViewConstraintHeight.constant = width + (width + 5) * ((model.imgs_small.count - 1) / 3);
        }
    }
    else {
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        cell.picViewConstraintHeight.constant = 0;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ODHomeInfoSwapModel *model = self.dataArray[indexPath.row];
    ODBazaarExchangeSkillDetailViewController *vc = [[ODBazaarExchangeSkillDetailViewController alloc] init];

    vc.swap_id = [NSString stringWithFormat:@"%@", model.swap_id];
    vc.nick = model.user[@"nick"];

    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    static NSString *viewId = @"supple";

    self.rsusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:viewId forIndexPath:indexPath];

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // Hot Activity
        self.rsusableView.scrollView.contentSize = CGSizeMake((kScreenSize.width - 15) * 7 / 12 * self.pictureArray.count, 0);
        self.rsusableView.scrollView.contentOffset = CGPointMake(0, 0);
        self.rsusableView.scrollView.delegate = self;
        self.rsusableView.scrollView.showsHorizontalScrollIndicator = NO;
        self.rsusableView.scrollView.showsVerticalScrollIndicator = NO;
        [self.rsusableView.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        for (int i = 0; i < self.pictureArray.count; i++) {
            UIButton *imageButton;
            if (i < self.pictureArray.count - 1) {
                imageButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenSize.width - 15) * 7 / 12 * i, 0, (kScreenSize.width - 15) * 7 / 12 - 8, 120)];
            }
            else {
                imageButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenSize.width - 15) * 7 / 12 * i, 0, (kScreenSize.width - 15) * 7 / 12, 120)];
            }
            [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:self.pictureArray[i]] forState:UIControlStateNormal];
            imageButton.tag = 100 + i;
            [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.rsusableView.scrollView addSubview:imageButton];
        }

        [self topEightButtonClick];
        [self searchCircleButtonClick];

        [self.rsusableView.gestureButton addTarget:self action:@selector(gestureButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        [self.rsusableView.moreSkillButton addTarget:self action:@selector(moreSkillButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self.rsusableView;
}

//动态计算cell的高度
- (CGFloat)returnHight:(ODHomeInfoSwapModel *)model {
    CGFloat width = kScreenSize.width > 320 ? 90 : 70;
    NSString *content = model.content;
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenSize.width - 93, 35) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine) attributes:dict context:nil].size;
    CGFloat baseHeight = size.height + 119;
    if (model.imgs_small.count == 0) {
        return baseHeight;
    }
    else if (model.imgs_small.count > 0 && model.imgs_small.count < 4) {
        return baseHeight + width;
    }
    else if (model.imgs_small.count >= 4 && model.imgs_small.count < 7) {
        return baseHeight + 2 * width + 5;
    }
    else if (model.imgs_small.count >= 7 && model.imgs_small.count < 9) {
        return baseHeight + 3 * width + 10;
    }
    else {
        return baseHeight + 3 * width + 10;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenSize.width, [self returnHight:self.dataArray[indexPath.row]]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(0, 551);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 40);
}

#pragma mark - AMapSearchDelegate

//地图定位成功回调
- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        _mapView.showsUserLocation = NO;
        [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];

        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeo.radius = 10000;
        regeo.requireExtension = YES;

        //发起逆地理编码
        [_search AMapReGoecodeSearch:regeo];

        //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];

        request.keywords = @"";
        request.types = @"";
        request.sortrule = 0;
        request.requireExtension = YES;

        //发起周边搜索
        [_search AMapPOIAroundSearch:request];
    }
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOIAroundSearchRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
//    for (AMapPOI *p in response.pois)
//    {
//        NSString *strPoi = [NSString stringWithFormat:@"%@", p.name];
//    }
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        NSString *cityResult;
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"%@", response.regeocode.addressComponent.city];
        if (result.length == 0) {
            result = [NSString stringWithFormat:@"%@", response.regeocode.addressComponent.province];
            if (result.length != 0) {
                cityResult = [result substringToIndex:[result length] - 1];
            }
        }
        else {
            cityResult = [result substringToIndex:[result length] - 1];
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"当前定位到%@", cityResult] message:nil preferredStyle:UIAlertControllerStyleAlert];
        __weakSelf
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [ODUserInformation sharedODUserInformation].locationCity = cityResult;

            for (NSDictionary *cityInformation in weakSelf.cityListArray) {
                if ([[ODUserInformation sharedODUserInformation].locationCity isEqualToString:cityInformation[@"name"]]) {
                    [ODUserInformation sharedODUserInformation].cityID = cityInformation[@"id"];
                }
            }
            [weakSelf locationCity];
            [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationLocationSuccessRefresh object:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
            [ODUserInformation sharedODUserInformation].locationCity = [NSString stringWithFormat:@"全国"];
            [ODUserInformation sharedODUserInformation].cityID = @"1";
            [weakSelf locationCity];

        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - Action
#pragma mark - 定位按钮点击事件

- (void)locationButtonClick:(UIButton *)button {
    ODLocationController *vc = [[ODLocationController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 顶部8个按钮点击事件
- (void)topEightButtonClick
{
    __weakSelf
    self.rsusableView.topEightButtonTag = ^(NSInteger tag) {
        if (tag == 100) {
            weakSelf.tabBarController.selectedIndex = 1;
            
        }
        else if (tag == 101) {
            if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
                ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
                [weakSelf presentViewController:vc animated:YES completion:nil];
            }
            else {
                if (weakSelf.storeId.integerValue == 0) {
                    [weakSelf getDefaultCenterNameRequest];
                }
                else  {
                    [weakSelf pushToPlace];
                }
            }
        }
        else if (tag == 102) {
            ODFindFavorableController *vc = [[ODFindFavorableController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else if (tag == 103) {
            if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
                ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc] init];
                [weakSelf.navigationController presentViewController:personalCenter animated:YES completion:nil];
            }
            else {
                ODFindJobController *vc = [[ODFindJobController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
        else if (tag == 104) {
            [weakSelf giveCommumityContent:nil andBbsType:4];
        }
        else if (tag == 105) {
            weakSelf.tabBarController.selectedIndex = 2;
            ODBazaarViewController *vc = weakSelf.tabBarController.childViewControllers[2].childViewControllers[0];
            vc.index = 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationShowBazaar object:nil];
        }
        else if (tag == 106) {
            weakSelf.tabBarController.selectedIndex = 2;
            ODBazaarViewController *vc = weakSelf.tabBarController.childViewControllers[2].childViewControllers[0];
            vc.index = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationReleaseSkill object:nil];
        }
        else if (tag == 107) {
            ODFindFavorableController *vc = [[ODFindFavorableController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
}

#pragma mark - 热门活动图片点击事件

- (void)imageButtonClick:(UIButton *)button {
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc] init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
    }
    else {
        ODNewActivityDetailViewController *vc = [[ODNewActivityDetailViewController alloc] init];
        vc.acitityId = [self.pictureIdArray[button.tag - 100] intValue];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 寻圈子点击事件
- (void)searchCircleButtonClick{
    __weakSelf
    self.rsusableView.searchCircleButtonTag = ^(NSInteger tag){
        
        NSArray *bbsMarkArray = @[ @"情感", @"搞笑", @"影视", @"二次元", @"生活", @"明星", @"爱美", @"宠物" ];
        [weakSelf giveCommumityContent:bbsMarkArray[tag - 1000] andBbsType:5];
    };
}
#pragma mark - 加入更多圈子点击事件

- (void)gestureButtonClick:(UIButton *)button {
    [self giveCommumityContent:@"社区" andBbsType:5];
}

#pragma mark - 寻圈子跳转刷新

- (void)giveCommumityContent:(NSString *)bbsMark andBbsType:(float)bbsType {
    self.tabBarController.selectedIndex = 3;
    ODCommumityViewController *vc = self.tabBarController.selectedViewController.childViewControllers[0];
    vc.bbsMark = bbsMark;
    vc.bbsType = bbsType;
    NSLog(@"%@", bbsMark);
    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationSearchCircle object:nil];
}

#pragma mark - 用户头像点击事件

- (void)headButtonClick:(UIButton *)button {
    ODBazaarExchangeSkillCollectionCell *cell = (ODBazaarExchangeSkillCollectionCell *) button.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    vc.open_id = model.user[@"open_id"];
    
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:model.user[@"open_id"]]) {
        
    }
    else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 了解更多技能点击事件

- (void)moreSkillButtonClick:(UIButton *)button {
    self.tabBarController.selectedIndex = 2;
    ODBazaarViewController *vc = self.tabBarController.childViewControllers[2].childViewControllers[0];
    vc.index = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationReleaseSkill object:nil];
}

#pragma mark - 技能交换cell图片点击事件

- (void)imageButtonClicked:(UIButton *)button {
    ODBazaarExchangeSkillCollectionCell *cell = (ODBazaarExchangeSkillCollectionCell *) button.superview.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc] init];
    picController.photos = model.imgs_small;
    picController.selectedIndex = button.tag - 10 * indexPath.row;
    picController.skill = @"skill";
    [self presentViewController:picController animated:YES completion:nil];
}


- (void)pushToPlace
{
    ODPrecontractViewController *vc = [[ODPrecontractViewController alloc] init];
    vc.storeId = [NSString stringWithFormat:@"%@", self.storeId];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 移除通知

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
