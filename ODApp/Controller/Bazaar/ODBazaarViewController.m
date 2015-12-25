//
//  ODBazaarViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBazaarViewController.h"

@interface ODBazaarViewController ()

@end

@implementation ODBazaarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self navigationInit];
    [self createScreeningAndSearchButton];
    [self createRequest];
    [self createCollectionView];
    [self joiningTogetherParmeters];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 117) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 32, 80, 20) text:@"欧动集市" font:16 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    //发布任务按钮
    UIButton *releaseButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 110, 32,95, 20) target:self sel:@selector(releaseButtonClick:) tag:0 image:nil title:@"发布任务" font:16];
    [releaseButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    releaseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.headView addSubview:releaseButton];
    
    UIImageView *releaseImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(0, 0, 20, 20) imageName:@"发布任务icon" tag:0];
    [releaseButton addSubview:releaseImageView];
}

-(void)releaseButtonClick:(UIButton *)button
{
    ODBazaarReleaseTaskViewController *releaseTask = [[ODBazaarReleaseTaskViewController alloc]init];
    [self.navigationController pushViewController:releaseTask animated:YES];
}

#pragma mark -创建任务筛选和搜索按钮
-(void)createScreeningAndSearchButton
{
    //任务筛选
    UIButton *screeningButton = [ODClassMethod creatButtonWithFrame:CGRectMake(10, 75, 100, 35) target:self sel:@selector(screeningButtonClick:) tag:0 image:nil title:@"任务筛选" font:15];
    [screeningButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    screeningButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    screeningButton.layer.masksToBounds = YES;
    screeningButton.layer.cornerRadius = 10;
    screeningButton.layer.borderColor = [ODColorConversion colorWithHexString:@"484848" alpha:1].CGColor;
    screeningButton.layer.borderWidth = 1;
    [self.headView addSubview:screeningButton];
    
    UIImageView *screeningIamgeView = [ODClassMethod creatImageViewWithFrame:CGRectMake(75, 12, 16, 12) imageName:@"任务筛选下拉箭头" tag:0];
    [screeningButton addSubview:screeningIamgeView];
    
    UIButton *searchButton = [ODClassMethod creatButtonWithFrame:CGRectMake(115, 75, kScreenSize.width-125, 35) target:self sel:@selector(searchButtonClick:) tag:0 image:nil title:@"请输入您要搜索的关键字" font:15];
    [searchButton setTitleColor:[ODColorConversion colorWithHexString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 10;
    searchButton.layer.borderColor = [ODColorConversion colorWithHexString:@"484848" alpha:1].CGColor;
    searchButton.layer.borderWidth = 1;
    searchButton.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.headView addSubview:searchButton];
    
    UIImageView *searchImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(20, 10, 16, 16) imageName:@"搜索放大镜icon" tag:0];
    [searchButton addSubview:searchImageView];
}

-(void)screeningButtonClick:(UIButton *)button
{
    UIViewController *controller = [[UIViewController alloc]init];
    controller.view.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    NSArray *array = @[@"全部",@"等待派遣",@"已派遣",@"已完成",@"已过期"];
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 30*i, 100, 30);
        button.tag = i+10;
        [button setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [controller.view addSubview:button];
        }
    //设置弹出模式
    controller.modalPresentationStyle = UIModalPresentationPopover;
    controller.preferredContentSize = CGSizeMake(100, 150);
    UIPopoverPresentationController *popVC = controller.popoverPresentationController;
    controller.popoverPresentationController.sourceView = button;
    controller.popoverPresentationController.sourceRect = button.bounds;
    popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popVC.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}


-(void)buttonClick:(UIButton *)button
{
    [self.dataArray removeAllObjects];
    if (button.tag==10) {
        [self joiningTogetherParmeters];
    }else if (button.tag == 11){
        self.status = @"1";
        [self joiningTogetherParmetersWithTaskStatus];
    }else if (button.tag == 12){
        self.status = @"2";
        [self joiningTogetherParmetersWithTaskStatus];
    }else if (button.tag == 13){
        self.status = @"4";
        [self joiningTogetherParmetersWithTaskStatus];
    }else{
        self.status = @"-2";
        [self joiningTogetherParmetersWithTaskStatus];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 根据任务状态拼接参数
-(void)joiningTogetherParmetersWithTaskStatus
{
    NSDictionary *parameter = @{@"task_status":self.status};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kBazaarUnlimitTaskUrl paramater:signParameter];
}
#pragma mark - pop协议方法

//如果要想在iPhone上也能弹出泡泡的样式必须要实现下面协议的方法
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

-(void)searchButtonClick:(UIButton *)button
{
    ODBazaarLabelSearchViewController *labelSearch = [[ODBazaarLabelSearchViewController alloc]init];
    [self.navigationController pushViewController:labelSearch animated:YES];
}

#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc]init];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    NSDictionary *parameter = @{};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kBazaarUnlimitTaskUrl paramater:signParameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)parameter
{
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            NSArray *tasks = result[@"tasks"];
            for (NSDictionary *itemDict in tasks) {
                ODBazaarModel *model = [[ODBazaarModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.collectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 创建CollectionView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,117, kScreenSize.width, kScreenSize.height - 117 - 55) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [ODColorConversion colorWithHexString:@"#d9d9d9" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODBazaarCollectionCell" bundle:nil] forCellWithReuseIdentifier:kBazaarCellId];
    [self.collectionView registerClass:[ODBazaarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"supple"];
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
    ODBazaarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBazaarCellId forIndexPath:indexPath];
    ODBazaarModel *model = self.dataArray[indexPath.row];
    [cell shodDataWithModel:model];
    cell.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, 120);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *viewId = @"supple";
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ODBazaarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:viewId forIndexPath:indexPath];
        return headerView;
    }
    return nil;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenSize.width, 40);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc]init];
    ODBazaarModel *model = self.dataArray[indexPath.row];
    bazaarDetail.task_id = [NSString stringWithFormat:@"%@",model.task_id];
    [self.navigationController pushViewController:bazaarDetail animated:YES];
}

#pragma mark - 试图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 试图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
