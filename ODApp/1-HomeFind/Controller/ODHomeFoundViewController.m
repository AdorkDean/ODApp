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
#import "ODHomeButton.h"
#define cellID @"ODBazaarExchangeSkillCollectionCell"

// 循环cell标识
static NSString * const exchangeCellId = @"exchangeCell";

@interface ODHomeFoundViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *userInfoDic;
    AMapSearchAPI *_search;
    MAMapView *_mapView;
}

@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIView *topClassView;
@property(nonatomic, strong) UIView *activityView;
@property(nonatomic, strong) UIView *findCircleView;

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) ODCommunityBbsModel *model;
@property(nonatomic, strong) UITableView *tableView;

// 头视图
@property(nonatomic, strong) ODhomeViewCollectionReusableView *rsusableView;
// 尾视图
@property(nonatomic, strong) ODHomeFoundFooterView *footerView;
// 热门活动
@property(nonatomic, strong) NSMutableArray *pictureArray;
@property(nonatomic, strong) NSMutableArray *pictureIdArray;
// 技能交换
@property(nonatomic, strong) NSMutableArray *dataArray;
// 城市列表
@property(nonatomic, strong) NSArray *cityListArray;

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

    [self createHeaderView];
    [self createFooterView];
    [self getLocationCityRequest];
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
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationLocationSuccessRefresh object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note){
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self locationCity1];
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

- (void)locationCity1 {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithType:(ODBarButtonTypeImageLeft) target:self action:@selector(locationButtonClick:) image:[UIImage imageNamed:@"icon_locationNew"] highImage:nil textColor:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:[ODUserInformation sharedODUserInformation].locationCity];
}

#pragma mark - Request Data

#pragma mark - 定位城市数据请求

- (void)getLocationCityRequest {
    __weakSelf
    NSDictionary *parameter = @{@"region_name" : @""};
    [ODHttpTool getWithURL:ODUrlOtherCityList parameters:parameter modelClass:[ODLocationModel class] success:^(id model) {
        weakSelf.cityListArray = [[model result] all];
            [weakSelf.tableView reloadData];
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
        for (ODBazaarExchangeSkillModel *skillModel in infoModel.swaps) {
            [weakSelf.dataArray addObject:skillModel];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
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
    [ODHttpTool getWithURL:ODUrlOtherStoreList parameters:parameter modelClass:[ODStorePlaceListModel class] success:^(ODStorePlaceListModelResponse *model){
        ODStorePlaceListModel *listModel = model.result.firstObject;
        weakSelf.storeId = [@(listModel.id)stringValue];
        [weakSelf pushToPlace];
    }
    failure:^(NSError *error) {
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - ODNavigationHeight - ODTabBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // 取消分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODBazaarExchangeSkillCell class]) bundle:nil] forCellReuseIdentifier:exchangeCellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ODBazaarExchangeSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:exchangeCellId];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    // 停止刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    // 点击后取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODBazaarExchangeSkillDetailViewController *detailControler = [[ODBazaarExchangeSkillDetailViewController alloc] init];
    detailControler.swap_id = [NSString stringWithFormat:@"%d", model.swap_id];
    detailControler.nick = model.user.nick;
    [self.navigationController pushViewController:detailControler animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    return model.rowHeight;
}

-(void)createHeaderView{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 200)];
    self.headerView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    [self.view addSubview:self.headerView];
    [self createTopClassView];
}

-(void)createTopClassView{
    
    self.topClassView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 147.5)];
    self.topClassView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.headerView addSubview:self.topClassView];
    
    NSArray *array = @[@"找活动",@"约场地",@"找优惠",@"找兼职",@"寻圈子",@"求帮助",@"换技能",@"更多"];
    NSArray *imageArray = @[@"icon_activity",@"icon_field",@"icon_Discount",@"icon_Work-study",@"icon_circle_big",@"icon_help",@"icon_Skill_big",@"icon_more"];
    CGFloat width = (KScreenWidth-2*ODLeftMargin)/4;
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [ODHomeButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ODLeftMargin+width*(i%4), 65*(i/4), width, 65);
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.headerView addSubview:button];
    }
    [self createActivityView];
}

-(void)createActivityView{
    self.activityView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topClassView.frame)+6, kScreenSize.width, 160)];
    self.activityView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.headerView addSubview:self.activityView];
    
    UIImageView *hotActivityImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ODLeftMargin, 5, 17, 16)];
    hotActivityImageView.image = [UIImage imageNamed:@"icon_Hot activityNew"];
    [self.activityView addSubview:hotActivityImageView];
    
    UILabel *hotActivityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hotActivityImageView.frame) + 7.5, 5, 60, 20)];
    hotActivityLabel.text = @"热门活动";
    hotActivityLabel.font = [UIFont systemFontOfSize:14];
    hotActivityLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    [self.activityView addSubview:hotActivityLabel];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(17.5, CGRectGetMaxY(hotActivityLabel.frame) + 10, (kScreenSize.width - 17.5), 110)];
    [self.activityView addSubview:scrollView];
    self.headerView.frame = CGRectMake(0, 0, kScreenSize.width, self.topClassView.frame.size.height+self.activityView.frame.size.height+12);
    [self createFindCircleView];
}

-(void)createFindCircleView{
    
    self.findCircleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.activityView.frame)+6, kScreenSize.width, 198)];
    self.findCircleView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.headerView addSubview:self.findCircleView];
    
    UIImageView *findCircleImage = [[UIImageView alloc]initWithFrame:CGRectMake(ODLeftMargin, 10, 15, 12.5)];
    findCircleImage.image = [UIImage imageNamed:@"icon_circle_smallNew"];
    [self.findCircleView addSubview:findCircleImage];

    UILabel *findCircleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(findCircleImage.frame)+ 7.5, 5, 60, 20)];
    findCircleLabel.text = @"寻圈子";
    findCircleLabel.font = [UIFont systemFontOfSize:14];
    findCircleLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    [self.findCircleView addSubview:findCircleLabel];
    
    UIView *findCircleBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(findCircleLabel.frame) + 10, kScreenSize.width, 130)];
    findCircleBtnView.backgroundColor = [UIColor colorWithHexString:@"#ffd802" alpha:1];
    [self.findCircleView addSubview:findCircleBtnView];

    NSArray *array = @[ @"button_emotion", @"button_Funny", @"button_Movies", @"button_quadratic element", @"button_Life", @"button_Star", @"button_beautiful", @"button_Pet" ];
    
    CGFloat width = kScreenSize.width/4;
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*(i%4), 65*(i/4), width, 65);
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [findCircleBtnView addSubview:button];
        
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenSize.width -180)/2, CGRectGetMaxY(findCircleBtnView.frame)+14, 12, 8)];
    imageView.image = [UIImage imageNamed:@"icon_gesture"];
    [self.findCircleView addSubview:imageView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((kScreenSize.width - 160) / 2, CGRectGetMaxY(findCircleBtnView.frame) + 8, 160, 20)];
    [button setTitle:@"想加入更多圈子么？ 憋说话，点我！" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#555555" alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:9];
    [self.findCircleView addSubview:button];
    self.headerView.frame = CGRectMake(0, 0, kScreenSize.width, self.topClassView.frame.size.height+self.activityView.frame.size.height+self.findCircleView.frame.size.height+18);
     self.tableView.tableHeaderView = self.headerView;
}

-(void)createFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 28.5)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenSize.width-180)/2, 10.25, 12, 8)];
    imageView.image = [UIImage imageNamed:@"icon_gesture"];
    [footerView addSubview:imageView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((kScreenSize.width-160)/2, 4.25, 160, 20)];
    [button setTitle:@"想了解更多技能？ 憋说话，点我！" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#555555" alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:9];
    [footerView addSubview:button];
    self.tableView.tableFooterView = footerView;
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
//    通过 AMapPOISearchResponse 对象处理搜索结果
//    for (AMapPOI *p in response.pois){
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

            for (ODCityNameModel *cityInformation in weakSelf.cityListArray) {
                
                if ([[ODUserInformation sharedODUserInformation].locationCity isEqualToString:cityInformation.name]) {
                    [ODUserInformation sharedODUserInformation].cityID = cityInformation.id;
                }
            }
            [weakSelf locationCity1];
            [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationLocationSuccessRefresh object:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
            [ODUserInformation sharedODUserInformation].locationCity = [NSString stringWithFormat:@"全国"];
            [ODUserInformation sharedODUserInformation].cityID = @"1";
            [weakSelf locationCity1];

        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - 定位按钮 点击事件
- (void)locationButtonClick:(UIButton *)button {
    ODLocationController *vc = [[ODLocationController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 顶部8个按钮 点击事件
- (void)topEightButtonClick {
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

#pragma mark - 热门活动图片 点击事件
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

#pragma mark - 寻圈子 点击事件
- (void)searchCircleButtonClick{
    __weakSelf
    self.rsusableView.searchCircleButtonTag = ^(NSInteger tag){
        NSArray *bbsMarkArray = @[ @"情感", @"搞笑", @"影视", @"二次元", @"生活", @"明星", @"爱美", @"宠物" ];
        [weakSelf giveCommumityContent:bbsMarkArray[tag - 1000] andBbsType:5];
    };
}
#pragma mark - 加入更多圈子 点击事件
- (void)gestureButtonClick:(UIButton *)button {
    [self giveCommumityContent:@"社区" andBbsType:5];
}

#pragma mark - 寻圈子跳转刷新
- (void)giveCommumityContent:(NSString *)bbsMark andBbsType:(float)bbsType {
    self.tabBarController.selectedIndex = 3;
    ODCommumityViewController *vc = self.tabBarController.selectedViewController.childViewControllers[0];
    vc.bbsMark = bbsMark;
    vc.bbsType = bbsType;
    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationSearchCircle object:nil];
}

#pragma mark - 用户头像 点击事件
- (void)headButtonClick:(UIButton *)button {
    ODBazaarExchangeSkillCollectionCell *cell = (ODBazaarExchangeSkillCollectionCell *) button.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    vc.open_id = model.user.open_id;
    
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:model.user.open_id]) {
    }
    else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 技能交换图片 点击事件
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

#pragma mark - 了解更多技能 点击事件
- (void)moreSkillButtonClick:(UIButton *)button {
    self.tabBarController.selectedIndex = 2;
    ODBazaarViewController *vc = self.tabBarController.childViewControllers[2].childViewControllers[0];
    vc.index = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationReleaseSkill object:nil];
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
