//
//  ODLocationController.m
//  ODApp
//
//  Created by 代征钏 on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODLocationController.h"

NSString *const ODLocationCellID = @"ODLocationCell";

@interface ODLocationController ()
{

    AMapSearchAPI *_search;
    MAMapView *_mapView;
}

@end

@implementation ODLocationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"选择城市";
    
    self.cityListArray = [[NSMutableArray alloc] init];
    self.cityIdArray = [[NSMutableArray alloc] init];
    [self createCollectionView];
    [self getCityListRequest];
    
}

- (void)getCityListRequest
{

    NSDictionary *parameter = @{@"region_name":@"上海"};
    [ODHttpTool getWithURL:ODCityListUrl parameters:parameter modelClass:[ODLocationModel class] success:^(id model) {
        
        ODLocationModel *mode = [model result];
        self.cityListArray = [mode.all valueForKeyPath:@"name"];
        self.cityIdArray = [mode.all valueForKey:@"id"];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)createCollectionView
{

    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight) collectionViewLayout:self.flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLocationCell" bundle:nil] forCellWithReuseIdentifier:ODLocationCellID];
    
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ODLocationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ODLocationCellID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    
    cell.cityNameLabel.text = self.cityListArray[indexPath.row];
    return cell;

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cityListArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [ODUserInformation sharedODUserInformation].locationCity = self.cityListArray[indexPath.row];
    [ODUserInformation sharedODUserInformation].cityID = [self.cityIdArray[indexPath.row] integerValue];
    [self.navigationController popViewControllerAnimated:YES];

}


//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width , 40);
}

//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 1;
}


////地图定位成功回调
//-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
//updatingLocation:(BOOL)updatingLocation{
//    if (updatingLocation) {
//        _mapView.showsUserLocation = NO;
//        [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
//        
//        //构造AMapReGeocodeSearchRequest对象
//        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
//        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//        regeo.radius = 10000;
//        regeo.requireExtension = YES;
//        
//        //发起逆地理编码
//        [_search AMapReGoecodeSearch: regeo];
//        
//        //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
//        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
//        request.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//        
//        // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
//        // POI的类型共分为20种大类别，分别为：
//        // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
//        // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
//        // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
//        request.keywords = @"";
//        request.types = @"";
//        request.sortrule = 0;
//        request.requireExtension = YES;
//        
//        //发起周边搜索
//        [_search AMapPOIAroundSearch: request];
//    }
//}
//
////实现POI搜索对应的回调函数
//- (void)onPOISearchDone:(AMapPOIAroundSearchRequest *)request response:(AMapPOISearchResponse *)response
//{
//    if(response.pois.count == 0)
//    {
//        return;
//    }
//    //通过 AMapPOISearchResponse 对象处理搜索结果
//    for (AMapPOI *p in response.pois) {
//        NSString *strPoi = [NSString stringWithFormat:@"%@", p.name];
//        
//        NSLog(@"strPoi ->____%@" , strPoi);
//    }
//}
//
////实现逆地理编码的回调函数
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
//{
//    if(response.regeocode != nil)
//    {
//        //通过AMapReGeocodeSearchResponse对象处理搜索结果
//        NSString *result = [NSString stringWithFormat:@"%@", response.regeocode.addressComponent.city];
//        if (result.length == 0) {
//            result = [NSString stringWithFormat:@"%@", response.regeocode.addressComponent.province];
//        }
//        
//        [ODUserInformation sharedODUserInformation].locationCity = result;
//    }
//}
//
////中心标识图像
//-(UIImageView *)centerImageView{
//    if (!_centerImageView) {
//        UIImageView *centerImageView = [[UIImageView alloc] init];
//        centerImageView.image = [UIImage imageNamed:@"dingwei"];
//        centerImageView.bounds = CGRectMake(0, 0, 20, 20);
//        
//        CGSize imageSize = centerImageView.image.size;
//        centerImageView.center = CGPointMake( _mapView.center.x, _mapView.center.y-imageSize.height/2);
//        _centerImageView = centerImageView;
//    }
//    return _centerImageView;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
