//
//  ODBazaarRequestHelpViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBazaarRequestHelpViewController.h"

#define kBazaarCellId @"ODBazaarCollectionCell"

@interface ODBazaarRequestHelpViewController ()

@end

@implementation ODBazaarRequestHelpViewController

#pragma mark - lazyLoad
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = CGSizeMake(kScreenSize.width, 107);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 55, kScreenSize.width, kScreenSize.height - 64 - 95 - 55) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
        [_collectionView registerNib:[UINib nibWithNibName:@"ODBazaarCollectionCell" bundle:nil] forCellWithReuseIdentifier:kBazaarCellId];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma mark -创建任务筛选和搜索按钮
- (void)createScreeningAndSearchButton {
    //任务筛选
    self.screeningButton = [ODClassMethod creatButtonWithFrame:CGRectMake(10, 10, 112, 35) target:self sel:@selector(screeningButtonClick:) tag:0 image:nil title:@"任务筛选" font:15];
    [self.screeningButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    self.screeningButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    self.screeningButton.layer.masksToBounds = YES;
    self.screeningButton.layer.cornerRadius = 5;
    self.screeningButton.layer.borderColor = [UIColor colorWithHexString:@"484848" alpha:1].CGColor;
    self.screeningButton.layer.borderWidth = 1;
    [self.view addSubview:self.screeningButton];
    
    UIImageView *screeningIamgeView = [ODClassMethod creatImageViewWithFrame:CGRectMake(85, 13, 15, 9) imageName:@"任务筛选下拉箭头" tag:0];
    screeningIamgeView.tag = 10010;
    [self.screeningButton addSubview:screeningIamgeView];
    
    UITapGestureRecognizer *searchGestuer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchButtonClick)];
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame) + 5, 10, kScreenSize.width - 137, 35)];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 5;
    searchView.layer.borderColor = [UIColor colorWithHexString:@"484848" alpha:1].CGColor;
    searchView.layer.borderWidth = 1;
    [searchView addGestureRecognizer:searchGestuer];
    searchView.tag = 10011;
    [self.view addSubview:searchView];
    
    UIImageView *searchImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(15, 10, 15, 15) imageName:@"搜索放大镜icon" tag:0];
    [searchView addSubview:searchImageView];
    
    UILabel *seacrhLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchImageView.frame)+10, 10, searchView.frame.size.width-40, 15)];
    seacrhLabel.text = @"请输入您要搜索的关键字";
    seacrhLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    seacrhLabel.font = [UIFont systemFontOfSize:15];
    seacrhLabel.tag = 10012;
    [searchView addSubview:seacrhLabel];
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    __weakSelf

    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationShowBazaar object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {

        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"任务筛选" forState:UIControlStateNormal];
        [weakSelf.collectionView.mj_header beginRefreshing];

    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationReleaseTask object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {

        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [weakSelf.collectionView.mj_header beginRefreshing];

    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationLocationSuccessRefresh object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];


    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationQuit object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        weakSelf.status = @"9";
        [weakSelf.screeningButton setTitle:@"任务筛选" forState:UIControlStateNormal];
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];

    self.count = 1;
    self.status = @"9";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createScreeningAndSearchButton];
    [self requestData];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.count = 1;
        [weakSelf requestData];
    }];

    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    [self.collectionView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.refresh isEqualToString:@"release"]) {
        self.status = @"9";
        [self.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [self.collectionView.mj_header beginRefreshing];
    } else if ([self.refresh isEqualToString:@"del"]) {
        [self.dataArray removeObjectAtIndex:self.indexPath];
        [self.collectionView reloadData];
    }
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.refresh = @"";
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 数据请求
- (void)loadMoreData {
    self.count++;
    [self requestData];
}

-(void)requestData
{
    NSDictionary *parameter = @{@"task_status" : self.status, @"page" : [NSString stringWithFormat:@"%ld", (long)self.count], @"city_id" : [NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID]};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlBazaarRequestHelp parameters:parameter modelClass:[ODBazaarRequestHelpModel class] success:^(ODBazaarRequestHelpModelResponse *model) {
    
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        
        ODBazaarRequestHelpModel *helpModel = [model result];
        for (ODBazaarRequestHelpTasksModel *taskModel in helpModel.tasks) {
            [weakSelf.dataArray addObject:taskModel];
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBazaarCellId forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    [cell.headButton addTarget:self action:@selector(othersInformationClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc] init];
    ODBazaarRequestHelpTasksModel *model = self.dataArray[indexPath.row];
    bazaarDetail.task_id = [NSString stringWithFormat:@"%d", model.task_id];
    bazaarDetail.task_status_name = [NSString stringWithFormat:@"%@", model.task_status_name];
    bazaarDetail.open_id = [NSString stringWithFormat:@"%@", model.open_id];
    bazaarDetail.myBlock = ^(NSString *del) {
        self.refresh = del;
    };
    if ([self.refresh isEqualToString:@"accept"]) {
        [bazaarDetail.taskButton setTitle:@"待派遣" forState:UIControlStateNormal];
    }
    self.indexPath = indexPath.row;
    [self.navigationController pushViewController:bazaarDetail animated:YES];
}

#pragma mark - UIPopDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - action
-(void)screeningButtonClick:(UIButton *)button
{
    UIViewController *controller = [[UIViewController alloc]init];
    controller.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    NSArray *array = @[@"待派遣",@"正在完成",@"已完成",@"已过期",@"全部"];
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 30*i, 112, 29);
        button.tag = i+10;
        [button setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [controller.view addSubview:button];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(7, CGRectGetMaxY(button.frame)+0.5, 98, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [controller.view addSubview:lineView];
    }
    //设置弹出模式
    controller.modalPresentationStyle = UIModalPresentationPopover;
    controller.preferredContentSize = CGSizeMake(112, 150);
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
    UIImageView *imageView = (UIImageView *)[self.screeningButton viewWithTag:10010];
    UIView *view = (UIView *)[self.view viewWithTag:10011];
    UILabel *label = (UILabel *)[view viewWithTag:10012];
    if (button.tag==10) {
        self.status = @"1";
        [self.screeningButton setTitle:@"待派遣" forState:UIControlStateNormal];
        [self.screeningButton setFrame:CGRectMake(10, 10, 100, 35)];
        [imageView setFrame:CGRectMake(70, 13, 15, 9)];
        [view setFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame)+5, 10, kScreenSize.width-self.screeningButton.frame.size.width-25, 35)];
        [label setFrame:CGRectMake(40, 10, view.frame.size.width-40, 15)];
        [self requestData];
    } else if (button.tag == 11) {
        self.status = @"2";
        [self.screeningButton setTitle:@"正在完成" forState:UIControlStateNormal];
        [self.screeningButton setFrame:CGRectMake(10, 10, 112, 35)];
        [imageView setFrame:CGRectMake(85, 13, 15, 9)];
        [view setFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame)+5, 10, kScreenSize.width-self.screeningButton.frame.size.width-25, 35)];
        [label setFrame:CGRectMake(40, 10, view.frame.size.width-40, 15)];
        [self requestData];
    } else if (button.tag == 12) {
        self.status = @"4";
        [self.screeningButton setTitle:@"已完成" forState:UIControlStateNormal];
        [self.screeningButton setFrame:CGRectMake(10, 10, 100, 35)];
        [imageView setFrame:CGRectMake(70, 13, 15, 9)];
        [view setFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame)+5, 10, kScreenSize.width-self.screeningButton.frame.size.width-25, 35)];
        [label setFrame:CGRectMake(40, 10, view.frame.size.width-40, 15)];
        [self requestData];
        
    } else if (button.tag == 13) {
        self.status = @"-2";
        [self.screeningButton setTitle:@"已过期" forState:UIControlStateNormal];
        [self.screeningButton setFrame:CGRectMake(10, 10, 100, 35)];
        [imageView setFrame:CGRectMake(70, 13, 15, 9)];
        [view setFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame)+5, 10, kScreenSize.width-self.screeningButton.frame.size.width-25, 35)];
        [label setFrame:CGRectMake(40, 10, view.frame.size.width-40, 15)];
        [self requestData];
        
    } else {
        self.status = @"9";
        [self.screeningButton setTitle:@"全部" forState:UIControlStateNormal];
        [self.screeningButton setFrame:CGRectMake(10, 10, 85, 35)];
        [imageView setFrame:CGRectMake(55, 13, 15, 9)];
        [view setFrame:CGRectMake(CGRectGetMaxX(self.screeningButton.frame)+5, 10, kScreenSize.width-self.screeningButton.frame.size.width-25, 35)];
        [label setFrame:CGRectMake(40, 10, view.frame.size.width-40, 15)];
        [self requestData];
    }
    [self.collectionView.mj_header beginRefreshing];
    
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (void)searchButtonClick {
    ODBazaarLabelSearchViewController *labelSearch = [[ODBazaarLabelSearchViewController alloc] init];
    [self.navigationController pushViewController:labelSearch animated:YES];
}

- (void)othersInformationClick:(UIButton *)button {
    ODBazaarCollectionCell *cell = (ODBazaarCollectionCell *) button.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODBazaarModel *model = self.dataArray[indexPath.row];
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    vc.open_id = model.open_id;
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:model.open_id]) {
        
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
