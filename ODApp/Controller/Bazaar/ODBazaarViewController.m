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
    
    
    self.count = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self navigationInit];
    [self createScreeningAndSearchButton];
    [self createRequest];
    [self createCollectionView];
    self.status = @"9";
    [self joiningTogetherParmeters];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self joiningTogetherParmeters];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];

}
#pragma mark - 加载更多
-(void)loadMoreData
{
    self.count ++;
    NSDictionary *parameter = @{@"task_status":self.status,@"page":[NSString stringWithFormat:@"%ld",self.count]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kBazaarUnlimitTaskUrl paramater:signParameter];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 117) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 28, 80, 20) text:@"欧动集市" font:17 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    //发布任务按钮
    UIButton *releaseButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 110, 16,95, 44) target:self sel:@selector(releaseButtonClick:) tag:0 image:nil title:@"发布任务" font:16];
    [releaseButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    releaseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.headView addSubview:releaseButton];
    
    UIImageView *releaseImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(0, 12, 20, 20) imageName:@"发布任务icon" tag:0];
    [releaseButton addSubview:releaseImageView];
}

-(void)releaseButtonClick:(UIButton *)button
{
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
       
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc]init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];

    }else{
        ODBazaarReleaseTaskViewController *releaseTask = [[ODBazaarReleaseTaskViewController alloc]init];
        releaseTask.isBazaar = YES;
        
        releaseTask.myBlock = ^(NSString *release){
            self.refresh = release;
        };
        [self.navigationController pushViewController:releaseTask animated:YES];
    }
}

#pragma mark -创建任务筛选和搜索按钮
-(void)createScreeningAndSearchButton
{
    //任务筛选
    self.screeningButton = [ODClassMethod creatButtonWithFrame:CGRectMake(10, 75, 100, 35) target:self sel:@selector(screeningButtonClick:) tag:0 image:nil title:@"全部" font:15];
    [self.screeningButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    self.screeningButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    self.screeningButton.layer.masksToBounds = YES;
    self.screeningButton.layer.cornerRadius = 10;
    self.screeningButton.layer.borderColor = [UIColor colorWithHexString:@"484848" alpha:1].CGColor;
    self.screeningButton.layer.borderWidth = 1;
    [self.headView addSubview:self.screeningButton];
    
    UIImageView *screeningIamgeView = [ODClassMethod creatImageViewWithFrame:CGRectMake(75, 12, 16, 12) imageName:@"任务筛选下拉箭头" tag:0];
    [self.screeningButton addSubview:screeningIamgeView];
    
    UIButton *searchButton = [ODClassMethod creatButtonWithFrame:CGRectMake(115, 75, kScreenSize.width-125, 35) target:self sel:@selector(searchButtonClick:) tag:0 image:nil title:@"  请输入您要搜索的关键字" font:15];
    [searchButton setTitleColor:[UIColor colorWithHexString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 10;
    searchButton.layer.borderColor = [UIColor colorWithHexString:@"484848" alpha:1].CGColor;
    searchButton.layer.borderWidth = 1;
    searchButton.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.headView addSubview:searchButton];
    
    UIImageView *searchImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(7, 10, 16, 16) imageName:@"搜索放大镜icon" tag:0];
    [searchButton addSubview:searchImageView];
}

-(void)screeningButtonClick:(UIButton *)button
{
    UIViewController *controller = [[UIViewController alloc]init];
    controller.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    NSArray *array = @[@"待派遣",@"正在完成",@"已完成",@"已过期",@"全部"];
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 30*i, 100, 30);
        button.tag = i+10;
        [button setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
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
    
    [self presentViewController:controller animated:YES completion:^{
    }];
}


-(void)buttonClick:(UIButton *)button
{
    if (button.tag==10) {
        self.status = @"1";
        [self.screeningButton setTitle:@"待派遣" forState:UIControlStateNormal];
        [self joiningTogetherParmetersWithTaskStatus];
    }else if (button.tag == 11){
        self.status = @"2";
        [self.screeningButton setTitle:@"正在完成" forState:UIControlStateNormal];
        [self joiningTogetherParmetersWithTaskStatus];
    }else if (button.tag == 12){
        self.status = @"4";
        [self.screeningButton setTitle:@"已完成" forState:UIControlStateNormal];
        [self joiningTogetherParmetersWithTaskStatus];
    }else if (button.tag == 13){
        self.status = @"-2";
        [self.screeningButton setTitle:@"已过期" forState:UIControlStateNormal];
        [self joiningTogetherParmetersWithTaskStatus];
    }else{
        self.status = @"9";
        [self.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [self joiningTogetherParmeters];
    }
    [self.collectionView.mj_header beginRefreshing];
    
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

#pragma mark - 根据任务状态拼接参数
-(void)joiningTogetherParmetersWithTaskStatus
{
    self.count = 1;
    NSDictionary *parameter = @{@"task_status":self.status,@"page":[NSString stringWithFormat:@"%ld",self.count]};
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
    self.count = 1;
    NSDictionary *parameter = @{@"task_status":self.status,@"page":[NSString stringWithFormat:@"%ld",self.count],@" city_id":@"321"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kBazaarUnlimitTaskUrl paramater:signParameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)parameter
{
  
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
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
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            
            if (tasks.count == 0) {
                [weakSelf.collectionView.mj_footer noticeNoMoreData];
            }
           
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"网络异常"];

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
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
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
    
    [cell.headButton addTarget:self action:@selector(othersInformationClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell shodDataWithModel:model];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    return cell;
}

- (void)othersInformationClick:(UIButton *)button
{
    ODBazaarCollectionCell *cell = (ODBazaarCollectionCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODBazaarModel *model = self.dataArray[indexPath.row];
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    vc.open_id = model.open_id;
    
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:model.open_id]) {
        
    }else{
      
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    bazaarDetail.task_status_name = [NSString stringWithFormat:@"%@",model.task_status_name];
    bazaarDetail.open_id = [NSString stringWithFormat:@"%@",model.open_id];
    bazaarDetail.myBlock = ^(NSString *del){
        self.refresh = del;
    };
    if ([self.refresh isEqualToString:@"accept"]) {
        [bazaarDetail.taskButton setTitle:@"待派遣" forState:UIControlStateNormal];
    }
    [self.navigationController pushViewController:bazaarDetail animated:YES];

}

#pragma mark - 试图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    if ([self.refresh isEqualToString:@"release"]) {
        self.status = @"9";
        [self.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [self.collectionView.mj_header beginRefreshing];
    }else if ([self.refresh isEqualToString:@"del"]){
        [self.collectionView.mj_header beginRefreshing];
    }else if ([self.refresh isEqualToString:@"accept"]){
        [self.collectionView.mj_header beginRefreshing];
    }else if ([self.refresh isEqualToString:@"submit"]){
        [self.collectionView.mj_header beginRefreshing];
    }else if ([self.refresh isEqualToString:@"complete"]){
        [self.collectionView.mj_header beginRefreshing];
    }
    if (self.navigationController.childViewControllers.count > 1) {
        self.status = @"9";
        [self.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [self.collectionView.mj_header beginRefreshing];
    }


    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 试图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    self.refresh = @"";
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
