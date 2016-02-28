//
//  ODBazaarRequestHelpViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBazaarRequestHelpViewController.h"

@interface ODBazaarRequestHelpViewController ()

@end

@implementation ODBazaarRequestHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weakSelf
    
    [[NSNotificationCenter defaultCenter]addObserverForName:ODNotificationShowBazaar object:nil queue:[NSOperationQueue mainQueue ] usingBlock:^(NSNotification * _Nonnull note) {
        
        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"任务筛选" forState:UIControlStateNormal];
        [weakSelf.collectionView.mj_header beginRefreshing];
        
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:ODNotificationReleaseTask object:nil queue:[NSOperationQueue mainQueue ] usingBlock:^(NSNotification * _Nonnull note) {
        
        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [weakSelf.collectionView.mj_header beginRefreshing];
        
    }];
    [[NSNotificationCenter defaultCenter]addObserverForName:ODNotificationLocationSuccessRefresh object:nil queue:[NSOperationQueue mainQueue ] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    
    
    [[NSNotificationCenter defaultCenter]addObserverForName:ODNotificationQuit object:nil queue:[NSOperationQueue mainQueue ] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"任务筛选" forState:UIControlStateNormal];
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    
    self.count = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createScreeningAndSearchButton];
    [self createRequest];
    [self createCollectionView];
    self.status = @"9";
    [self joiningTogetherParmeters];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf joiningTogetherParmeters];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
}

#pragma mark - 加载更多
-(void)loadMoreData
{
    self.count ++;
    NSDictionary *parameter = @{@"task_status":self.status,@"page":[NSString stringWithFormat:@"%ld",self.count]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kBazaarUnlimitTaskUrl paramater:signParameter];
}

#pragma mark -创建任务筛选和搜索按钮
-(void)createScreeningAndSearchButton
{
    //任务筛选
    self.screeningButton = [ODClassMethod creatButtonWithFrame:CGRectMake(10, 10, 100, 35) target:self sel:@selector(screeningButtonClick:) tag:0 image:nil title:@"任务筛选" font:15];
    [self.screeningButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    self.screeningButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    self.screeningButton.layer.masksToBounds = YES;
    self.screeningButton.layer.cornerRadius = 5;
    self.screeningButton.layer.borderColor = [UIColor colorWithHexString:@"484848" alpha:1].CGColor;
    self.screeningButton.layer.borderWidth = 1;
    [self.view addSubview:self.screeningButton];
    
    UIImageView *screeningIamgeView = [ODClassMethod creatImageViewWithFrame:CGRectMake(75, 12, 15, 12) imageName:@"任务筛选下拉箭头" tag:0];
    [self.screeningButton addSubview:screeningIamgeView];

    UITapGestureRecognizer *searchGestuer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchButtonClick)];
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame)+5, 10, kScreenSize.width-125, 35)];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 5;
    searchView.layer.borderColor = [UIColor colorWithHexString:@"484848" alpha:1].CGColor;
    searchView.layer.borderWidth = 1;
    [searchView addGestureRecognizer:searchGestuer];
    [self.view addSubview:searchView];
    
    UIImageView *searchImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(10, 10, 15, 15) imageName:@"search" tag:0];
    [searchView addSubview:searchImageView];
    
    UILabel *seacrhLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame)+10, 10, searchView.frame.size.width-35, 15)];
    seacrhLabel.text = @"请输入您要搜索的关键字";
    seacrhLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    seacrhLabel.font = [UIFont systemFontOfSize:15];
    [searchView addSubview:seacrhLabel];
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

-(void)searchButtonClick
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
    NSDictionary *parameter = @{@"task_status":self.status,@"page":[NSString stringWithFormat:@"%ld",self.count],@"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID]};
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
//        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
        [ODProgressHUD showInfoWithStatus:@"网络异常"];
        
    }];
}

#pragma mark - 创建CollectionView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,55, kScreenSize.width,kScreenSize.height-64-95-55) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODBazaarCollectionCell" bundle:nil] forCellWithReuseIdentifier:kBazaarCellId];
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
        self.indexPath = indexPath.row;
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
        [self.dataArray removeObjectAtIndex:self.indexPath];
        [self.collectionView reloadData];
    }else if ([self.refresh isEqualToString:@"accept"]){
       
    }else if ([self.refresh isEqualToString:@"submit"]){
     
    }else if ([self.refresh isEqualToString:@"complete"]){
        
    }else if ([self.refresh isEqualToString:@"delegate"]){
       
    }
}

#pragma mark - 试图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    self.refresh = @"";
    [super viewWillDisappear:animated];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
