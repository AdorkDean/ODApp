//
//  ODSelectAddressViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/4/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODSelectAddressViewController.h"
#import "ODSelectAddressCell.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "ZHSearch.h"

static NSString *cellId = @"ODSelectAddressCell";

@interface ODSelectAddressViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic ,strong) MAMapView * mapView;
@property (nonatomic ,strong) AMapSearchAPI * mapSearchAPI;
@property (nonatomic ,strong) MAUserLocation * currentLocation;
@property (nonatomic ,strong) NSMutableDictionary * userLocationDict;
@property (nonatomic ,strong) UISearchBar *searchBar;
@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) ZHSearch *search;

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
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    [self.mapView setZoomLevel:20 animated:YES];
    
    self.mapSearchAPI = [[AMapSearchAPI alloc] init];
    self.mapSearchAPI.delegate = self;
    [self.view addSubview:self.mapView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//    pointAnnotation.coordinate = CLLocationCoordinate2DMake(31.286952094415877, 121.50222749809993);
    [self.mapView addAnnotation:pointAnnotation];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始胡导航
-(void)navigationInit{
//    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
//    [[[[self.searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
//    self.searchBar.backgroundColor = [UIColor whiteColor];
//    self.searchBar.delegate = self;
//    self.searchBar.placeholder = @"请输入你的地址";
//    self.navigationItem.titleView = self.searchBar;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ODSelectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithNSDictionary:self.dataArray[indexPath.row] index:indexPath];
    return cell;
}

#pragma mark - UITabeleDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - AMapSearchDelegate
//地图定位成功回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        
        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeo.radius = 1000;
        regeo.requireExtension = YES;
        
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
    if (response.pois.count == 0) {
        return;
    }
    
    for (AMapPOI *p in response.pois) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:p.name forKey:@"name"];
        [dict setObject:[NSString stringWithFormat:@"%@%@%@",p.city,p.district,p.address] forKey:@"detail"];
        [self.dataArray addObject:dict];
    }
    [self.tableView reloadData];
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

        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [ODUserInformation sharedODUserInformation].locationCity = cityResult;
            
        }]];
    
    }
    
}



@end
