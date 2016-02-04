//
//  ODLocationController.m
//  ODApp
//
//  Created by 代征钏 on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODLocationController.h"

@interface ODLocationController ()
{

    AMapSearchAPI *_search;
    MAMapView *_mapView;
}

@end

@implementation ODLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [MAMapServices sharedServices].apiKey = @"82b3b9feaca8b2c33829a156672a5fd0";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [_mapView setZoomLevel:20 animated:YES];
    [self.view addSubview:_mapView];
    
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = @"82b3b9feaca8b2c33829a156672a5fd0";
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
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
        
        [ODUserInformation sharedODUserInformation].locationCity = result;
    }
}

//中心标识图像
-(UIImageView *)centerImageView{
    if (!_centerImageView) {
        UIImageView *centerImageView = [[UIImageView alloc] init];
        centerImageView.image = [UIImage imageNamed:@"dingwei"];
        centerImageView.bounds = CGRectMake(0, 0, 20, 20);
        
        CGSize imageSize = centerImageView.image.size;
        centerImageView.center = CGPointMake( _mapView.center.x, _mapView.center.y-imageSize.height/2);
        _centerImageView = centerImageView;
    }
    return _centerImageView;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view addSubview:self.centerImageView];
    
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
