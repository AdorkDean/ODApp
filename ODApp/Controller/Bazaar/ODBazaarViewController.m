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
    [self createTableView];
    [self createTableViewHeaderView];
    [self joiningTogetherParmeters];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 117) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 32, 80, 20) text:@"欧动集市" font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    //发布任务按钮
    UIButton *releaseButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 110, 32,95, 20) target:self sel:@selector(releaseButtonClick:) tag:0 image:nil title:@"发布任务" font:17];
    [releaseButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    releaseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.headView addSubview:releaseButton];
    
    UIImageView *releaseImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(0, 0, 20, 20) imageName:@"发布任务icon" tag:0];
    [releaseButton addSubview:releaseImageView];
}

-(void)releaseButtonClick:(UIButton *)button
{
    
}

#pragma mark -创建任务筛选和搜索按钮
-(void)createScreeningAndSearchButton
{
    //任务筛选
    UIButton *screeningButton = [ODClassMethod creatButtonWithFrame:CGRectMake(10, 75, 112, 35) target:self sel:@selector(screeningButtonClick:) tag:0 image:nil title:@"任务筛选" font:16];
    [screeningButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    screeningButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    screeningButton.layer.masksToBounds = YES;
    screeningButton.layer.cornerRadius = 10;
    screeningButton.layer.borderColor = [ODColorConversion colorWithHexString:@"484848" alpha:1].CGColor;
    screeningButton.layer.borderWidth = 1;
    [self.headView addSubview:screeningButton];
    
    UIImageView *screeningIamgeView = [ODClassMethod creatImageViewWithFrame:CGRectMake(85, 12, 20, 12) imageName:@"任务筛选下拉箭头" tag:0];
    [screeningButton addSubview:screeningIamgeView];
    
    UIButton *searchButton = [ODClassMethod creatButtonWithFrame:CGRectMake(127, 75, kScreenSize.width-137, 35) target:self sel:@selector(searchButtonClick:) tag:0 image:nil title:@"请输入您要搜索的关键字" font:16];
    [searchButton setTitleColor:[ODColorConversion colorWithHexString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 10;
    searchButton.layer.borderColor = [ODColorConversion colorWithHexString:@"484848" alpha:1].CGColor;
    searchButton.layer.borderWidth = 1;
    searchButton.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.headView addSubview:searchButton];
    
    UIImageView *searchImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(15, 7, 20, 20) imageName:@"搜索放大镜icon" tag:0];
    [searchButton addSubview:searchImageView];
}

-(void)screeningButtonClick:(UIButton *)button
{
    
}

-(void)searchButtonClick:(UIButton *)button
{
    
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
    [self downLoadDataWithUrl:kUnlimitTaskUrl paramater:signParameter];
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
            [weakSelf.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 创建tableView
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 117, kScreenSize.width, kScreenSize.height - 117 -55) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ODBazaarViewCell" bundle:nil] forCellReuseIdentifier:kBazaarCellId];
    [self.view addSubview:self.tableView];
}

#pragma mark - 创建tableView的头视图
-(void)createTableViewHeaderView
{
    UIView *view = [ODClassMethod creatViewWithFrame:CGRectMake(0, 117, kScreenSize.width, 40) tag:0 color:@"#ffffff"];
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 7.5, 100, 25) text:@"最新任务" font:16 alignment:@"left" color:@"#000000" alpha:1];
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 39, kScreenSize.width , 1) tag:0 color:@"#f3f3f3"];
    [view addSubview:label];
    [view addSubview:lineView];
    self.tableView.tableHeaderView = view;
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBazaarCellId];
    ODBazaarModel *model = self.dataArray[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 10) tag:0 color:@"#d9d9d9"];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.dataArray.count-1) {
        return 0;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
