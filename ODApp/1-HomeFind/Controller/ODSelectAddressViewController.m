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

@interface ODSelectAddressViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic ,strong) MAMapView * mapView;
@property (nonatomic ,strong) AMapSearchAPI * mapSearchAPI;
@property (nonatomic ,strong) MAPointAnnotation *pointAnnotation;
@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UIImageView *imageView;


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
    [self mapViewInit];
    [self mapSearchAPIInit];
    [self createImageView];
    [self createOriginButton];
}


#pragma mark - 初始胡导航
-(void)navigationInit{
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width-70, 30)];
    self.textField.placeholder = @"请输入你的地址";
    self.textField.font = [UIFont systemFontOfSize:15];
    self.textField.delegate = self;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius = 5;
    [self.textField addTarget:self action:@selector(tapGestureClick) forControlEvents:UIControlEventEditingDidBegin];
    
    UIImageView *searchIcon = [[UIImageView alloc]init];
    searchIcon.image = [UIImage imageNamed:@"icon_search"];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.od_size = CGSizeMake(30,30);
    
    self.textField.leftView = searchIcon;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.navigationItem.titleView = self.textField;
}


#pragma mark - 初始化地图控件
-(void)mapViewInit{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 300)];
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.zoomEnabled = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.skyModelEnable = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MAMapTypeStandard;
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    [self.mapView setZoomLevel:19 animated:YES];
    [self.view addSubview:self.mapView];
}


-(void)mapSearchAPIInit{
    self.mapSearchAPI = [[AMapSearchAPI alloc] init];
    self.mapSearchAPI.delegate = self;
}


#pragma mark - 初始化按钮
-(void)createOriginButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"icon_location_coord"] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.frame = CGRectMake(kScreenSize.width-50, 10, btn.od_width, btn.od_height);
    [btn addTarget:self action:@selector(backToOrigin) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:btn];
}

-(void)createImageView{
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage imageNamed:@"bbbb"];
    [self.imageView sizeToFit];
    self.imageView.od_centerY = self.mapView.od_centerY-45;
    self.imageView.od_centerX = self.mapView.od_centerX;
    [self.mapView addSubview:self.imageView];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ODSelectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil){
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"aaaa"];
        return annotationView;
    }
    return nil;
}


#pragma mark - MAMapViewDelegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        self.mapView.showsUserLocation = NO;
        [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        
        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeo.radius = 3000;
        regeo.requireExtension = YES;
        
        self.pointAnnotation = [[MAPointAnnotation alloc] init];
        self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        [self.mapView addAnnotation:self.pointAnnotation];
        
        //发起逆地理编码
        [self.mapSearchAPI AMapReGoecodeSearch:regeo];
        
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        request.keywords = @"";
        request.sortrule = 0;
        request.offset = 30;
        request.requireExtension = YES;
        //发起周边搜索
        [self.mapSearchAPI AMapPOIAroundSearch:request];
    }
    if (self.lat.length) {
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake([self.lat doubleValue], [self.lng doubleValue]);
    }
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
    request.keywords = @"";
    request.sortrule = 0;
    request.offset = 30;
    request.requireExtension = YES;
    //发起周边搜索
    [self.mapSearchAPI AMapPOIAroundSearch:request];
}

//- (void)mapViewDidFinishLoadingMap:(MAMapView *)mapView dataSize:(NSInteger)dataSize{
//    NSLogFunc
//    if (self.lat.length) {
//        self.mapView.centerCoordinate = CLLocationCoordinate2DMake([self.lat doubleValue], [self.lng doubleValue]);
//    }
//}


#pragma mark - AMapSearchDelegate
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

#pragma mark - action
-(void)tapGestureClick{
    ODKeywordsSearchViewController *keywords = [[ODKeywordsSearchViewController alloc]init];
    [self.navigationController pushViewController:keywords animated:YES];
}

- (void)backToOrigin{
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
    [self.mapView setZoomLevel:19 animated:YES];
}


@end
