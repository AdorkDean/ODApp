//
//  ODSelectAddressViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/4/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "masonry.h"
#import "ODSelectAddressViewController.h"
#import "ODSelectAddressCell.h"
#import <MAMapKit/MAMapKit.h>
#import "ODKeywordsSearchViewController.h"

static NSString *cellId = @"ODSelectAddressCell";

@interface ODSelectAddressViewController ()<UISearchBarDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic ,strong) MAMapView * mapView;
@property (nonatomic ,strong) AMapSearchAPI * mapSearchAPI;
@property (nonatomic ,strong) MAPointAnnotation *pointAnnotation;

@property (nonatomic ,strong) MAUserLocation * currentLocation;
@property (nonatomic ,strong) NSMutableDictionary * userLocationDict;

@property (nonatomic ,strong) UISearchBar *searchBar;
@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,copy) NSString *city;



@end

@implementation ODSelectAddressViewController

#pragma lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mapView.frame), kScreenSize.width, kScreenSize.height-300) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        [_tableView registerNib:[UINib nibWithNibName:@"ODSelectAddressCell" bundle:nil] forCellReuseIdentifier:cellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self navigationInit];
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 300)];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.mapType = MAMapTypeStandard;
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES];//地图跟着位置移动
    [self.mapView setZoomLevel:20 animated:YES];
    
    self.mapSearchAPI = [[AMapSearchAPI alloc] init];
    self.mapSearchAPI.delegate = self;
    [self.view addSubview:self.mapView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"icon_location_origin"] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.frame = CGRectMake(20, 200, btn.od_width, btn.od_height);
    [btn addTarget:self action:@selector(backToOrigin) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:btn];
    
    [self createImageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始胡导航
-(void)navigationInit{
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width-100, 30)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor whiteColor];
    [view addGestureRecognizer:tapGesture];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"icon_search"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+15, 0, view.frame.size.width-50, 30)];
    label.text = @"请输入你的地址";
    label.textColor = [UIColor colorGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    self.navigationItem.titleView = view;
}

-(void)createImageView{
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage imageNamed:@"bbbb"];
    [self.imageView sizeToFit];
    self.imageView.od_centerY = self.mapView.od_centerY-50;
    self.imageView.od_centerX = self.mapView.od_centerX;
    [self.mapView addSubview:self.imageView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ODSelectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithAMapPOI:self.dataArray[indexPath.row] index:indexPath];
    return cell;
}

#pragma mark - UITabeleDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapPOI *poi = self.dataArray [indexPath.row];
    if (self.myBlock) {
        self.myBlock(poi.name,poi.address,poi.location);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MAAnnotationViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"aaaa"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        return annotationView;
    }
    return nil;
}


#pragma mark - MAMapViewDelegate
//地图定位成功回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        self.mapView.showsUserLocation = NO;
        [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        
        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeo.radius = 1000;
        regeo.requireExtension = YES;
    
        
        //点标注
        self.pointAnnotation = [[MAPointAnnotation alloc] init];
        self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [self.mapView addAnnotation:self.pointAnnotation];
        
        self.currentLocation = userLocation;
        //发起逆地理编码
        [self.mapSearchAPI AMapReGoecodeSearch:regeo];
        
        //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        
        request.keywords = @"";
        request.sortrule = 0;
        request.requireExtension = YES;
        
        //发起周边搜索
        [self.mapSearchAPI AMapPOIAroundSearch:request];
    }
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOIAroundSearchRequest *)request response:(AMapPOISearchResponse *)response {
    [self.dataArray removeAllObjects];
    if (response.pois.count == 0) {
        return;
    }
    
    for (AMapPOI *poi in response.pois) {
        [self.dataArray addObject:poi];
    }
    [self.tableView reloadData];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        self.city = [NSString stringWithFormat:@"%@", response.regeocode.addressComponent.province];
    }
    
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
    request.keywords = @"";
    request.sortrule = 0;
    request.requireExtension = YES;
    //发起周边搜索
    [self.mapSearchAPI AMapPOIAroundSearch:request];
}


-(void)tapGestureClick:(UITapGestureRecognizer *)tap{
    ODKeywordsSearchViewController *keywords = [[ODKeywordsSearchViewController alloc]init];
    keywords.city = self.city;
    [self.navigationController pushViewController:keywords animated:YES];
}

- (void)backToOrigin
{
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
    [self.mapView setZoomLevel:20 animated:YES];
}
@end
